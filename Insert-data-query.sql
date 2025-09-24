USE marketplace_olist;

-- CATEGORIES (6)
INSERT INTO categories (category_id, category_name) VALUES
(1,'electronics'),(2,'home_kitchen'),(3,'sports_outdoors'),
(4,'books'),(5,'fashion'),(6,'beauty');

-- CUSTOMERS (8)
INSERT INTO customers (customer_id, first_name,last_name,email,phone,city,state,country_code)
VALUES
(1,'João','Silva','c1@example.com',NULL,'São Paulo','SP','BR'),
(2,'Maria','Santos','c2@example.com',NULL,'Rio de Janeiro','RJ','BR'),
(3,'Pedro','Oliveira','c3@example.com',NULL,'Belo Horizonte','MG','BR'),
(4,'Ana','Costa','c4@example.com',NULL,'Curitiba','PR','BR'),
(5,'Lucas','Almeida','c5@example.com',NULL,'Porto Alegre','RS','BR'),
(6,'Beatriz','Souza','c6@example.com',NULL,'Salvador','BA','BR'),
(7,'Rafael','Lima','c7@example.com',NULL,'Brasília','DF','BR'),
(8,'Camila','Rocha','c8@example.com',NULL,'Florianópolis','SC','BR');

-- SELLERS (6)
INSERT INTO sellers (seller_id, seller_name,email,phone,city,state,country_code)
VALUES
(1,'TechHouse','s1@sellers.com',NULL,'São Paulo','SP','BR'),
(2,'CasaBonita','s2@sellers.com',NULL,'Rio de Janeiro','RJ','BR'),
(3,'EsporteMax','s3@sellers.com',NULL,'Belo Horizonte','MG','BR'),
(4,'Livros&Co','s4@sellers.com',NULL,'Brasília','DF','BR'),
(5,'ModaBrasil','s5@sellers.com',NULL,'Salvador','BA','BR'),
(6,'BelezaPura','s6@sellers.com',NULL,'Curitiba','PR','BR');

-- EMPLOYEES (5)
INSERT INTO employees (employee_id, first_name,last_name,email,role,hired_at)
VALUES
(1,'Carla','Mendes','e1@company.com','manager','2024-04-01'),
(2,'Diego','Rosa','e2@company.com','warehouse','2024-06-10'),
(3,'Fernanda','Pires','e3@company.com','support','2024-07-15'),
(4,'Gustavo','Teixeira','e4@company.com','rider','2024-08-05'),
(5,'Helena','Barros','e5@company.com','analyst','2024-09-01');

-- PRODUCTS (12)
INSERT INTO products (product_id, sku, product_name, description, base_price,
                      weight_grams,length_cm,height_cm,width_cm)
VALUES
(1,'SKU-P1','Smartphone X','128GB, 6.1"',1200.00,180,14.50,0.80,7.00),
(2,'SKU-P2','Smartwatch Fit','GPS, HR monitor',300.00,60,4.20,1.20,3.80),
(3,'SKU-P3','Blender Pro','600W',150.00,2200,20.00,38.00,20.00),
(4,'SKU-P4','Nonstick Pan 28cm','Aluminium',45.00,900,28.00,5.00,28.00),
(5,'SKU-P5','Running Shoes','Men',220.00,700,30.00,12.00,20.00),
(6,'SKU-P6','Football Official Size 5','',35.00,430,22.00,22.00,22.00),
(7,'SKU-P7','Novel “Aventura”','',25.00,300,20.00,3.00,13.00),
(8,'SKU-P8','Cookbook “Sabores”','',30.00,450,24.00,3.00,17.00),
(9,'SKU-P9','T-shirt Basic','Unisex',19.00,200,25.00,2.00,20.00),
(10,'SKU-P10','Lipstick Matte','',15.00,70,10.00,2.00,2.00),
(11,'SKU-P11','Wireless Headphones','BT 5.0',180.00,250,18.00,7.00,16.00),
(12,'SKU-P12','Yoga Mat 6mm','',40.00,900,60.00,6.00,20.00);

-- PROMOTIONS (3)
INSERT INTO promotions (promotion_id,promo_name,promo_type,discount_percent,discount_amount,start_date,end_date,active)
VALUES
(1,'WELCOME10','coupon',10.00,NULL,'2025-01-01','2025-12-31',TRUE),
(2,'ELEC15','category_discount',15.00,NULL,'2025-01-01','2025-12-31',TRUE),
(3,'FLASH20','flash_sale',NULL,20.00,'2025-08-01','2025-08-31',TRUE);

SELECT COUNT(*) AS categories FROM categories;
SELECT COUNT(*) AS customers  FROM customers;
SELECT COUNT(*) AS sellers    FROM sellers;
SELECT COUNT(*) AS products   FROM products;
SELECT COUNT(*) AS promotions FROM promotions;

-- PRODUCT_CATEGORY_LINKS
INSERT INTO product_category_links (product_id, category_id) VALUES
(1,1),
(2,1),(2,5),
(3,2),(4,2),
(5,3),(5,5),
(6,3),
(7,4),(8,4),
(9,5),
(10,6),
(11,1),
(12,3);

-- SELLER_PRODUCTS
INSERT INTO seller_products (seller_id, product_id, list_price, available_stock) VALUES
(1,1,1199.00,50),
(1,2,299.00,60),
(1,11,179.00,40),
(2,3,149.00,100),
(2,4,44.00,120),
(2,1,1210.00,20),
(3,5,219.00,80),
(3,6,34.00,150),
(3,12,39.00,70),
(4,7,24.00,90),
(4,8,29.00,70),
(4,11,185.00,30),
(5,9,18.00,200),
(5,5,225.00,60),
(6,10,14.00,130),
(6,9,19.00,90);

SELECT COUNT(*) AS product_category_links FROM product_category_links;
SELECT COUNT(*) AS seller_products       FROM seller_products;

INSERT INTO product_promotions (product_id, promotion_id) VALUES
(1,2),(11,2),  
(9,1),(10,1),  
(5,3);         

INSERT INTO orders (order_id, customer_id, order_status, order_date, delivered_date, shipping_limit_date) VALUES
(1, 1,'delivered','2025-06-05 10:00:00','2025-06-10 15:00:00','2025-06-12 00:00:00'),
(2, 2,'delivered','2025-06-15 12:30:00','2025-06-20 16:00:00','2025-06-22 00:00:00'),
(3, 3,'shipped'  ,'2025-07-02 09:10:00',NULL,'2025-07-09 00:00:00'),
(4, 4,'delivered','2025-07-10 11:00:00','2025-07-14 13:00:00','2025-07-15 00:00:00'),
(5, 5,'canceled' ,'2025-07-20 18:00:00',NULL,'2025-07-25 00:00:00'),
(6, 6,'delivered','2025-08-01 08:45:00','2025-08-05 12:00:00','2025-08-06 00:00:00'),
(7, 1,'delivered','2025-08-15 19:30:00','2025-08-18 17:00:00','2025-08-20 00:00:00'),
(8, 7,'delivered','2025-08-20 14:50:00','2025-08-24 10:00:00','2025-08-25 00:00:00'),
(9, 8,'shipped'  ,'2025-09-05 10:00:00',NULL,'2025-09-12 00:00:00'),
(10,2,'approved' ,'2025-09-10 16:00:00',NULL,'2025-09-17 00:00:00');

INSERT INTO order_items (order_id, product_id, seller_id, quantity, unit_price, discount_value, freight_value) VALUES
-- O1 (c1)
(1,1,1, 1,1199.00,  0.00,25.00),
(1,11,4,1, 185.00,  0.00,10.00),

-- O2 (c2)
(2,5,3,  1,219.00,  0.00,15.00),
(2,9,6,  2, 19.00,  0.00, 8.00),
(2,10,6, 1, 14.00,  0.00, 6.00),

-- O3 (c3) - shipped
(3,3,2,  1,149.00,  0.00,12.00),
(3,4,2,  2, 44.00,  0.00,10.00),

-- O4 (c4)
(4,7,4,  1, 24.00,  0.00, 5.00),
(4,8,4,  1, 29.00,  0.00, 5.00),

-- O5 (c5) - canceled
(5,6,3,  1, 34.00,  0.00, 8.00),

-- O6 (c6)
(6,2,1,  1,299.00,  0.00,10.00),
(6,11,1, 1,179.00,  0.00,10.00),

-- O7 (c1)
(7,12,3, 1, 39.00,  0.00, 8.00),
(7,5,5,  1,225.00, 20.00,12.00), 

-- O8 (c7)
(8,1,2,  1,1210.00, 0.00,25.00),
(8,10,6, 2, 14.00,  0.00, 8.00),

-- O9 (c8) - shipped
(9,1,1,  1,1199.00, 0.00,25.00),
(9,2,1,  1, 299.00, 0.00,10.00),

-- O10 (c2) - approved
(10,9,5, 3, 18.00,  0.00, 9.00),
(10,3,2, 1,149.00,  0.00,12.00);

INSERT INTO payments (payment_id, order_id, payment_sequence, payment_type, payment_installments, payment_value, paid_at, payment_status) VALUES
(1, 1,1,'credit_card',1,1419.00,'2025-06-05 10:05:00','paid'),
(2, 2,1,'credit_card',1,295.00 ,'2025-06-15 12:35:00','paid'),
(3, 3,1,'boleto',      1,247.00 ,'2025-07-02 09:20:00','paid'),
(4, 4,1,'debit_card',  1, 58.00 ,'2025-07-10 11:05:00','paid'),
(5, 5,1,'credit_card', 1, 34.00 ,'2025-07-20 18:10:00','refunded'),
(6, 6,1,'pix',         1,488.00 ,'2025-08-01 08:50:00','paid'),
(7, 7,1,'voucher',     1,100.00 ,'2025-08-15 19:35:00','paid'),
(8, 7,2,'credit_card', 2,184.00 ,'2025-08-15 19:36:00','paid'),
(9, 8,1,'paypal',      1,1247.00,'2025-08-20 14:52:00','paid'),
(10,9,1,'credit_card', 3,1498.00,'2025-09-05 10:05:00','pending'),
(11,10,1,'credit_card',1,  75.00,'2025-09-10 16:05:00','pending');

INSERT INTO shipments (shipment_id, order_id, carrier, tracking_number, shipped_at, delivered_at, shipment_status, shipping_cost) VALUES
(1,1,'Correios','TRK001','2025-06-06','2025-06-10','delivered',35.00),
(2,2,'Correios','TRK002','2025-06-16','2025-06-20','delivered',29.00),
(3,3,'Correios','TRK003','2025-07-03',NULL,'in_transit',22.00),
(4,4,'Correios','TRK004','2025-07-11','2025-07-14','delivered',18.00),
(5,5,'Correios','TRK005',NULL,NULL,'ready',0.00),
(6,6,'Correios','TRK006','2025-08-02','2025-08-05','delivered',20.00),
(7,7,'Correios','TRK007','2025-08-16','2025-08-18','delivered',19.00),
(8,8,'Correios','TRK008','2025-08-21','2025-08-24','delivered',23.00),
(9,9,'Correios','TRK009','2025-09-06',NULL,'in_transit',26.00),
(10,10,'Correios','TRK010',NULL,NULL,'ready',0.00);

INSERT INTO order_promotions (order_id, promotion_id, applied_amount) VALUES
(6,2, 71.00),
(7,3, 20.00),
(8,1, 10.00);

INSERT INTO reviews (review_id, order_id, product_id, customer_id, score, comment, review_date) VALUES
(1,1,1,1,5,'Top Phone','2025-06-12'),
(2,1,11,1,4,'Great headphones','2025-06-12'),
(3,2,5,2,5,'Very comfortable shoes','2025-06-22'),
(4,2,10,2,4,'Beautiful color','2025-06-22'),
(5,4,8,4,4,'Very nice recepies','2025-07-16'),
(6,6,2,6,5,'Top Watch','2025-08-06'),
(7,7,5,1,3,'A bit small for me','2025-08-20'),
(8,8,1,7,5,'Quick delivered!','2025-08-25');

SELECT 'customers' t, COUNT(*) c FROM customers UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers UNION ALL
SELECT 'products', COUNT(*) FROM products UNION ALL
SELECT 'orders', COUNT(*) FROM orders UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items UNION ALL
SELECT 'payments', COUNT(*) FROM payments UNION ALL
SELECT 'shipments', COUNT(*) FROM shipments UNION ALL
SELECT 'reviews', COUNT(*) FROM reviews UNION ALL
SELECT 'categories', COUNT(*) FROM categories UNION ALL
SELECT 'product_category_links', COUNT(*) FROM product_category_links UNION ALL
SELECT 'seller_products', COUNT(*) FROM seller_products UNION ALL
SELECT 'promotions', COUNT(*) FROM promotions UNION ALL
SELECT 'product_promotions', COUNT(*) FROM product_promotions UNION ALL
SELECT 'order_promotions', COUNT(*) FROM order_promotions UNION ALL
SELECT 'employees', COUNT(*) FROM employees;

