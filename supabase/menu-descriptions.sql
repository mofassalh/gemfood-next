-- Short menu descriptions for items that had none.
-- Written only from what each item's name and the restaurant's own menu page say;
-- no ingredients were guessed. Existing descriptions are left untouched.
update public.menu_items m set description = d.description
from (values
  ('Chicken Gyro Sandwich',     'Chicken gyro sandwich made with fresh salad and sauce.'),
  ('Mixed Meat Gyro Sandwich',  'Mixed meat gyro sandwich made with fresh salad and sauce.'),
  ('Chicken Shawarma Wrap',     'Chicken shawarma wrap made with fresh salad and sauce.'),
  ('Cheeseburger',              'Classic burger with melted cheese.'),
  ('Jalapeño Cheeseburger',     'Cheeseburger topped with jalapeños.'),
  ('Mushroom Burger',           'Burger topped with mushrooms.'),
  ('Bacon Cheeseburger',        'Cheeseburger topped with bacon.'),
  ('Double Cheeseburger',       'Two patties with melted cheese.'),
  ('Catfish',                   'Catfish, 1 or 2 pieces.'),
  ('Fresh Home Salad',          'Fresh house salad. Small or large.'),
  ('Chicken Salad',             'Fresh salad topped with chicken. Small or large.'),
  ('Grilled Chicken Salad',     'Fresh salad topped with grilled chicken. Small or large.'),
  ('Fried Chicken Salad',       'Fresh salad topped with fried chicken. Small or large.'),
  ('Chicken Gyro Salad',        'Fresh salad topped with chicken gyro. Small or large.'),
  ('Gyro Meat Salad',           'Fresh salad topped with gyro meat. Small or large.'),
  ('Mixed Meat Salad',          'Fresh salad topped with mixed meat. Small or large.'),
  ('French Fries (7 oz)',       'Crispy french fries, 7 oz.'),
  ('Onion Rings (7 oz)',        'Crispy onion rings, 7 oz.'),
  ('Mozzarella Sticks (5 pc)',  'Five mozzarella sticks.'),
  ('Jalapeño Poppers',          'Breaded jalapeño poppers.'),
  ('Fried Pickles (7 oz)',      'Crispy fried pickles, 7 oz.'),
  ('Fried Okra (7 oz)',         'Crispy fried okra, 7 oz.'),
  ('Breaded Mushrooms (7 oz)',  'Breaded mushrooms, 7 oz.'),
  ('Soda / Capri Sun',          'A can of soda or a Capri Sun.')
) as d(name, description)
where m.name = d.name and (m.description is null or m.description = '');

select count(*) filter (where description is not null and description <> '') as with_description,
       count(*) filter (where description is null or description = '') as without_description
from public.menu_items;
