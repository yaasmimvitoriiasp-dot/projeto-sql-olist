
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