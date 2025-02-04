----CASE FUNCTION, VIEWS---
---CASE 2.1----
---melihat rata-rata hari untuk repeat order---

WITH RepeatOrders AS (
    SELECT 
		customername,
        customernumber,
        paymentdate,
        LEAD(paymentdate) OVER (PARTITION BY customernumber ORDER BY paymentdate) AS next_order_date
    FROM payments
	LEFT JOIN customers using(customernumber)
)
SELECT 
	customername,
    customernumber,
    paymentdate,
    next_order_date,
    EXTRACT(DAY FROM (next_order_date::TIMESTAMP - paymentdate::TIMESTAMP)) AS days_to_next_order
FROM RepeatOrders
WHERE next_order_date IS NOT NULL;


----case 2.2----
---melihat pembelian pertama dan total pertama---

with first_payments as(
	select
		customername, customernumber,
		min(paymentdate) as first_pay_date
	from payments
	left join customers using(customernumber)
	group by customername, customernumber
)
select fp.customernumber, fp.customername, fp.first_pay_date,
	sum(p.amount) as first_transc
from first_payments fp
left join payments p
	ON fp.customernumber = p.customernumber 
    AND fp.first_pay_date = p.paymentdate
GROUP BY fp.customernumber, fp.customername, fp.first_pay_date;
)


-----case 2.3----
--melihat customer order pertama dan terakhir tiap negara---

with customerorders as(
	select c.country, c.customername, c.customernumber,
		min(o.orderdate) as first_order_date,
		max(o.orderdate) as last_order_date
	from orders o
	left join customers c
		on o.customernumber = c.customernumber
	group by c.customernumber, c.customername, c.country
),
firstlastorders as(
	select co.country,
	(select customername
	from customerorders
	where country = co.country and first_order_date = (select min(first_order_date) from customerorders where country = co.country)) as firstcustomer,
	(select customername
	from customerorders
	where country = co.country and last_order_date = (select max(last_order_date) from customerorders where country = co.country)) as lastcustomer

	from customerorders co
	group by co.country
)

select * 
from firstlastorders;

