--David Emmanuel González Cázares
--198582
--Bases de Datos
--Tarea 4: Tarea 1 de funciones


--Ejercicio 1. Promedio de tiempo de pagos de clientes de SakilaDB
with ct as
	(
		select c.customer_id as customer,cast(extract(epoch from p.payment_date) as integer) AS currentdate,   
		       lag(cast(extract(epoch from p.payment_date) as integer), 1,0) OVER (ORDER BY customer_id) AS previousdate  
		FROM payment p join customer c using(customer_id)
		order by c.customer_id
	)
select customer, concat('días: ', floor(avg(currentdate - previousdate)/86400),' hrs: ',floor((avg(currentdate - previousdate) - 86400*floor(avg(currentdate - previousdate)/86400))/3600),' min: ',floor((avg(currentdate - previousdate)- 86400*floor(avg(currentdate - previousdate)/86400) - 3600*floor((avg(currentdate - previousdate) - 86400*floor(avg(currentdate - previousdate)/86400))/3600))/60),' seg: ', floor(avg(currentdate-previousdate) - 86400*floor(avg(currentdate - previousdate)/86400) - 3600*floor((avg(currentdate - previousdate) - 86400*floor(avg(currentdate - previousdate)/86400))/3600) - 60*floor((avg(currentdate - previousdate)- 86400*floor(avg(currentdate - previousdate)/86400) - 3600*floor((avg(currentdate - previousdate) - 86400*floor(avg(currentdate - previousdate)/86400))/3600))/60))) as average_paytime
from ct
where currentdate>previousdate
group by customer
order by customer
offset 1 row;


--Ejercicio 2 de Tarea 1 ¿Sigue una distribución estándar?
--Varianza
with prom as
(
	with ct as
	(
		select c.customer_id as customer,cast(extract(epoch from p.payment_date) as integer) AS currentdate,   
		       lag(cast(extract(epoch from p.payment_date) as integer), 1,0) OVER (ORDER BY customer_id) AS previousdate  
		FROM payment p join customer c using(customer_id)
		order by c.customer_id
	)
	select customer, avg(currentdate - previousdate) as average_paytime
	from ct
	where currentdate>previousdate
	group by customer
	order by customer
	offset 1 row
)
select var_pop(average_paytime)
from prom;
--Promedio aritmético
with prom as
(
	with ct as
	(
		select c.customer_id as customer,cast(extract(epoch from p.payment_date) as integer) AS currentdate,   
		       lag(cast(extract(epoch from p.payment_date) as integer), 1,0) OVER (ORDER BY customer_id) AS previousdate  
		FROM payment p join customer c using(customer_id)
		order by c.customer_id
	)
	select customer, avg(currentdate - previousdate) as average_paytime
	from ct
	where currentdate>previousdate
	group by customer
	order by customer
	offset 1 row
)
select avg(average_paytime)
from prom;
--¿Cuántos tiempos promedios de clientes están a distancia de 1 desviación estándar del promedio global? Respuesta: 460 de 599 promedios (76.8% de acumulación)
with prom as
(
	with ct as
	(
		select c.customer_id as customer,cast(extract(epoch from p.payment_date) as integer) AS currentdate,   
		       lag(cast(extract(epoch from p.payment_date) as integer), 1,0) OVER (ORDER BY customer_id) AS previousdate  
		FROM payment p join customer c using(customer_id)
		order by c.customer_id
	)
	select customer, avg(currentdate - previousdate) as average_paytime
	from ct
	where currentdate>previousdate
	group by customer
	order by customer
	offset 1 row
)
select count(average_paytime)
from prom
where (
		(average_paytime < (select avg(average_paytime) + sqrt(var_pop(average_paytime)) from prom) and (average_paytime > (select avg(average_paytime) - sqrt(var_pop(average_paytime)) from prom)))
	);
--¿Cuántos tiempos promedios de clientes están a distancia de 2 desviaciones estándares del promedio global? Respuesta: 571 de 599 promedios (95% de acumulación aprox.)
with prom as
(
	with ct as
	(
		select c.customer_id as customer,cast(extract(epoch from p.payment_date) as integer) AS currentdate,   
		       lag(cast(extract(epoch from p.payment_date) as integer), 1,0) OVER (ORDER BY customer_id) AS previousdate  
		FROM payment p join customer c using(customer_id)
		order by c.customer_id
	)
	select customer, avg(currentdate - previousdate) as average_paytime
	from ct
	where currentdate>previousdate
	group by customer
	order by customer
	offset 1 row
)
select count(average_paytime)
from prom
where (
		(average_paytime < (select avg(average_paytime) + 2*sqrt(var_pop(average_paytime)) from prom) and (average_paytime > (select avg(average_paytime) - 2*sqrt(var_pop(average_paytime)) from prom)))
	);
--¿Cuántos tiempos promedios de clientes están a distancia de 3 desviaciones estándares del promedio global? Respuesta: 596 de 599 promedios (99.5% de acumulación aprox.)
with prom as
(
	with ct as
	(
		select c.customer_id as customer,cast(extract(epoch from p.payment_date) as integer) AS currentdate,   
		       lag(cast(extract(epoch from p.payment_date) as integer), 1,0) OVER (ORDER BY customer_id) AS previousdate  
		FROM payment p join customer c using(customer_id)
		order by c.customer_id
	)
	select customer, avg(currentdate - previousdate) as average_paytime
	from ct
	where currentdate>previousdate
	group by customer
	order by customer
	offset 1 row
)
select count(average_paytime)
from prom
where (
		(average_paytime < (select avg(average_paytime) + 3*sqrt(var_pop(average_paytime)) from prom) and (average_paytime > (select avg(average_paytime) - 3*sqrt(var_pop(average_paytime)) from prom)))
	);
--Respuesta de pregunta 2: Sí, los promedios de duración de pago de los clientes de Sakila siguen una distribución estándar, en general 
--a dos y tres desviaciones estándar (95%, 99.7% respectivamente), pero a una desviación estándar no sigue la acumulación
--(en vez de 68%, acumula 75%).
--Dibujo ejercicio 2: Histograma
CREATE OR REPLACE FUNCTION histogram(table_name_or_subquery text, column_name text)
RETURNS TABLE(bucket int, "range" numrange, freq bigint, bar text)
AS $func$
BEGIN
RETURN QUERY EXECUTE format('
  WITH
  source AS (
    SELECT * FROM %s
  ),
  min_max AS (
    SELECT min(%s) AS min, max(%s) AS max FROM source
  ),
  histogram AS (
    SELECT
      width_bucket(%s, min_max.min, min_max.max, 20) AS bucket,
      numrange(min(%s)::numeric, max(%s)::numeric, ''[]'') AS "range",
      count(%s) AS freq
    FROM source, min_max
    WHERE %s IS NOT NULL
    GROUP BY bucket
    ORDER BY bucket
  )
  SELECT
    bucket,
    "range",
    freq::bigint,
    repeat(''*'', (freq::float / (max(freq) over() + 1) * 15)::int) AS bar
  FROM histogram',
  table_name_or_subquery,
  column_name,
  column_name,
  column_name,
  column_name,
  column_name,
  column_name,
  column_name
  );
END
$func$ LANGUAGE plpgsql;


with prom as
(
	with ct as
	(
		select c.customer_id as customer,cast(extract(epoch from p.payment_date) as integer) AS currentdate,   
		       lag(cast(extract(epoch from p.payment_date) as integer), 1,0) OVER (ORDER BY customer_id) AS previousdate  
		FROM payment p join customer c using(customer_id)
		order by c.customer_id
	)
	select customer, avg(currentdate - previousdate) as average_paytime
	from ct
	where currentdate>previousdate
	group by customer
	order by customer
	offset 1 row
)
SELECT * FROM histogram('prom', 'average_paytime');

--Ejercicio 3
--¿Cómo se comparan los promedios de pagos con los promedios de rentas por cliente?
--Promedios individuales por cliente: Los días de pago son cada 3-7 días, y los días de renta son cada 22-40 días
with ct_pay as
	(
		select c.customer_id as customer,cast(extract(epoch from p.payment_date) as integer) AS currentdate,   
		       lag(cast(extract(epoch from p.payment_date) as integer), 1,0) OVER (ORDER BY customer_id) AS previousdate  
		FROM payment p join customer c using(customer_id)
		order by c.customer_id
	)
, ct_rent as
	(
		select c.customer_id as customer,cast(extract(epoch from r.rental_date) as integer) AS currentdate,   
		       lag(cast(extract(epoch from r.rental_date) as integer), 1,0) OVER (ORDER BY customer_id) AS previousdate  
		FROM rental r join customer c using(customer_id)
		order by c.customer_id
	)
select ct_pay.customer, concat('días: ', floor(avg(ct_pay.currentdate - ct_pay.previousdate)/86400),' hrs: ',floor((avg(ct_pay.currentdate - ct_pay.previousdate) - 86400*floor(avg(ct_pay.currentdate - ct_pay.previousdate)/86400))/3600),' min: ',floor((avg(ct_pay.currentdate - ct_pay.previousdate)- 86400*floor(avg(ct_pay.currentdate - ct_pay.previousdate)/86400) - 3600*floor((avg(ct_pay.currentdate - ct_pay.previousdate) - 86400*floor(avg(ct_pay.currentdate - ct_pay.previousdate)/86400))/3600))/60),' seg: ', floor(avg(ct_pay.currentdate-ct_pay.previousdate) - 86400*floor(avg(ct_pay.currentdate - ct_pay.previousdate)/86400) - 3600*floor((avg(ct_pay.currentdate - ct_pay.previousdate) - 86400*floor(avg(ct_pay.currentdate - ct_pay.previousdate)/86400))/3600) - 60*floor((avg(ct_pay.currentdate - ct_pay.previousdate)- 86400*floor(avg(ct_pay.currentdate - ct_pay.previousdate)/86400) - 3600*floor((avg(ct_pay.currentdate - ct_pay.previousdate) - 86400*floor(avg(ct_pay.currentdate - ct_pay.previousdate)/86400))/3600))/60))) as average_paytime
, concat('días: ', floor(avg(ct_rent.currentdate - ct_rent.previousdate)/86400),' hrs: ',floor((avg(ct_rent.currentdate - ct_rent.previousdate) - 86400*floor(avg(ct_rent.currentdate - ct_rent.previousdate)/86400))/3600),' min: ',floor((avg(ct_rent.currentdate - ct_rent.previousdate)- 86400*floor(avg(ct_rent.currentdate - ct_rent.previousdate)/86400) - 3600*floor((avg(ct_rent.currentdate - ct_rent.previousdate) - 86400*floor(avg(ct_rent.currentdate - ct_rent.previousdate)/86400))/3600))/60),' seg: ', floor(avg(ct_rent.currentdate-ct_rent.previousdate) - 86400*floor(avg(ct_rent.currentdate - ct_rent.previousdate)/86400) - 3600*floor((avg(ct_rent.currentdate - ct_rent.previousdate) - 86400*floor(avg(ct_rent.currentdate - ct_rent.previousdate)/86400))/3600) - 60*floor((avg(ct_rent.currentdate - ct_rent.previousdate)- 86400*floor(avg(ct_rent.currentdate - ct_rent.previousdate)/86400) - 3600*floor((avg(ct_rent.currentdate - ct_rent.previousdate) - 86400*floor(avg(ct_rent.currentdate - ct_rent.previousdate)/86400))/3600))/60))) as average_renttime
from ct_pay join ct_rent using(customer)
where ct_pay.currentdate>ct_pay.previousdate and ct_rent.currentdate>ct_rent.previousdate
group by customer
order by customer
offset 1 row;
--Promedios globales de todos los clientes por pagos y rentas: el promedio global de pagos es de casi 5 días, mientras que el de renta es de 33 días y medio aprox.
with prom_pay as
(
	with ct as
	(
		select c.customer_id as customer,cast(extract(epoch from p.payment_date) as integer) AS currentdate,   
		       lag(cast(extract(epoch from p.payment_date) as integer), 1,0) OVER (ORDER BY customer_id) AS previousdate  
		FROM payment p join customer c using(customer_id)
		order by c.customer_id
	)
	select customer, avg(currentdate - previousdate) as average_paytime
	from ct
	where currentdate>previousdate
	group by customer
	order by customer
	offset 1 row
)
, prom_rent as
(
	with ct as
	(
		select c.customer_id as customer,cast(extract(epoch from r.rental_date) as integer) AS currentdate,   
		       lag(cast(extract(epoch from r.rental_date) as integer), 1,0) OVER (ORDER BY customer_id) AS previousdate  
		FROM rental r join customer c using(customer_id)
		order by c.customer_id
	)
	select customer, avg(currentdate - previousdate) as average_renttime
	from ct
	where currentdate>previousdate
	group by customer
	order by customer
	offset 1 row
)
select to_timestamp(avg(average_paytime)) - '1970-01-01 00:00:00' as global_avg_paytime, 
		to_timestamp(avg(average_renttime)) - '1970-01-01 00:00:00' as global_avg_renttime
from prom_pay join prom_rent using(customer);
--Histogramas:
--Pagos
with prom_pay as
(
	with ct as
	(
		select c.customer_id as customer,cast(extract(epoch from p.payment_date) as integer) AS currentdate,   
		       lag(cast(extract(epoch from p.payment_date) as integer), 1,0) OVER (ORDER BY customer_id) AS previousdate  
		FROM payment p join customer c using(customer_id)
		order by c.customer_id
	)
	select customer, avg(currentdate - previousdate) as average_paytime
	from ct
	where currentdate>previousdate
	group by customer
	order by customer
	offset 1 row
)
SELECT * FROM histogram('prom_pay', 'average_paytime');
--Rentas
with prom_rent as
(
	with ct as
	(
		select c.customer_id as customer,cast(extract(epoch from r.rental_date) as integer) AS currentdate,   
		       lag(cast(extract(epoch from r.rental_date) as integer), 1,0) OVER (ORDER BY customer_id) AS previousdate  
		FROM rental r join customer c using(customer_id)
		order by c.customer_id
	)
	select customer, avg(currentdate - previousdate) as average_renttime
	from ct
	where currentdate>previousdate
	group by customer
	order by customer
	offset 1 row
)
SELECT * FROM histogram('prom_rent', 'average_renttime');