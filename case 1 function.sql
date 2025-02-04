-----MATERI FUNCTION, VIEWS----

----Case 1.1----
--total sales dan jumlah transaksi yang diperoleh tiap tahun--
select * from payments

select extract(year from paymentdate) as tahun,
sum(amount) as total_pembayaran,
count(checknumber) as jumlah_transaksi
from payments
group by extract(year from paymentdate)
order by extract(year from paymentdate);

-----case 1.2----
--berapa banyak total payments cust di atas atau di bawah rata-rata--

WITH total_transc_cust AS (
    SELECT customernumber, SUM(amount) AS total_transaksi
    FROM payments
    GROUP BY customernumber
),
kategori_pembayaran AS (
    SELECT 
        *,
        CASE 
            WHEN total_transaksi > (SELECT AVG(total_transaksi) FROM total_transc_cust) THEN 'above_avg'
            ELSE 'below_avg' 
        END AS payment_category
    FROM total_transc_cust
)
SELECT 
    payment_category, 
    COUNT(payment_category) AS number_of_payments
FROM kategori_pembayaran
GROUP BY payment_category;


-----case 1.3----
--customer loyalti--
select * from payments;

with frek_order as(
select c.customername, count(p.customernumber) as ordercount
from payments p
left join customers c using(customernumber)
group by c.customername
)
SELECT 
    customername,
    ordercount,
    CASE 
        WHEN ordercount = 1 THEN 'One-time Customer'
        WHEN ordercount = 2 THEN 'Repeated Customer'
        WHEN ordercount = 3 THEN 'Frequent Customer'
        WHEN ordercount >= 4 THEN 'Loyal Customer'
        ELSE 'No Orders'
    END AS customer_category
FROM frek_order;


---case 1.4----
--tren pembelian tiap negara dengan mencari tahu category----

create view tren_country as
with product_order as(
	select c.country, p.productline as product_category,
	count(od.orderlinenumber) as total_orders
	from customers c
	right join orders o using(customernumber)
	right join orderdetails od using(ordernumber)
	right join products p using(productcode)
	group by c.country, p.productline)
select country, product_category, total_orders
from product_order
where (country, total_orders) in (
	select country, max(total_orders) as max_orders
	from product_order
	group by country
);

SELECT * FROM tren_country;






