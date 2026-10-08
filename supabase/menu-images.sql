-- Attach food photos to Gem Food menu items (photos live in the site at /menu/*.jpg)
update public.menu_items set image_url = 'https://gemfood-next.vercel.app/menu/butter-chicken.jpg' where name = 'Butter Chicken';
update public.menu_items set image_url = 'https://gemfood-next.vercel.app/menu/wings.jpg' where name = 'Party Wings';
update public.menu_items set image_url = 'https://gemfood-next.vercel.app/menu/chicken-fried.jpg' where name in ('Boneless Chicken','Chicken Tenders');
update public.menu_items set image_url = 'https://gemfood-next.vercel.app/menu/fish-fries.jpg' where name = 'Catfish';
update public.menu_items set image_url = 'https://gemfood-next.vercel.app/menu/philly-sub.jpg' where name in ('Chicken Philly','Philly Cheesesteak','Shrimp Philly');
update public.menu_items set image_url = 'https://gemfood-next.vercel.app/menu/shawarma-wrap.jpg' where name in ('Chicken Gyro Sandwich','Mixed Meat Gyro Sandwich','Chicken Shawarma Wrap');
update public.menu_items set image_url = 'https://gemfood-next.vercel.app/menu/burger.jpg' where category = 'Burgers';
update public.menu_items set image_url = 'https://gemfood-next.vercel.app/menu/gyro-salad.jpg' where name in ('Gyro Meat Salad','Mixed Meat Salad');
update public.menu_items set image_url = 'https://gemfood-next.vercel.app/menu/appetizers.jpg' where name in ('Onion Rings (7 oz)','Mozzarella Sticks (5 pc)','Jalapeño Poppers','Fried Pickles (7 oz)','Fried Okra (7 oz)','Breaded Mushrooms (7 oz)');

select count(*) filter (where image_url is not null) as with_photo, count(*) filter (where image_url is null) as without_photo from public.menu_items;
