CREATE OR REPLACE VIEW v_orders_revenue_by_state AS
SELECT
  c.state,
  COUNT(DISTINCT o.order_id)                          AS total_orders,
  SUM( (oi.quantity * oi.unit_price) - COALESCE(oi.discount_value,0) + COALESCE(oi.freight_value,0) ) AS gross_revenue
FROM orders o
JOIN customers c     ON c.customer_id = o.customer_id
JOIN order_items oi  ON oi.order_id    = o.order_id
WHERE o.order_status IN ('delivered','shipped','approved')
GROUP BY c.state
ORDER BY gross_revenue DESC;

SELECT * FROM v_orders_revenue_by_state;

CREATE OR REPLACE VIEW v_monthly_sales_trend AS
SELECT
  DATE_FORMAT(o.order_date,'%Y-%m') AS yyyymm,
  COUNT(DISTINCT o.order_id)        AS orders_cnt,
  SUM( (oi.quantity * oi.unit_price) - COALESCE(oi.discount_value,0) + COALESCE(oi.freight_value,0) ) AS gross_revenue
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.order_status NOT IN ('canceled','refunded')
GROUP BY DATE_FORMAT(o.order_date,'%Y-%m')
ORDER BY yyyymm;

SELECT * FROM v_monthly_sales_trend;

