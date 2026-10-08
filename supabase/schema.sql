-- Gem Food database schema (structure copied from Angie's, no data)
begin;

create sequence if not exists public.restaurants_id_seq;

create table public."categories" (
  "id" uuid default gen_random_uuid() not null,
  "name" text not null,
  "slug" text not null,
  "display_order" integer default 0,
  "image_url" text,
  "is_active" boolean default true,
  "restaurant_id" integer default 1
);

create table public."delivery_zones" (
  "id" uuid default gen_random_uuid() not null,
  "suburb" text not null,
  "postcode" text,
  "fee" numeric default 5.00,
  "min_order" numeric default 15.00,
  "is_active" boolean default true,
  "created_at" timestamp with time zone default now(),
  "restaurant_id" integer default 1
);

create table public."faqs" (
  "id" uuid default gen_random_uuid() not null,
  "restaurant_id" integer not null,
  "question" text not null,
  "answer" text not null,
  "display_order" integer default 0,
  "is_active" boolean default true,
  "created_at" timestamp with time zone default now()
);

create table public."gallery" (
  "id" uuid default gen_random_uuid() not null,
  "image_url" text not null,
  "storage_path" text,
  "caption" text,
  "location" text default 'all'::text,
  "created_at" timestamp with time zone default now(),
  "restaurant_id" integer default 1
);

create table public."location_products" (
  "location_id" uuid not null,
  "product_id" uuid not null,
  "price_override" numeric,
  "is_available" boolean default true,
  "restaurant_id" integer default 1
);

create table public."locations" (
  "id" uuid default gen_random_uuid() not null,
  "name" text not null,
  "city" text,
  "suburb" text,
  "postcode" text,
  "address" text,
  "phone" text,
  "opening_hours" jsonb default '{}'::jsonb,
  "delivery_config" jsonb default '{}'::jsonb,
  "is_active" boolean default true,
  "created_at" timestamp with time zone default now(),
  "is_open" boolean default true,
  "min_order" numeric default 0,
  "delivery_fee" numeric default 0,
  "delivery_time" integer default 30,
  "pickup_time" integer default 15,
  "restaurant_id" integer default 1
);

create table public."loyalty_points" (
  "id" uuid default gen_random_uuid() not null,
  "user_id" uuid,
  "order_id" uuid,
  "points" integer default 0 not null,
  "type" text default 'earn'::text not null,
  "description" text,
  "created_at" timestamp with time zone default now(),
  "restaurant_id" integer default 1
);

create table public."loyalty_settings" (
  "id" uuid default gen_random_uuid() not null,
  "restaurant_id" integer not null,
  "is_active" boolean default true,
  "points_per_dollar" integer default 1,
  "bonus_first_order" integer default 50,
  "min_points_redeem" integer default 100,
  "points_per_dollar_value" integer default 100,
  "max_discount_percent" integer default 20,
  "points_expiry_days" integer default 365,
  "created_at" timestamp with time zone default now(),
  "updated_at" timestamp with time zone default now()
);

create table public."menu" (
  "id" uuid default gen_random_uuid() not null,
  "name" text not null,
  "base_price" numeric not null,
  "category" text,
  "image_url" text,
  "available" boolean default true,
  "custom_options" jsonb default '[]'::jsonb,
  "created_at" timestamp with time zone default now(),
  "restaurant_id" integer default 1
);

create table public."menu_items" (
  "id" uuid default gen_random_uuid() not null,
  "name" text not null,
  "description" text,
  "price" numeric not null,
  "category" text not null,
  "image_url" text,
  "ingredients" text[],
  "addons" jsonb default '[]'::jsonb,
  "available" boolean default true,
  "created_at" timestamp without time zone default now(),
  "location" text default 'all'::text,
  "customizations" jsonb default '[]'::jsonb,
  "is_popular" boolean default false,
  "course" text,
  "sort_order" integer default 0,
  "is_special" boolean default false,
  "restaurant_id" integer default 1,
  "category_sort_order" integer
);

create table public."modifiers" (
  "id" uuid default gen_random_uuid() not null,
  "name" text not null,
  "type" text default 'radio'::text not null,
  "required" boolean default false,
  "min_select" integer default 0,
  "max_select" integer default 1,
  "options" jsonb default '[]'::jsonb,
  "created_at" timestamp with time zone default now(),
  "restaurant_id" integer default 1
);

create table public."option_groups" (
  "id" uuid default gen_random_uuid() not null,
  "name" text not null,
  "type" text default 'radio'::text,
  "is_required" boolean default false,
  "min_selections" integer default 0,
  "max_selections" integer default 1,
  "options" jsonb default '[]'::jsonb,
  "restaurant_id" integer default 1
);

create table public."order_items" (
  "id" uuid default gen_random_uuid() not null,
  "order_id" uuid,
  "product_id" uuid,
  "product_name" text not null,
  "quantity" integer default 1,
  "unit_price" numeric default 0,
  "selected_options" jsonb default '[]'::jsonb,
  "options_price" numeric default 0,
  "line_total" numeric default 0,
  "restaurant_id" integer default 1
);

create table public."order_ratings" (
  "id" uuid default gen_random_uuid() not null,
  "order_id" uuid,
  "user_id" uuid,
  "rating" integer,
  "comment" text,
  "created_at" timestamp with time zone default now(),
  "restaurant_id" integer default 1
);

create table public."orders" (
  "id" uuid default gen_random_uuid() not null,
  "order_number" text not null,
  "customer_name" text,
  "customer_phone" text,
  "customer_address" text,
  "order_type" text not null,
  "items" jsonb not null,
  "total" numeric not null,
  "status" text default 'pending'::text,
  "payment_status" text default 'paid'::text,
  "created_at" timestamp without time zone default now(),
  "updated_at" timestamp without time zone default now(),
  "location" text,
  "notes" text,
  "customer_email" text,
  "user_id" uuid,
  "coupon_code" text,
  "restaurant_id" integer default 1,
  "delivery_fee" numeric default 0
);

create table public."pages" (
  "id" uuid default gen_random_uuid() not null,
  "slug" text not null,
  "title" text not null,
  "content" text,
  "image_url" text,
  "show_in_nav" boolean default true,
  "sort_order" integer default 0,
  "created_at" timestamp without time zone default now(),
  "restaurant_id" integer default 1
);

create table public."printers" (
  "id" uuid default gen_random_uuid() not null,
  "restaurant_id" integer default 1 not null,
  "location_id" uuid,
  "name" text not null,
  "ip_address" text not null,
  "port" integer default 9100 not null,
  "enabled" boolean default true not null,
  "created_at" timestamp with time zone default now()
);

create table public."product_option_groups" (
  "product_id" uuid not null,
  "option_group_id" uuid not null,
  "display_order" integer default 0,
  "restaurant_id" integer default 1
);

create table public."products" (
  "id" uuid default gen_random_uuid() not null,
  "category_id" uuid,
  "name" text not null,
  "description" text,
  "base_price" numeric default 0 not null,
  "image_url" text,
  "tags" text[] default '{}'::text[],
  "is_active" boolean default true,
  "created_at" timestamp with time zone default now(),
  "restaurant_id" integer default 1
);

create table public."profiles" (
  "id" uuid not null,
  "full_name" text,
  "phone" text,
  "role" text default 'customer'::text,
  "preferred_location_id" uuid,
  "saved_addresses" jsonb default '[]'::jsonb,
  "created_at" timestamp with time zone default now(),
  "total_points" integer default 0,
  "updated_at" timestamp with time zone default now(),
  "address" text,
  "avatar_url" text,
  "push_token" text,
  "suburb" text,
  "postcode" text,
  "date_of_birth" date,
  "email" text
);

create table public."promotions" (
  "id" uuid default gen_random_uuid() not null,
  "code" text not null,
  "type" text default 'percent'::text not null,
  "value" numeric default 10 not null,
  "min_order" numeric default 0,
  "max_uses" integer default 100,
  "used_count" integer default 0,
  "expires_at" timestamp with time zone,
  "is_active" boolean default true,
  "description" text,
  "created_at" timestamp with time zone default now(),
  "restaurant_id" integer default 1,
  "max_uses_per_customer" integer
);

create table public."report_locations" (
  "id" uuid default gen_random_uuid() not null,
  "name" text not null,
  "created_at" timestamp with time zone default now()
);

create table public."report_restaurants" (
  "id" uuid default gen_random_uuid() not null,
  "name" text not null,
  "brand" text not null,
  "location_id" uuid,
  "created_at" timestamp with time zone default now()
);

create table public."report_weekly_data" (
  "id" uuid default gen_random_uuid() not null,
  "restaurant_id" text not null,
  "location" text default ''::text not null,
  "restaurant_name" text default ''::text not null,
  "week_start" date not null,
  "partner" text default ''::text not null,
  "orders" integer default 0,
  "gross_revenue" numeric default 0,
  "net_revenue" numeric default 0,
  "food_cost" numeric default 0,
  "staff_cost" numeric default 0,
  "operation_cost" numeric default 0,
  "notes" text,
  "created_at" timestamp with time zone default now(),
  "updated_at" timestamp with time zone default now()
);

create table public."restaurants" (
  "id" integer default nextval('restaurants_id_seq'::regclass) not null,
  "name" text not null,
  "slug" text not null,
  "created_at" timestamp with time zone default now()
);

create table public."settings" (
  "id" uuid default gen_random_uuid() not null,
  "key" text not null,
  "value" text,
  "created_at" timestamp with time zone default now(),
  "restaurant_id" integer default 1
);

create table public."site_settings" (
  "id" uuid default gen_random_uuid() not null,
  "type" text not null,
  "key" text not null,
  "value" text,
  "updated_at" timestamp with time zone default now(),
  "restaurant_id" integer default 1
);

create table public."staff" (
  "id" uuid default gen_random_uuid() not null,
  "name" text not null,
  "email" text not null,
  "password" text not null,
  "role" text default 'staff'::text,
  "permissions" jsonb default '{"menu": false, "pages": false, "orders": true, "dashboard": false}'::jsonb,
  "active" boolean default true,
  "created_at" timestamp without time zone default now(),
  "auth_id" uuid,
  "restaurant_id" integer default 1
);

alter sequence public.restaurants_id_seq owned by public.restaurants.id;

alter table public.categories add constraint "categories_pkey" PRIMARY KEY (id);
alter table public.categories add constraint "categories_slug_key" UNIQUE (slug);
alter table public.delivery_zones add constraint "delivery_zones_pkey" PRIMARY KEY (id);
alter table public.faqs add constraint "faqs_pkey" PRIMARY KEY (id);
alter table public.gallery add constraint "gallery_pkey" PRIMARY KEY (id);
alter table public.location_products add constraint "location_products_pkey" PRIMARY KEY (location_id, product_id);
alter table public.locations add constraint "locations_pkey" PRIMARY KEY (id);
alter table public.loyalty_points add constraint "loyalty_points_pkey" PRIMARY KEY (id);
alter table public.loyalty_settings add constraint "loyalty_settings_pkey" PRIMARY KEY (id);
alter table public.loyalty_settings add constraint "loyalty_settings_restaurant_id_key" UNIQUE (restaurant_id);
alter table public.menu add constraint "menu_pkey" PRIMARY KEY (id);
alter table public.menu_items add constraint "menu_items_pkey" PRIMARY KEY (id);
alter table public.modifiers add constraint "modifiers_pkey" PRIMARY KEY (id);
alter table public.option_groups add constraint "option_groups_pkey" PRIMARY KEY (id);
alter table public.order_items add constraint "order_items_pkey" PRIMARY KEY (id);
alter table public.order_ratings add constraint "order_ratings_order_id_key" UNIQUE (order_id);
alter table public.order_ratings add constraint "order_ratings_pkey" PRIMARY KEY (id);
alter table public.orders add constraint "orders_pkey" PRIMARY KEY (id);
alter table public.pages add constraint "pages_pkey" PRIMARY KEY (id);
alter table public.pages add constraint "pages_slug_key" UNIQUE (slug);
alter table public.printers add constraint "printers_pkey" PRIMARY KEY (id);
alter table public.product_option_groups add constraint "product_option_groups_pkey" PRIMARY KEY (product_id, option_group_id);
alter table public.products add constraint "products_pkey" PRIMARY KEY (id);
alter table public.profiles add constraint "profiles_pkey" PRIMARY KEY (id);
alter table public.promotions add constraint "promotions_code_key" UNIQUE (code);
alter table public.promotions add constraint "promotions_pkey" PRIMARY KEY (id);
alter table public.report_locations add constraint "report_locations_pkey" PRIMARY KEY (id);
alter table public.report_restaurants add constraint "report_restaurants_pkey" PRIMARY KEY (id);
alter table public.report_weekly_data add constraint "report_weekly_data_pkey" PRIMARY KEY (id);
alter table public.report_weekly_data add constraint "report_weekly_data_restaurant_id_week_start_partner_key" UNIQUE (restaurant_id, week_start, partner);
alter table public.restaurants add constraint "restaurants_pkey" PRIMARY KEY (id);
alter table public.restaurants add constraint "restaurants_slug_key" UNIQUE (slug);
alter table public.settings add constraint "settings_pkey" PRIMARY KEY (id);
alter table public.site_settings add constraint "site_settings_pkey" PRIMARY KEY (id);
alter table public.site_settings add constraint "site_settings_type_key_key" UNIQUE (type, key);
alter table public.staff add constraint "staff_email_key" UNIQUE (email);
alter table public.staff add constraint "staff_pkey" PRIMARY KEY (id);
alter table public.order_ratings add constraint "order_ratings_rating_check" CHECK (((rating >= 1) AND (rating <= 5)));
alter table public.categories add constraint "categories_restaurant_id_fkey" FOREIGN KEY (restaurant_id) REFERENCES restaurants(id);
alter table public.delivery_zones add constraint "delivery_zones_restaurant_id_fkey" FOREIGN KEY (restaurant_id) REFERENCES restaurants(id);
alter table public.gallery add constraint "gallery_restaurant_id_fkey" FOREIGN KEY (restaurant_id) REFERENCES restaurants(id);
alter table public.location_products add constraint "location_products_location_id_fkey" FOREIGN KEY (location_id) REFERENCES locations(id) ON DELETE CASCADE;
alter table public.location_products add constraint "location_products_product_id_fkey" FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE;
alter table public.location_products add constraint "location_products_restaurant_id_fkey" FOREIGN KEY (restaurant_id) REFERENCES restaurants(id);
alter table public.locations add constraint "locations_restaurant_id_fkey" FOREIGN KEY (restaurant_id) REFERENCES restaurants(id);
alter table public.loyalty_points add constraint "loyalty_points_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE SET NULL;
alter table public.loyalty_points add constraint "loyalty_points_restaurant_id_fkey" FOREIGN KEY (restaurant_id) REFERENCES restaurants(id);
alter table public.loyalty_points add constraint "loyalty_points_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;
alter table public.menu add constraint "menu_restaurant_id_fkey" FOREIGN KEY (restaurant_id) REFERENCES restaurants(id);
alter table public.menu_items add constraint "menu_items_restaurant_id_fkey" FOREIGN KEY (restaurant_id) REFERENCES restaurants(id);
alter table public.modifiers add constraint "modifiers_restaurant_id_fkey" FOREIGN KEY (restaurant_id) REFERENCES restaurants(id);
alter table public.option_groups add constraint "option_groups_restaurant_id_fkey" FOREIGN KEY (restaurant_id) REFERENCES restaurants(id);
alter table public.order_items add constraint "order_items_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE;
alter table public.order_items add constraint "order_items_product_id_fkey" FOREIGN KEY (product_id) REFERENCES products(id);
alter table public.order_items add constraint "order_items_restaurant_id_fkey" FOREIGN KEY (restaurant_id) REFERENCES restaurants(id);
alter table public.order_ratings add constraint "order_ratings_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE;
alter table public.order_ratings add constraint "order_ratings_restaurant_id_fkey" FOREIGN KEY (restaurant_id) REFERENCES restaurants(id);
alter table public.order_ratings add constraint "order_ratings_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;
alter table public.orders add constraint "orders_restaurant_id_fkey" FOREIGN KEY (restaurant_id) REFERENCES restaurants(id);
alter table public.pages add constraint "pages_restaurant_id_fkey" FOREIGN KEY (restaurant_id) REFERENCES restaurants(id);
alter table public.printers add constraint "printers_location_id_fkey" FOREIGN KEY (location_id) REFERENCES locations(id) ON DELETE SET NULL;
alter table public.product_option_groups add constraint "product_option_groups_option_group_id_fkey" FOREIGN KEY (option_group_id) REFERENCES option_groups(id) ON DELETE CASCADE;
alter table public.product_option_groups add constraint "product_option_groups_product_id_fkey" FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE;
alter table public.product_option_groups add constraint "product_option_groups_restaurant_id_fkey" FOREIGN KEY (restaurant_id) REFERENCES restaurants(id);
alter table public.products add constraint "products_category_id_fkey" FOREIGN KEY (category_id) REFERENCES categories(id);
alter table public.products add constraint "products_restaurant_id_fkey" FOREIGN KEY (restaurant_id) REFERENCES restaurants(id);
alter table public.profiles add constraint "profiles_id_fkey" FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;
alter table public.profiles add constraint "profiles_preferred_location_id_fkey" FOREIGN KEY (preferred_location_id) REFERENCES locations(id);
alter table public.promotions add constraint "promotions_restaurant_id_fkey" FOREIGN KEY (restaurant_id) REFERENCES restaurants(id);
alter table public.report_restaurants add constraint "report_restaurants_location_id_fkey" FOREIGN KEY (location_id) REFERENCES report_locations(id);
alter table public.settings add constraint "settings_restaurant_id_fkey" FOREIGN KEY (restaurant_id) REFERENCES restaurants(id);
alter table public.site_settings add constraint "site_settings_restaurant_id_fkey" FOREIGN KEY (restaurant_id) REFERENCES restaurants(id);
alter table public.staff add constraint "staff_auth_id_fkey" FOREIGN KEY (auth_id) REFERENCES auth.users(id);
alter table public.staff add constraint "staff_restaurant_id_fkey" FOREIGN KEY (restaurant_id) REFERENCES restaurants(id);

CREATE UNIQUE INDEX settings_key_restaurant_id_idx ON public.settings USING btree (key, restaurant_id);

alter table public."orders" enable row level security;
alter table public."faqs" enable row level security;
alter table public."printers" enable row level security;
alter table public."loyalty_settings" enable row level security;
alter table public."menu" enable row level security;
alter table public."order_items" enable row level security;
alter table public."pages" enable row level security;
alter table public."location_products" enable row level security;
alter table public."categories" enable row level security;
alter table public."product_option_groups" enable row level security;
alter table public."option_groups" enable row level security;
alter table public."products" enable row level security;
alter table public."profiles" enable row level security;
alter table public."report_locations" enable row level security;
alter table public."report_restaurants" enable row level security;
alter table public."loyalty_points" enable row level security;
alter table public."report_weekly_data" enable row level security;
alter table public."modifiers" enable row level security;
alter table public."settings" enable row level security;
alter table public."promotions" enable row level security;
alter table public."delivery_zones" enable row level security;
alter table public."gallery" enable row level security;
alter table public."order_ratings" enable row level security;
alter table public."site_settings" enable row level security;
alter table public."locations" enable row level security;
alter table public."staff" enable row level security;
alter table public."restaurants" enable row level security;
alter table public."menu_items" enable row level security;

create policy "Public read" on storage."objects" for select to public using ((bucket_id = 'menu-images'::text));
create policy "Auth upload" on storage."objects" for insert to public with check ((bucket_id = 'menu-images'::text));
create policy "allow_all 1xs2w12_2" on storage."objects" for update to public using ((bucket_id = 'menu-images'::text));
create policy "allow_all 1xs2w12_3" on storage."objects" for delete to public using ((bucket_id = 'menu-images'::text));
create policy "allow_all 1xs2w12_1" on storage."objects" for insert to public with check ((bucket_id = 'menu-images'::text));
create policy "allow_all 1xs2w12_0" on storage."objects" for select to public using ((bucket_id = 'menu-images'::text));
create policy "Allow all menu access" on public."menu" for all to public using (true) with check (true);
create policy "allow_all" on public."report_weekly_data" for all to public using (true);
create policy "Users can view own profile" on public."profiles" for select to public using ((auth.uid() = id));
create policy "Public can read gallery" on public."gallery" for select to public using (true);
create policy "Authenticated can modify gallery" on public."gallery" for all to public using ((auth.role() = 'authenticated'::text));
create policy "Public can read site settings" on public."site_settings" for select to public using (true);
create policy "Authenticated can modify site settings" on public."site_settings" for all to public using ((auth.role() = 'authenticated'::text));
create policy "Public can read delivery zones" on public."delivery_zones" for select to public using (true);
create policy "Public can read products" on public."products" for select to public using (true);
create policy "Service role full access products" on public."products" for all to public using ((auth.role() = 'service_role'::text));
create policy "Public can read pages" on public."pages" for select to public using (true);
create policy "Users can view own ratings" on public."order_ratings" for select to public using ((auth.uid() = user_id));
create policy "Users can insert own ratings" on public."order_ratings" for insert to public with check ((auth.uid() = user_id));
create policy "Users can update own ratings" on public."order_ratings" for update to public using ((auth.uid() = user_id));
create policy "Allow all for authenticated" on public."modifiers" for all to public using ((auth.role() = 'authenticated'::text));
create policy "Admin can manage points" on public."loyalty_points" for all to public using ((auth.role() = 'authenticated'::text));
create policy "Users can update own profile" on public."profiles" for update to public using ((auth.uid() = id)) with check ((auth.uid() = id));
create policy "Users can upsert own profile" on public."profiles" for insert to public with check ((auth.uid() = id));
create policy "Users can upsert own profile merge" on public."profiles" for all to public using ((auth.uid() = id)) with check ((auth.uid() = id));
create policy "Public read loyalty settings" on public."loyalty_settings" for select to public using (true);
create policy "Service manage loyalty settings" on public."loyalty_settings" for all to public using (true);
create policy "Users can insert own orders" on public."orders" for insert to public with check (((auth.uid() = user_id) OR (user_id IS NULL)));
create policy "Users can view own orders" on public."orders" for select to public using ((auth.uid() = user_id));
create policy "Authenticated can update orders" on public."orders" for update to public using ((auth.role() = 'authenticated'::text));
create policy "Users can view own points" on public."loyalty_points" for select to public using ((auth.uid() = user_id));
create policy "Users can insert own points" on public."loyalty_points" for insert to public with check ((auth.uid() = user_id));
create policy "Public can read settings" on public."settings" for select to public using (true);
create policy "Authenticated can modify settings" on public."settings" for all to public using ((auth.role() = 'authenticated'::text));
create policy "Public can read promotions" on public."promotions" for select to public using (true);
create policy "Authenticated can modify promotions" on public."promotions" for all to public using ((auth.role() = 'authenticated'::text));
create policy "Public can read menu items" on public."menu_items" for select to public using (true);
create policy "Authenticated can modify menu items" on public."menu_items" for all to public using ((auth.role() = 'authenticated'::text));
create policy "Public can read categories" on public."categories" for select to public using (true);
create policy "Authenticated can modify categories" on public."categories" for all to public using ((auth.role() = 'authenticated'::text));
create policy "Public can read locations" on public."locations" for select to public using (true);
create policy "Authenticated can modify locations" on public."locations" for all to public using ((auth.role() = 'authenticated'::text));
create policy "Authenticated can modify delivery zones" on public."delivery_zones" for all to public using ((auth.role() = 'authenticated'::text));
create policy "Authenticated can manage staff" on public."staff" for all to public using ((auth.role() = 'authenticated'::text));
create policy "Public can read restaurants" on public."restaurants" for select to public using (true);
create policy "Customers can view own orders" on public."orders" for select to public using ((auth.uid() = user_id));
create policy "Customers can insert own orders" on public."orders" for insert to public with check ((auth.uid() = user_id));
create policy "Service role full access orders" on public."orders" for all to public using ((auth.role() = 'service_role'::text));
create policy "Customers can view own order items" on public."order_items" for select to public using ((order_id IN ( SELECT orders.id
   FROM orders
  WHERE (orders.user_id = auth.uid()))));
create policy "Customers can insert order items" on public."order_items" for insert to public with check ((order_id IN ( SELECT orders.id
   FROM orders
  WHERE (orders.user_id = auth.uid()))));
create policy "Service role full access order_items" on public."order_items" for all to public using ((auth.role() = 'service_role'::text));
create policy "Anon can view all orders" on public."orders" for select to public using (true);
create policy "Anon can update orders" on public."orders" for update to public using (true);
create policy "Public can read option_groups" on public."option_groups" for select to public using (true);
create policy "Service role full access option_groups" on public."option_groups" for all to public using ((auth.role() = 'service_role'::text));
create policy "Service role full access pages" on public."pages" for all to public using ((auth.role() = 'service_role'::text));
create policy "Public can read product_option_groups" on public."product_option_groups" for select to public using (true);
create policy "Service role full access product_option_groups" on public."product_option_groups" for all to public using ((auth.role() = 'service_role'::text));
create policy "Anon can view all order_items" on public."order_items" for select to public using (true);
create policy "Anon can insert order_items" on public."order_items" for insert to public with check (true);
create policy "Anon can update order_items" on public."order_items" for update to public using (true);
create policy "Public can read location_products" on public."location_products" for select to public using (true);
create policy "Service role full access location_products" on public."location_products" for all to public using ((auth.role() = 'service_role'::text));
create policy "Authenticated can access report_locations" on public."report_locations" for all to public using (((auth.role() = 'authenticated'::text) OR (auth.role() = 'service_role'::text)));
create policy "Authenticated can access report_restaurants" on public."report_restaurants" for all to public using (((auth.role() = 'authenticated'::text) OR (auth.role() = 'service_role'::text)));
create policy "Anon can insert orders" on public."orders" for insert to public with check (true);
create policy "Public read locations" on public."locations" for select to anon,authenticated using (true);
create policy "Public read menu_items" on public."menu_items" for select to anon,authenticated using (true);
create policy "Users can insert orders" on public."orders" for insert to anon,authenticated with check (true);
create policy "Public can read faqs" on public."faqs" for select to public using (true);
create policy "Authenticated can modify faqs" on public."faqs" for all to public using ((auth.role() = 'authenticated'::text));
create policy "Allow all for authenticated" on public."printers" for all to public using ((auth.role() = 'authenticated'::text));

CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  INSERT INTO public.profiles (id, full_name, email, role)
  VALUES (
    NEW.id,
    NEW.raw_user_meta_data->>'full_name',
    NEW.email,
    'customer'
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$function$;

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION handle_new_user();

insert into storage.buckets (id, name, public) values ('menu-images','menu-images',true) on conflict (id) do nothing;

-- Starting data for Gem Food
insert into public.restaurants (id, name, slug) values (1, 'Gem Food', 'gemfood');
select setval('public.restaurants_id_seq', 1, true);
insert into public.locations (name, city, suburb, postcode, address, phone, restaurant_id) values ('St. Petersburg', 'St. Petersburg', 'St. Petersburg', '33713', '2800 38th Ave N', '+1 727-954-0001', 1);
insert into public.settings (key, value, restaurant_id) values ('business_name', 'Gem Food', 1), ('primary_color', '#F26A1B', 1);
insert into public.loyalty_settings (restaurant_id) values (1);

commit;
