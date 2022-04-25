--David Emmanuel González Cázares 198582--
--Tarea 1--
--Módulo 6--
--Ejercicio 1--
--Proveedores con posición 'Sales Representative'--
select s.contact_name 
from suppliers s 
where s.contact_title = 'Sales Representative';
--Ejercicio 2--
--Proveedores que no son 'Marketing Manager'--
select s.contact_name 
from suppliers s 
where s.contact_title != 'Marketing Manager';
--Ejercicio 3--
--Órdenes que no son de Estados Unidos--
select o.customer_id 
from orders o 
where o.ship_country != 'USA';
--Ejercicio 4--
--Productos transportados que sean quesos--
select * from products pr 
where pr.product_name like '%Queso%';
--Ejercicio 5--
--Órdenes de Bélgica o Francia--
select * from orders o 
where o.ship_country in ('Belgium', 'France');
--Ejercicio 6--
--Órdenes de LATAM--
select * from orders o 
where o.ship_country in ('Mexico','Venezuela','Argentina','Brazil');
--Ejercicio 7--
--Órdenes que no son para LATAM--
select * from orders o 
where o.ship_country not in ('Mexico','Venezuela','Argentina','Brazil');
--Ejercicio 8--
--Nombre completo de empleados--
select concat(em.first_name, ' ', em.last_name) as "Full Name" 
from employees em;
--Ejercicio 9--
--Dinero total de inventario--
select sum(pr.units_in_stock * pr.unit_price) 
from products p;
--Ejercicio 10--
--Total de clientes por cada país--
select c.country, count(c.customer_id) 
from customers c 
group by c.country;

--Módulo 8--
--Ejercicio 1--
--Reporte de edades de empleador para eligibilidad de gastos médicos menores--
select em.employee_id, ((now()-em.birth_date)/365) as "Age" 
from employees em;
--Ejercicio 2--
--Orden má reciente por cliente--
select com.company_name as "Company Name", max(o.order_date) as "Most Recent Order" 
from orders o join customers com on o.customer_id = com.customer_id 
group by com.company_name; 
--Ejercicio 3--
--Función que desempeña cada cliente y cuántos son--
select c.contact_title, count(c.customer_id) 
from customers c 
group by c.contact_title;
--Ejercicio 4--
--¿Cuántos productos hay de cada categoría?--
select cat.category_name, count(cat.category_id) 
from products p join categories cat on p.category_id = cat.category_id 
group by cat.category_name;
--Ejercicio 5--
--Reporte de reorder--
select p.product_name,p.reorder_level,p.units_in_stock 
from products p 
where p.units_in_stock <= p.reorder_level;
--Ejercicio 6--
--¿A dónde va nuestra orden más voluminosa?--
select o.freight, o.ship_country 
from orders o 
order by o.freight desc limit 1;
--Ejercicio 7--
--Nueva columna para clientes que nos diga si es bueno, regular o malo--
select t.company_name, t.customer_value,
case 
	when t.customer_value >66000 then 'bueno'
	when t.customer_value <=66000 and t.customer_value > 33000 then 'regular'
	when t.customer_value <=33000 then 'malo'
end tipo_cliente
from(
	select c.company_name, sum(od.quantity*od.unit_price) as customer_value
	from order_details od
	join orders o on od.order_id = o.order_id 
	join customers c on o.customer_id = c.customer_id
	group by c.company_name
) t
order by customer_value desc;
--Ejercicio 8--
--¿Qué trabajadores trabajan durante fiestas de navidad?--
select distinct e.first_name, e.last_name, o.order_date 
from employees e join orders o on e.employee_id = o.employee_id 
where extract('month' from o.order_date)=12 and extract('day' from o.order_date) in (24,25);
--Ejercicio 9--
--¿Qué productos se mandan durante navidad?--
select o.order_id, o.shipped_date 
from orders o 
where extract('month' from o.order_date)=12 and extract('day' from o.order_date) in (24,25);
--Ejercicio 10--
--País que recibe mayor volumen de producto--
select sum(o.freight) as "Total Freigth", c.country 
from orders o join customers c on o.customer_id =c.customer_id 
group by c.country order by "Total Freigth" desc limit 1;