-- Original Version
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

CREATE INDEX ix_order_items_order_product
ON order_items(order_id, product_id);

WITH distinct_items AS (
  SELECT DISTINCT order_id, product_id
  FROM order_items
)
SELECT
  p1.product_name AS product_a,
  p2.product_name AS product_b,
  COUNT(*) AS together_orders
FROM distinct_items di1
JOIN distinct_items di2
  ON di1.order_id = di2.order_id
 AND di1.product_id < di2.product_id
JOIN products p1 ON p1.product_id = di1.product_id
JOIN products p2 ON p2.product_id = di2.product_id
GROUP BY product_a, product_b
HAVING together_orders >= 1
ORDER BY together_orders DESC, product_a, product_b;

