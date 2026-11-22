
-- 1. Status por estado
SELECT
    order_status,
    COUNT(*) AS quantidade_status
FROM ecommerce.orders
GROUP BY order_status
ORDER BY quantidade_status DESC;

-- 2. Pedidos por estado
select 
	count(o.order_id) as total_pedidos,
	c.customer_state as estado
from ecommerce.orders o
inner join ecommerce.customers c
	on c.customer_id = o.customer_id
group by estado
order by total_pedidos desc

-- 3. Clientes únicos por estado
select 
	customer_state as estado,
	count (distinct customer_unique_id) as clientes_unicos
from ecommerce.customers
group by customer_state
order by clientes_unicos desc

-- 4. Clientes que compraram mais de uma vez
select * 
from ecommerce.customers
limit 10;

select 
	customer_unique_id as cliente,
	count(customer_unique_id) as quantidade_pedidos
from ecommerce.customers 
group by customer_unique_id
having count (customer_unique_id) > 1
order by cliente_unico desc;

--5. Status que possuem + 500 pedidos
select
	 order_status as status,
	count(distinct order_id) as qtd_pedidos 
from ecommerce.orders
group by order_status
having count(distinct order_id) > 500 
order by qtd_pedidos desc;

--6. Registros que aparecem mais de uma vez por pessoa
select 
	count(customer_id) as id_registro_qtd,
	customer_unique_id as id_cliente
from ecommerce.customers
group by id_cliente
having count(customer_id)>1
limit 5

--7. Mostrar
--Registros que aparecem mais de uma vez por pessoa
select 
	c.customer_unique_id as id_cliente,
	c.customer_id as id_registro,	
	o.order_id as order_id
from ecommerce.customers c
inner join  ecommerce.orders o
on c.customer_id = o.customer_id
where customer_unique_id = '00172711b30d52eea8b313a7f2cced02'

-- 8. ID de registro de cliente associado a mais de um pedido
select 
 o.order_id,
 c.customer_id,
 c.customer_unique_id
from ecommerce.customers c
inner join ecommerce.orders o
on c.customer_id = o.customer_id
where customer_unique_id = '00172711b30d52eea8b313a7f2cced02'

--9.customer_id associado a mais de um pedido
select 
count(order_id) as qtd_pe,
customer_id as id_registro
from ecommerce.orders
group by order_id
limit 5

--10. conferencia da unicidade de customer_id
select 
	count(*) as qtd_linhas_totais,
	count(distinct customer_id) as qtd_registros_distinta
from ecommerce.customers

--11. quais pessoas possuem mais de um registro em customers, 
--e quantos registros cada uma possui?
select 
	customer_unique_id as id_pessoa,
	count(customer_id) as qtd_id_pessoas_distintas
from ecommerce.customers
group by id_cliente
having count(customer_id) > 1
order by qtd_registros desc

--12. Quantas pessoas diferentes estão representadas na 
--tabela customers?
select 
	count(customer_unique_id) as qtd_id_pessoa,
	count(distinct customer_unique_id) as qtd_id_pessoas_distintas
	from ecommerce.customers 

--13. Quais são os cinco estados com mais pessoas diferentes na 
--tabela customers?
select
 count(distinct customer_unique_id) as qtd_id_pessoa,
 customer_state as uf_pessoa
from ecommerce.customers 
group by uf_pessoa
order by qtd_id_pessoa desc
limit 5

--14 Quais tabelas existem
SELECT 
table_name, data_type
FROM information_schema.columns
wher
limit 5;

--.15 Colunas existentes e seus tipos
SELECT 
table_type
FROM information_schema.tables
limit 5; 

--16. liste as 10 pessoas que 
--mais fizeram pedidos, usando só a tabela customers
select 
	count(customer_id) as qtd_pedido,
	customer_unique_id as id_cliente_unico
from ecommerce.customers
group by customer_unique_id
order by qtd_pedido desc
limit 10

CREATE TABLE ecommerce.order_payments (
    order_id             VARCHAR(32),
    payment_sequential   INTEGER,
    payment_type         VARCHAR(30),
    payment_installments INTEGER,
    payment_value        NUMERIC(10,2)
);

select
count(*) as qtd_linhas
from ecommerce.order_payments

CREATE TABLE ecommerce.order_items (
    order_id            VARCHAR(32),
    order_item_id       INTEGER,
    product_id          VARCHAR(32),
    seller_id           VARCHAR(32),
    shipping_limit_date TIMESTAMP,
    price               NUMERIC(10,2),
    freight_value       NUMERIC(10,2)
);
select
count(*) as qtd_linhas
from ecommerce.products

CREATE TABLE ecommerce.order_reviews (
    review_id               VARCHAR(32),
    order_id                VARCHAR(32),
    review_score            INTEGER,
    review_comment_title    TEXT,
    review_comment_message  TEXT,
    review_creation_date    TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

CREATE TABLE ecommerce.products (
    product_id                 VARCHAR(32),
    product_category_name      VARCHAR(100),
    product_name_lenght        INTEGER,
    product_description_lenght INTEGER,
    product_photos_qty         INTEGER,
    product_weight_g           INTEGER,
    product_length_cm          INTEGER,
    product_height_cm          INTEGER,
    product_width_cm           INTEGER
);
select * from ecommerce.orders limit 5
select * from ecommerce.customers limit 5
select * from ecommerce.order_payments limit 5

--17.liste todos os
--estados com a quantidade de pedidos entregues em cada um

select 
	c.customer_state,
	count(c.customer_id)  as qtd_pedidos
	--o.order_status
from ecommerce.customers c
left join ecommerce.orders o
on c.customer_id = o.customer_id
where o.order_status = 'delivered'
group by c.customer_state 
order by qtd_pedidos desc

--18. faturamento por estado
select 
	c.customer_state as cliente_estado,
	sum(p.payment_value) as valor_total_pago
from 
	ecommerce.customers c
inner join 
	ecommerce.orders o
on 
	c.customer_id = o.customer_id
inner join 
	ecommerce.order_payments p
on 
	o.order_id = p.order_id
where 
	o.order_status = 'delivered'
group by 
	cliente_estado
order by 
	valor_total_pago desc

--19. O order_id é único na tabela orders
select 
	count(order_id) as order_id_qtd,
	count(distinct order_id) as order_id_qtd_distinto
from ecommerce.orders

--20. o customer_id é único na tabela customers
select 
	count(customer_id) as customer_id_qtd,
	count(distinct customer_id) as customer_id_qtd_distinta
from ecommerce.customers

--21. quantos pedidos aparecem mais de uma vez 
--na order_payments
select * from ecommerce.order_payments limit 5
select
	order_id,
	count(order_id) as qtd_order_id
from ecommerce.order_payments
group by order_id
having count(order_id) > 1

--22.quantos pedidos aparecem mais de uma vez na 
--order_items
select 
 count(order_id) as qtd_order_id
from 
	ecommerce.order_items
group by 
	order_id
having
	count(order_id) > 1
--23.
select
	order_id,
	count(order_id) as qtd_order_id
from 
	ecommerce.order_payments
where 
	order_id in ('7842147864c0425541edd55923f3c0f1', 
	'b81ef226f3fe1789b1e8b2acac839d17')
group by 
	order_id
having 
	count(order_id) > 1

--23.ticket médio dos pedidos entregues
select 
	round(sum(p.payment_value) / count(distinct p.order_id),2) as ticket_medio
from 
	ecommerce.order_payments p
inner join 
	ecommerce.orders o
on
	p.order_id = o.order_id
where 
	order_status = 'delivered'
--24.quais pedidos entregues não têm nenhuma linha na order_payments
select 
	o.order_id,
	count(o.order_id) as qtd_order_id
from
	ecommerce.orders o
left join 
	ecommerce.order_payments p
on
	o.order_id = p.order_id 
where
	o.order_status = 'delivered' and p.payment_value is null
group by
	o.order_id
order by 
	count(o.order_id) desc

select * from ecommerce.order_reviews limit 5

select 
	count(*) as qtd_linhas
from 
	ecommerce.orders o
left join 
	ecommerce.order_reviews r
on 
	o.order_id = r.order_id
where 
	r.order_id is null

--25. Quantos pedidos não têm nenhum item na order_items?
select 
	count(*) as qtd_linhas
from
	ecommerce.orders o
left join 
	ecommerce.order_items i
on 
	o.order_id = i.order_id
where 
	i.order_id is null

--26. Quantos produtos da products nunca foram vendidos?
select 
	count(*) as qtd_linhas
from 
	ecommerce.products p 
left join 
	ecommerce.order_items i
on 
	p.product_id = i.product_id
where
	i.product_id is null
--27. Qual pedido entregue não tem nenhum pagamento registrado?
select 
	o.order_id
from 
	ecommerce.orders o
left join 
	ecommerce.order_payments p
on 
	p.order_id = o.order_id
where 
	o.order_status = 'delivered' and p.payment_value is null
--28. Quantos pedidos sem avaliação existem em cada status de pedido?
select 
	o.order_status,
	count(*) as qtd_pedido_sem_avaliacao
from
	ecommerce.orders o
left join 
	ecommerce.order_reviews r
on 
	o.order_id = r.order_id 
where 
	r.review_id is null
group by 
	o.order_status
order by
	count(*) desc
--29 Quais são as formas de pagamento mais usadas, 
--e quantos pedidos usaram cada uma?
select 
	payment_type,
	count(order_id) as qtd_pedidos
from
	ecommerce.order_payments
group by 
	payment_type
order by 
	count(order_id) desc


select 
	count(order_id) as qtd_pedidos
from
	ecommerce.order_payments

--30. Existem pedidos que 
--aparecem mais de uma vez com a mesma forma de pagamento? Quantos?
select 
	order_id,
	count(payment_type)
from
	ecommerce.order_payments
group by 
	order_id
having 
	count(payment_type) > 1
order by
	count(payment_type) desc

--31. Quantos pedidos têm exatamente 1 pagamento? 
select 
	count(*)
from
(select 
	count(*)
from 
	ecommerce.order_payments
group by 
	order_id
having 
	count(payment_type) = 1) as um_pagamento
 
--32. Quantos pedidos diferentes aparecem mais de uma 
--vez com a mesma forma de pagamento? 
select 
	count(distinct order_id)
from
(select 
	order_id
from 
	ecommerce.order_payments 
group by 
	order_id, payment_type
having 
	count(payment_type) > 1) as same_payment

	

