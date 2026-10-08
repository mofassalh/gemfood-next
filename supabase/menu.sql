-- Gem Food menu (from the current gemfoodstpete.com menu page)
begin;
do $$ begin
  if exists (select 1 from public.menu_items) then
    raise exception 'Menu already has items - nothing was changed';
  end if;
end $$;

insert into public.menu_items (name, description, price, category, customizations, sort_order, category_sort_order, restaurant_id) values
('Chicken Biryani', 'Chicken, rice and salad', 14.99, 'Platters', '[]'::jsonb, 1, 1, 1),
('Beef Biryani', 'Beef, rice and salad', 17.99, 'Platters', '[]'::jsonb, 2, 1, 1),
('Butter Chicken', 'Butter chicken, rice and salad', 14.99, 'Platters', '[]'::jsonb, 3, 1, 1),
('Chicken Curry', 'Chicken, rice and salad', 14.99, 'Platters', '[]'::jsonb, 4, 1, 1),
('Beef Curry', 'Beef, rice and salad', 17.99, 'Platters', '[]'::jsonb, 5, 1, 1),
('Chicken Gyro Platter', 'Grilled chicken, rice and salad', 14.99, 'Platters', '[]'::jsonb, 6, 1, 1),
('Halal Gen Chicken Platter', 'Chicken, rice, salad and white sauce', 14.99, 'Platters', '[]'::jsonb, 7, 1, 1),
('Chicken Potato Platter', 'Chicken, potato and salad', 14.99, 'Platters', '[]'::jsonb, 8, 1, 1),
('Garlic Chicken Platter', 'Garlic chicken, naan bread and salad', 12.99, 'Platters', '[]'::jsonb, 9, 1, 1),
('Chicken Stew', 'Chicken, naan bread and salad', 12.99, 'Platters', '[]'::jsonb, 10, 1, 1),
('Seafood Platter', null, 16.99, 'Platters', '[]'::jsonb, 11, 1, 1),
('Party Wings', 'Bone-in wings in any of our 20 flavors.', 9.99, 'Party Wings', '[{"name": "Size", "type": "radio", "max": 1, "options": [{"name": "8 pc", "price": 0.0}, {"name": "12 pc", "price": 5.0}, {"name": "16 pc", "price": 10.0}]}, {"name": "Flavor", "type": "radio", "max": 1, "options": [{"name": "Lemon Pepper (dry rub)", "price": 0}, {"name": "Nashville Hot (dry rub)", "price": 0}, {"name": "Cajun Seasoning (dry rub)", "price": 0}, {"name": "Garlic Powder (dry rub)", "price": 0}, {"name": "Lawry''s Seasoned Salt (dry rub)", "price": 0}, {"name": "Hot", "price": 0}, {"name": "Mild", "price": 0}, {"name": "BBQ", "price": 0}, {"name": "Sweet Chili", "price": 0}, {"name": "Garlic Parmesan", "price": 0}, {"name": "Garlic Buffalo", "price": 0}, {"name": "Mango Habanero", "price": 0}, {"name": "Sweet Teriyaki", "price": 0}, {"name": "Honey Mustard", "price": 0}, {"name": "Carolina Tangy Gold", "price": 0}, {"name": "Spicy Peach", "price": 0}, {"name": "Lemon Pepper (sauce)", "price": 0}, {"name": "Honey Hot", "price": 0}, {"name": "Honey BBQ", "price": 0}, {"name": "Honey", "price": 0}]}]'::jsonb, 12, 2, 1),
('Boneless Chicken', 'Toss it in a sauce or a dry rub.', 9.99, 'Chicken Fried', '[{"name": "Size", "type": "radio", "max": 1, "options": [{"name": "8 pc", "price": 0.0}, {"name": "12 pc", "price": 5.0}, {"name": "16 pc", "price": 10.0}]}, {"name": "Flavor", "type": "radio", "max": 1, "options": [{"name": "Lemon Pepper (dry rub)", "price": 0}, {"name": "Nashville Hot (dry rub)", "price": 0}, {"name": "Cajun Seasoning (dry rub)", "price": 0}, {"name": "Garlic Powder (dry rub)", "price": 0}, {"name": "Lawry''s Seasoned Salt (dry rub)", "price": 0}, {"name": "Hot", "price": 0}, {"name": "Mild", "price": 0}, {"name": "BBQ", "price": 0}, {"name": "Sweet Chili", "price": 0}, {"name": "Garlic Parmesan", "price": 0}, {"name": "Garlic Buffalo", "price": 0}, {"name": "Mango Habanero", "price": 0}, {"name": "Sweet Teriyaki", "price": 0}, {"name": "Honey Mustard", "price": 0}, {"name": "Carolina Tangy Gold", "price": 0}, {"name": "Spicy Peach", "price": 0}, {"name": "Lemon Pepper (sauce)", "price": 0}, {"name": "Honey Hot", "price": 0}, {"name": "Honey BBQ", "price": 0}, {"name": "Honey", "price": 0}]}]'::jsonb, 13, 3, 1),
('Chicken Tenders', 'Toss it in a sauce or a dry rub.', 6.99, 'Chicken Fried', '[{"name": "Size", "type": "radio", "max": 1, "options": [{"name": "3 pc", "price": 0.0}, {"name": "6 pc", "price": 6.0}, {"name": "9 pc", "price": 13.0}]}, {"name": "Flavor", "type": "radio", "max": 1, "options": [{"name": "Lemon Pepper (dry rub)", "price": 0}, {"name": "Nashville Hot (dry rub)", "price": 0}, {"name": "Cajun Seasoning (dry rub)", "price": 0}, {"name": "Garlic Powder (dry rub)", "price": 0}, {"name": "Lawry''s Seasoned Salt (dry rub)", "price": 0}, {"name": "Hot", "price": 0}, {"name": "Mild", "price": 0}, {"name": "BBQ", "price": 0}, {"name": "Sweet Chili", "price": 0}, {"name": "Garlic Parmesan", "price": 0}, {"name": "Garlic Buffalo", "price": 0}, {"name": "Mango Habanero", "price": 0}, {"name": "Sweet Teriyaki", "price": 0}, {"name": "Honey Mustard", "price": 0}, {"name": "Carolina Tangy Gold", "price": 0}, {"name": "Spicy Peach", "price": 0}, {"name": "Lemon Pepper (sauce)", "price": 0}, {"name": "Honey Hot", "price": 0}, {"name": "Honey BBQ", "price": 0}, {"name": "Honey", "price": 0}]}]'::jsonb, 14, 3, 1),
('Chicken Philly', '8-inch sub.', 11.99, 'Philly', '[{"name": "Quantity", "type": "radio", "max": 1, "options": [{"name": "1 sub", "price": 0.0}, {"name": "2 subs", "price": 8.0}]}]'::jsonb, 15, 4, 1),
('Philly Cheesesteak', '8-inch sub.', 11.99, 'Philly', '[{"name": "Quantity", "type": "radio", "max": 1, "options": [{"name": "1 sub", "price": 0.0}, {"name": "2 subs", "price": 8.0}]}]'::jsonb, 16, 4, 1),
('Shrimp Philly', '8-inch sub.', 11.99, 'Philly', '[{"name": "Quantity", "type": "radio", "max": 1, "options": [{"name": "1 sub", "price": 0.0}, {"name": "2 subs", "price": 8.0}]}]'::jsonb, 17, 4, 1),
('Chicken Gyro Sandwich', null, 9.99, 'Gyro & Shawarma', '[]'::jsonb, 18, 5, 1),
('Mixed Meat Gyro Sandwich', null, 9.99, 'Gyro & Shawarma', '[]'::jsonb, 19, 5, 1),
('Chicken Shawarma Wrap', null, 9.99, 'Gyro & Shawarma', '[]'::jsonb, 20, 5, 1),
('Cheeseburger', null, 9.99, 'Burgers', '[]'::jsonb, 21, 6, 1),
('Jalapeño Cheeseburger', null, 9.99, 'Burgers', '[]'::jsonb, 22, 6, 1),
('Mushroom Burger', null, 9.99, 'Burgers', '[]'::jsonb, 23, 6, 1),
('Bacon Cheeseburger', null, 11.99, 'Burgers', '[]'::jsonb, 24, 6, 1),
('Double Cheeseburger', null, 15.99, 'Burgers', '[]'::jsonb, 25, 6, 1),
('Catfish', null, 9.99, 'Fish', '[{"name": "Size", "type": "radio", "max": 1, "options": [{"name": "1 pc", "price": 0.0}, {"name": "2 pc", "price": 5.0}]}]'::jsonb, 26, 7, 1),
('Fresh Home Salad', null, 5.99, 'Healthy Treats', '[{"name": "Size", "type": "radio", "max": 1, "options": [{"name": "Small", "price": 0.0}, {"name": "Large", "price": 2.0}]}]'::jsonb, 27, 8, 1),
('Chicken Salad', null, 8.99, 'Healthy Treats', '[{"name": "Size", "type": "radio", "max": 1, "options": [{"name": "Small", "price": 0.0}, {"name": "Large", "price": 4.0}]}]'::jsonb, 28, 8, 1),
('Grilled Chicken Salad', null, 8.99, 'Healthy Treats', '[{"name": "Size", "type": "radio", "max": 1, "options": [{"name": "Small", "price": 0.0}, {"name": "Large", "price": 4.0}]}]'::jsonb, 29, 8, 1),
('Fried Chicken Salad', null, 8.99, 'Healthy Treats', '[{"name": "Size", "type": "radio", "max": 1, "options": [{"name": "Small", "price": 0.0}, {"name": "Large", "price": 4.0}]}]'::jsonb, 30, 8, 1),
('Chicken Gyro Salad', null, 8.99, 'Healthy Treats', '[{"name": "Size", "type": "radio", "max": 1, "options": [{"name": "Small", "price": 0.0}, {"name": "Large", "price": 4.0}]}]'::jsonb, 31, 8, 1),
('Gyro Meat Salad', null, 8.99, 'Healthy Treats', '[{"name": "Size", "type": "radio", "max": 1, "options": [{"name": "Small", "price": 0.0}, {"name": "Large", "price": 4.0}]}]'::jsonb, 32, 8, 1),
('Mixed Meat Salad', null, 8.99, 'Healthy Treats', '[{"name": "Size", "type": "radio", "max": 1, "options": [{"name": "Small", "price": 0.0}, {"name": "Large", "price": 4.0}]}]'::jsonb, 33, 8, 1),
('French Fries (7 oz)', null, 4.99, 'Appetizers & Sides', '[]'::jsonb, 34, 9, 1),
('Onion Rings (7 oz)', null, 4.99, 'Appetizers & Sides', '[]'::jsonb, 35, 9, 1),
('Mozzarella Sticks (5 pc)', null, 4.99, 'Appetizers & Sides', '[]'::jsonb, 36, 9, 1),
('Jalapeño Poppers', null, 4.99, 'Appetizers & Sides', '[]'::jsonb, 37, 9, 1),
('Fried Pickles (7 oz)', null, 4.99, 'Appetizers & Sides', '[]'::jsonb, 38, 9, 1),
('Fried Okra (7 oz)', null, 4.99, 'Appetizers & Sides', '[]'::jsonb, 39, 9, 1),
('Breaded Mushrooms (7 oz)', null, 4.99, 'Appetizers & Sides', '[]'::jsonb, 40, 9, 1),
('Soda / Capri Sun', null, 1.49, 'Appetizers & Sides', '[]'::jsonb, 41, 9, 1),
('Fries + Can Soda combo', 'Fries and a can of soda, added to your order.', 4.99, 'Combo', '[]'::jsonb, 42, 10, 1);

insert into public.settings (key, value, restaurant_id) values ('category_order', '["Platters", "Party Wings", "Chicken Fried", "Philly", "Gyro & Shawarma", "Burgers", "Fish", "Healthy Treats", "Appetizers & Sides", "Combo"]', 1)
on conflict (key, restaurant_id) do update set value = excluded.value;

commit;
select category, count(*) as items from public.menu_items group by category, category_sort_order order by category_sort_order;
