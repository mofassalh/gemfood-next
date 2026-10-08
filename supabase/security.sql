-- Gem Food: tighten database access rules (run once in the Supabase SQL Editor)
--
-- Before: any logged-in user could change menu, settings, staff, etc., and anyone
-- (even without login) could read and change every order.
-- After:  customers see only their own data, staff manage the restaurant,
--         visitors can read the menu and place an order.

begin;

-- 1) Helper functions -------------------------------------------------------

create or replace function public.is_staff() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from public.staff
    where auth_id = auth.uid() and active is not false
  );
$$;

create or replace function public.is_owner() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from public.staff
    where auth_id = auth.uid() and active is not false and role = 'owner'
  );
$$;

-- Links a staff row (added by the owner with an email) to the account that logs in
-- with that same email. Only fills an empty auth_id; never changes role or permissions.
create or replace function public.link_staff_account() returns setof public.staff
language plpgsql security definer set search_path = public as $$
begin
  if auth.uid() is null or auth.email() is null then
    return;
  end if;
  return query
    update public.staff
       set auth_id = auth.uid()
     where auth_id is null
       and lower(email) = lower(auth.email())
    returning *;
end;
$$;

-- How many times a coupon was already used by this phone number or this account.
create or replace function public.coupon_use_count(p_code text, p_phone text) returns integer
language sql stable security definer set search_path = public as $$
  select count(*)::int from public.orders
   where coupon_code = upper(p_code)
     and (
       (p_phone is not null and p_phone <> '' and customer_phone = p_phone)
       or (auth.uid() is not null and user_id = auth.uid())
     );
$$;

-- Counts one use of a coupon after an order is placed.
create or replace function public.use_promotion(p_id uuid) returns void
language sql security definer set search_path = public as $$
  update public.promotions
     set used_count = coalesce(used_count, 0) + 1
   where id = p_id and is_active is not false;
$$;

revoke all on function public.is_staff(), public.is_owner(), public.link_staff_account(),
  public.coupon_use_count(text, text), public.use_promotion(uuid) from public;
grant execute on function public.is_staff(), public.is_owner(), public.link_staff_account(),
  public.coupon_use_count(text, text), public.use_promotion(uuid) to anon, authenticated;

-- 2) Remove every old rule ---------------------------------------------------

do $$
declare p record;
begin
  for p in select schemaname, tablename, policyname from pg_policies where schemaname = 'public' loop
    execute format('drop policy %I on %I.%I', p.policyname, p.schemaname, p.tablename);
  end loop;
  for p in select policyname from pg_policies
            where schemaname = 'storage' and tablename = 'objects'
              and (coalesce(qual, '') like '%menu-images%' or coalesce(with_check, '') like '%menu-images%') loop
    execute format('drop policy %I on storage.objects', p.policyname);
  end loop;
end $$;

-- 3) New rules ---------------------------------------------------------------

-- Everyone can read, only staff can change
do $$
declare t text;
begin
  foreach t in array array[
    'categories','delivery_zones','faqs','gallery','locations','location_products',
    'loyalty_settings','menu_items','option_groups','pages','product_option_groups',
    'products','promotions','restaurants','site_settings'
  ] loop
    execute format('create policy "Anyone can read" on public.%I for select using (true)', t);
    execute format('create policy "Staff can manage" on public.%I for all using (public.is_staff()) with check (public.is_staff())', t);
  end loop;
end $$;

-- Staff only
do $$
declare t text;
begin
  foreach t in array array[
    'menu','modifiers','printers','report_locations','report_restaurants','report_weekly_data'
  ] loop
    execute format('create policy "Staff can manage" on public.%I for all using (public.is_staff()) with check (public.is_staff())', t);
  end loop;
end $$;

-- Settings: public values are readable by everyone; secret keys only by staff
create policy "Anyone can read public settings" on public.settings for select
  using (public.is_staff() or key !~* '(secret|token|password|signing|private)');
create policy "Staff can manage" on public.settings for all
  using (public.is_staff()) with check (public.is_staff());

-- Staff list: staff can see it, only the owner can change it
create policy "Staff can read staff" on public.staff for select
  using (public.is_staff() or auth_id = auth.uid());
create policy "Owner can manage staff" on public.staff for all
  using (public.is_owner()) with check (public.is_owner());

-- Orders: anyone can place one; customers see their own; staff see and update all
create policy "Anyone can place an order" on public.orders for insert
  with check (user_id is null or user_id = auth.uid());
create policy "Customers read own orders" on public.orders for select
  using (user_id = auth.uid() or public.is_staff());
create policy "Staff can update orders" on public.orders for update
  using (public.is_staff()) with check (public.is_staff());
create policy "Staff can delete orders" on public.orders for delete
  using (public.is_staff());

create policy "Customers read own order items" on public.order_items for select
  using (public.is_staff() or order_id in (select id from public.orders where user_id = auth.uid()));
create policy "Staff can manage" on public.order_items for all
  using (public.is_staff()) with check (public.is_staff());

-- Ratings, loyalty points, profiles: each customer their own; staff can read
create policy "Customers manage own ratings" on public.order_ratings for all
  using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "Staff can read ratings" on public.order_ratings for select
  using (public.is_staff());

create policy "Customers read own points" on public.loyalty_points for select
  using (user_id = auth.uid());
create policy "Customers add own points" on public.loyalty_points for insert
  with check (user_id = auth.uid());
create policy "Staff can manage" on public.loyalty_points for all
  using (public.is_staff()) with check (public.is_staff());

create policy "Customers manage own profile" on public.profiles for all
  using (id = auth.uid()) with check (id = auth.uid());
create policy "Staff can read profiles" on public.profiles for select
  using (public.is_staff());

-- Menu images: everyone can view, only staff can upload, replace or delete
create policy "Anyone can view menu images" on storage.objects for select
  using (bucket_id = 'menu-images');
create policy "Staff can upload menu images" on storage.objects for insert
  with check (bucket_id = 'menu-images' and public.is_staff());
create policy "Staff can replace menu images" on storage.objects for update
  using (bucket_id = 'menu-images' and public.is_staff());
create policy "Staff can delete menu images" on storage.objects for delete
  using (bucket_id = 'menu-images' and public.is_staff());

commit;

select count(*) as rules_now from pg_policies where schemaname = 'public';
