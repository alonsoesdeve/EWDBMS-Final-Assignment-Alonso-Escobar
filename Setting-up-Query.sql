-- Creation of Dataset
DROP DATABASE IF EXISTS marketplace_olist;
CREATE DATABASE marketplace_olist
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;
USE marketplace_olist;

-- Customers
CREATE TABLE customers (
  customer_id   INT PRIMARY KEY AUTO_INCREMENT,
  first_name    VARCHAR(50) NOT NULL,
  last_name     VARCHAR(50) NOT NULL,
  email         VARCHAR(120) NOT NULL UNIQUE,
  phone         VARCHAR(30),
  city          VARCHAR(100),
  state         VARCHAR(100),
  country_code  CHAR(2) DEFAULT 'BR',
  created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Sellers
CREATE TABLE sellers (
  seller_id     INT PRIMARY KEY AUTO_INCREMENT,
  seller_name   VARCHAR(120) NOT NULL,
  email         VARCHAR(120) UNIQUE,
  phone         VARCHAR(30),
  city          VARCHAR(100),
  state         VARCHAR(100),
  country_code  CHAR(2) DEFAULT 'BR',
  created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Categories
CREATE TABLE categories (
  category_id   INT PRIMARY KEY AUTO_INCREMENT,
  category_name VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- Products
CREATE TABLE products (
  product_id    INT PRIMARY KEY AUTO_INCREMENT,
  sku           VARCHAR(64) UNIQUE,
  product_name  VARCHAR(255) NOT NULL,
  description   TEXT,
  base_price    DECIMAL(10,2) NOT NULL,
  weight_grams  INT,
  length_cm     DECIMAL(7,2),
  height_cm     DECIMAL(7,2),
  width_cm      DECIMAL(7,2),
  created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Employees
CREATE TABLE employees (
  employee_id   INT PRIMARY KEY AUTO_INCREMENT,
  first_name    VARCHAR(50) NOT NULL,
  last_name     VARCHAR(50) NOT NULL,
  email         VARCHAR(120) NOT NULL UNIQUE,
  role          ENUM('support','warehouse','manager','rider','analyst') NOT NULL,
  hired_at      DATE NOT NULL
) ENGINE=InnoDB;

-- Promotions
CREATE TABLE promotions (
  promotion_id     INT PRIMARY KEY AUTO_INCREMENT,
  promo_name       VARCHAR(120) NOT NULL,
  promo_type       ENUM('coupon','category_discount','flash_sale') NOT NULL,
  discount_percent DECIMAL(5,2),
  discount_amount  DECIMAL(10,2),
  start_date       DATE NOT NULL,
  end_date         DATE,
  active           BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB;

-- Orders
CREATE TABLE orders (
  order_id            INT PRIMARY KEY AUTO_INCREMENT,
  customer_id         INT NOT NULL,
  order_status        ENUM('created','approved','invoiced','shipped','delivered','canceled','refunded') NOT NULL DEFAULT 'created',
  order_date          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  delivered_date      DATETIME NULL,
  shipping_limit_date DATETIME NULL,
  CONSTRAINT fk_orders_customer
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Payments
CREATE TABLE payments (
  payment_id           INT PRIMARY KEY AUTO_INCREMENT,
  order_id             INT NOT NULL,
  payment_sequence     INT DEFAULT 1,
  payment_type         ENUM('credit_card','debit_card','voucher','boleto','pix','paypal') NOT NULL,
  payment_installments INT DEFAULT 1,
  payment_value        DECIMAL(10,2) NOT NULL,
  paid_at              DATETIME,
  payment_status       ENUM('pending','paid','failed','refunded') DEFAULT 'pending',
  CONSTRAINT fk_payments_order
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Shipments
CREATE TABLE shipments (
  shipment_id      INT PRIMARY KEY AUTO_INCREMENT,
  order_id         INT NOT NULL,
  carrier          VARCHAR(100),
  tracking_number  VARCHAR(100),
  shipped_at       DATETIME,
  delivered_at     DATETIME,
  shipment_status  ENUM('ready','in_transit','delivered','delayed','lost','returned') DEFAULT 'ready',
  shipping_cost    DECIMAL(10,2) DEFAULT 0,
  CONSTRAINT fk_shipments_order
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Reviews
CREATE TABLE reviews (
  review_id     INT PRIMARY KEY AUTO_INCREMENT,
  order_id      INT NOT NULL,
  product_id    INT NOT NULL,
  customer_id   INT NOT NULL,
  score         TINYINT NOT NULL,
  comment       TEXT,
  review_date   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_reviews_order
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_reviews_product
    FOREIGN KEY (product_id) REFERENCES products(product_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_reviews_customer
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- order_items (Orders ↔ Products ↔ Sellers)
CREATE TABLE order_items (
  order_id        INT NOT NULL,
  product_id      INT NOT NULL,
  seller_id       INT NOT NULL,
  quantity        INT NOT NULL,
  unit_price      DECIMAL(10,2) NOT NULL,
  discount_value  DECIMAL(10,2) DEFAULT 0,
  freight_value   DECIMAL(10,2) DEFAULT 0,
  PRIMARY KEY (order_id, product_id, seller_id),
  CONSTRAINT fk_items_order
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_items_product
    FOREIGN KEY (product_id) REFERENCES products(product_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_items_seller
    FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- seller_products (Sellers ↔ Products)
CREATE TABLE seller_products (
  seller_id      INT NOT NULL,
  product_id     INT NOT NULL,
  list_price     DECIMAL(10,2) NOT NULL,
  available_stock INT DEFAULT 0,
  PRIMARY KEY (seller_id, product_id),
  CONSTRAINT fk_seller_products_seller
    FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_seller_products_product
    FOREIGN KEY (product_id) REFERENCES products(product_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- product_category_links (Products ↔ Categories)
CREATE TABLE product_category_links (
  product_id   INT NOT NULL,
  category_id  INT NOT NULL,
  PRIMARY KEY (product_id, category_id),
  CONSTRAINT fk_pcl_product
    FOREIGN KEY (product_id) REFERENCES products(product_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_pcl_category
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- product_promotions (Products ↔ Promotions)
CREATE TABLE product_promotions (
  product_id    INT NOT NULL,
  promotion_id  INT NOT NULL,
  PRIMARY KEY (product_id, promotion_id),
  CONSTRAINT fk_pp_product
    FOREIGN KEY (product_id) REFERENCES products(product_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_pp_promotion
    FOREIGN KEY (promotion_id) REFERENCES promotions(promotion_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- order_promotions (Orders ↔ Promotions)
CREATE TABLE order_promotions (
  order_id      INT NOT NULL,
  promotion_id  INT NOT NULL,
  applied_amount DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (order_id, promotion_id),
  CONSTRAINT fk_op_order
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_op_promotion
    FOREIGN KEY (promotion_id) REFERENCES promotions(promotion_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE INDEX ix_orders_customer_id  ON orders(customer_id);
CREATE INDEX ix_orders_order_date   ON orders(order_date);
CREATE INDEX ix_items_product_id    ON order_items(product_id);
CREATE INDEX ix_items_seller_id     ON order_items(seller_id);
CREATE INDEX ix_payments_order_id   ON payments(order_id);
CREATE INDEX ix_shipments_order_id  ON shipments(order_id);
CREATE INDEX ix_reviews_product_id  ON reviews(product_id);
CREATE INDEX ix_seller_products_pr  ON seller_products(product_id);
CREATE INDEX ix_pcl_category_id     ON product_category_links(category_id);

