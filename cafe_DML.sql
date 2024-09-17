set search_path to 'cafe';

/*
 Project BAUN 6320 - UTD
*/

-- cafe_store table
INSERT INTO
    cafe_store (store_manager, store_capacity, phone, street_address, city, state, zip)
VALUES
    ('Nisha Shah', 80, 4693853946, '1235 Main Street', 'Richardson', 'TX', 75080),
    ('William Wilson', 70, 2125439674, '261 Boradway', 'New York', 'NY', 10001),
    ('Ava Miller', 100, 3055552468, '2468 Oak Lane', 'Miami', 'FL', 33125),
	('Nathan Shaw', 50, 5035455678, '5678 Pine Avenue', 'Portland', 'OR', 97201),
    ('Sofia Brown', 90, 3038649100, '910 Maple Drive', 'Denver', 'CO', 80202),
    ('Abigail Jones', 110, 4159451357, '1357 Cedar Road', 'San Francisco', 'CA', 94110),
    ('Dev Patel', 120,  2147427859, '7859 Willow Avenue', 'Dallas', 'TX', 75201),
    ('Ehan Smith', 40, 4699376925, '123 Frisco Avenue', 'Frisco', 'TX', 75034),
    ('Mateo Flores', 80, 3129376543, '6543 Walnut Boulevard', 'Chicago', 'IL', 60601),
    ('Santiago Lopez', 90, 3050583980, '456 Ocean Drive', 'Miami', 'FL', 33139);

-- orders table
INSERT INTO
    orders (order_tax, order_tip, order_total, date_and_time, FK_cafe_store_pk_store_id)
VALUES
    (2.01, 3, 24.49,'2023-04-20',800),
	(1.38, 4, 16.78,'2023-06-23',100),
	(0.8, 1, 9.75,'2023-07-11',900),
	(5.36, 7, 65,'2023-07-14',300),
	(0.91, 0, 11,'2023-08-03',200),
	(2.90, 6, 35.18,'2023-11-27',700),
	(4.34, 8, 52.87,'2024-01-04',600),
	(1.11, 2, 13.5,'2024-02-13',400),
	(2.26, 3, 27.45,'2024-03-19',100),
	(1.45, 4, 17.56,'2024-03-22',500);

-- purchase_detail table
INSERT INTO
    purchase_detail (unit_price, order_date, quantity, total_price)
VALUES
    (10, '2023-08-20', 8, 80),
	(1.49, '2023-09-13', 30, 44.7),
	(6, '2023-10-18', 20, 120),
	(17.99, '2023-12-20', 7, 125.93),
	(3.49, '2024-01-10', 25, 87.25),
	(7.99, '2024-02-16', 13, 103.87),
	(0.99, '2024-03-17', 40, 39.6),
	(9.99, '2024-03-19', 14, 139.86),
	(9.49, '2024-03-23', 8, 75.92),
	(15, '2024-03-28', 12, 180);

-- product table
INSERT INTO
    product (product_name, product_price, product_category, product_description, FK_purchase_detail_pk_purchase_id)
VALUES
    ('Espresso Beans', 19.99, 'Coffee', 'High-quality espresso beans for brewing rich and flavorful shots.', 55),
    ('Vanilla Syrup', 12.99, 'Syrups', 'A sweet and aromatic syrup for adding flavor to coffee and tea.', 10),
    ('Croissant', 2.49, 'Pastries', 'A buttery and flaky pastry perfect for breakfast or a snack.', 40),
    ('Green Tea', 4.99, 'Tea', 'A refreshing and healthy green tea known for its antioxidants.', 35),
    ('Chocolate Muffin', 3.99, 'Pastries', 'A moist and chocolaty muffin that pairs well with coffee.', 25),
    ('Caramel Macchiato', 5.49, 'Coffee Drinks', 'A popular espresso-based drink with caramel and steamed milk.', 50),
    ('Iced Tea', 3.99, 'Tea', 'A cool and refreshing iced tea available in various flavors.', 20),
    ('Ham and Cheese Sandwich', 13.99, 'Sandwiches', 'A classic sandwich with ham, cheese, lettuce, and tomato.', 45),
    ('Almond Milk', 5.49, 'Milk Alternatives', 'A dairy-free alternative made from almonds, perfect for lattes.', 30),
    ('Blueberry Scone', 2.99, 'Pastries', 'A delicious scone filled with blueberries and topped with glaze.', 15);

-- order_detail table
INSERT INTO
    order_detail (FK_order_pk_order_id, FK_product_pk_product_id, order_special_info, order_quantity, order_discount, order_prep_time, order_size)
VALUES
    (1, 10, 'Double shot', 2, 0.1, INTERVAL '15 minutes', 'Large'),
	(2, 60, 'Extra foam', 1, 0.0, INTERVAL '9 minutes', 'Medium'),
	(3, 30, 'None', 2, 0.15, INTERVAL '13 minutes', 'Medium'),
	(4, 20, 'None', 1, 0.05, INTERVAL '6 minutes', 'Large'),
	(5, 70, 'Extra ice', 2, 0.0, INTERVAL '8 minutes', 'Small'),
	(6, 90, 'None', 2, 0.0, INTERVAL '11 minutes', 'Large'),
	(7, 40, 'No sugar', 1, 0.10, INTERVAL '10 minutes', 'Medium'),
	(8, 80, 'Extra cheese', 2, 0.0, INTERVAL '15 minutes', 'Medium'),
	(9, 100, 'None', 1, 0.10, INTERVAL '10 minutes', 'Small'),
	(10, 50, 'Extra chocolate', 2, 0.0, INTERVAL '9 minutes', 'Medium');
