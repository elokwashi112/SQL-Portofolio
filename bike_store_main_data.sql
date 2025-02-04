
-----ANALISIS PELANGGAN DAN PENJUALAN---
--1. pelanggan spend terbanyak---


SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name,
    SUM(oi.quantity * oi.list_price) AS total_belanja
FROM 
    customers AS c
JOIN 
    orders AS o 
ON 
    c.customer_id = o.customer_id
JOIN 
    order_items AS oi 
ON 
    o.order_id = oi.order_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name
ORDER BY 
    total_belanja DESC
LIMIT 10;

--2. Pelanggan dengan spent terkecil
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name,
    SUM(oi.quantity * oi.list_price) AS total_belanja
FROM 
    customers AS c
JOIN 
    orders AS o 
ON 
    c.customer_id = o.customer_id
JOIN 
    order_items AS oi 
ON 
    o.order_id = oi.order_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name
ORDER BY 
    total_belanja ASC
LIMIT 10;

--- 3. Pelanggan dengan pembelian lebih dari sekali?
SELECT c.customer_id, c.first_name, c.last_name, 
       COUNT(o.order_id) AS total_pembelian
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > 2;



---4. pelanggan yang sudah membeli 3 kali, dan paling rendah---

