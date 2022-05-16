--David Emmanuel González Cázares 198582--
--Base de Datos--
--Tarea 3--
--Agrupaciones III--

--Ejercicio 1--
--¿Cómo obtenemos todos los nombres de neustros clientes canadienses para una campaña?--
select c.customer_id, concat(c.first_name, ' ', c.last_name) as nombre
from customer c 
join address a using(address_id) 
join city ci using(city_id) 
join country co using(country_id)
where co.country = 'Canada';
--¿Qué cliente ha rentado más de nuestra sección de adultos?--
select concat(c.first_name, ' ', c.last_name) as nombre, count(*) as numpeliculas
from payment p 
join customer c using(customer_id) 
join rental r using(rental_id)
join inventory i using(inventory_id) 
join film f using(film_id)
where f.rating='R'
group by c.customer_id
order by numpeliculas desc;
--¿Qué películas son las más rentadas en todas nuestras stores?--
select t.store_id, t.title, max(t.num_ordenes)
from (
	select s.store_id, f.title, count(p.payment_id) as num_ordenes
	from payment p
	join rental r on r.rental_id = p.rental_id
	join inventory i on i.inventory_id = r.inventory_id
	join store s on s.store_id = i.store_id
	join film f on f.film_id = i.store_id
	group by s.store_id, f.title
) t
group by t.store_id, t.title
order by t.store_id;
--Cuál es nuestro revenue por store?--
select s.store_id, sum(p.amount) as revenue
from payment p 
join rental r using(rental_id)
join inventory i using(inventory_id)
join store s using(store_id)
group by s.store_id
order by s.store_id asc;



