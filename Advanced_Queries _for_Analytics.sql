-- Top 3 revenue products per category
WITH prod_cat AS (
  SELECT
    c.category_name,
    p.product_id,
    p.product_name,
    SUM( (oi.quantity * oi.unit_price)
        - COALESCE(oi.discount_value,0)
        + COALESCE(oi.freight_value,0) ) AS revenue
  FROM order_items oi
  JOIN products p                ON p.product_id = oi.product_id
  JOIN product_category_links pcl ON pcl.product_id = p.product_id
  JOIN categories c              ON c.category_id = pcl.category_id
  GROUP BY c.category_name, p.product_id, p.product_name
),
ranked AS (
  SELECT
    category_name, product_id, product_name, revenue,
    ROW_NUMBER() OVER (PARTITION BY category_name ORDER BY revenue DESC) AS rn
  FROM prod_cat
)
SELECT category_name, product_name, revenue
FROM ranked
WHERE rn <= 3
ORDER BY category_name, revenue DESC;

-- Total Cost, #orders y client segmentation
WITH order_revenue AS (
  SELECT
    o.order_id,
    o.customer_id,
    SUM( (oi.quantity * oi.unit_price)
        - COALESCE(oi.discount_value,0)
        + COALESCE(oi.freight_value,0) ) AS order_revenue
  FROM orders o
  JOIN order_items oi ON oi.order_id = o.order_id
  WHERE o.order_status NOT IN ('canceled','refunded')
  GROUP BY o.order_id, o.customer_id
)
SELECT
  c.customer_id,
  CONCAT(c.first_name,' ',c.last_name) AS customer_name,
  COUNT(*)                              AS orders_count,
  SUM(order_revenue)                    AS total_revenue,
  ROUND(AVG(order_revenue),2)           AS avg_order_value,
  CASE
    WHEN SUM(order_revenue) >= 1000 THEN 'Whale'
    WHEN SUM(order_revenue) BETWEEN 300 AND 999 THEN 'Core'
    ELSE 'Light'
  END AS segment
FROM order_revenue r
JOIN customers c ON c.customer_id = r.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY total_revenue DESC;

-- Revenue per seller and delievery time (only delivered)
SELECT
  s.seller_id,
  s.seller_name,
  ROUND(SUM( (oi.quantity * oi.unit_price)
            - COALESCE(oi.discount_value,0)
            + COALESCE(oi.freight_value,0) ),2) AS seller_revenue,
  ROUND(AVG(DATEDIFF(sh.delivered_at, sh.shipped_at)),2) AS avg_days_delivery,
  COUNT(DISTINCT oi.order_id) AS orders_served
FROM order_items oi
JOIN sellers s   ON s.seller_id = oi.seller_id
JOIN shipments sh ON sh.order_id = oi.order_id
JOIN orders o     ON o.order_id = oi.order_id
WHERE sh.shipment_status = 'delivered'
  AND o.order_status     = 'delivered'
GROUP BY s.seller_id, s.seller_name
HAVING seller_revenue > 0
ORDER BY seller_revenue DESC;

-- Average of Score per product above the global average
SELECT
  p.product_id,
  p.product_name,
  ROUND(AVG(r.score),2) AS avg_score,
  COUNT(*)              AS reviews_count
FROM reviews r
JOIN products p ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name
HAVING AVG(r.score) > (SELECT AVG(score) FROM reviews)
ORDER BY avg_score DESC, reviews_count DESC;

-- Pairs of Products in the same order
SELECT
  p1.product_name AS product_a,
  p2.product_name AS product_b,
  COUNT(DISTINCT oi1.order_id) AS together_orders
FROM order_items oi1
JOIN order_items oi2
  ON oi1.order_id = oi2.order_id
 AND oi1.product_id < oi2.product_id
JOIN products p1 ON p1.product_id = oi1.product_id
JOIN products p2 ON p2.product_id = oi2.product_id
JOIN orders o    ON o.order_id = oi1.order_id
WHERE o.order_status NOT IN ('canceled','refunded')
GROUP BY product_a, product_b
HAVING together_orders >= 1
ORDER BY together_orders DESC, product_a, product_b;

