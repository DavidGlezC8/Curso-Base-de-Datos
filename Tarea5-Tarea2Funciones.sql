--David Emmanuel González Cázares
--000198582
--Base de Datos
--Tarea 5
--Tarea 2 Funciones

--Datos:
--Arnés 30cm x 21cm x 8cm
--Peso: 0.5 kg por película
--Peso máximo de cilindro: 50 kg

--Nota: Las medidas calculadas son en centímetros y kilogramos

/* Calculamos cuantas películas puede haber por cilindro. Como las
dimensiones del cilindro pueden ser libres (con la restricción
de que cada uno aguanta 50kg), nos conviene maximizar esta medida. */
select 50/0.5 as peliculas_por_cilindro;
--Aguanta hasta 100. Como cada película mide 5,040 cm^3, entonces:
select 5040*100 as volumen_min_cilindro;
	
/*Por lo tanto, el volúmen del cilindro es >= 504,000. Con la fórmula 
 * Área=(pi*r^2*h), se construye el cilindro.
 * 
 * Si ponemos el disco con arnes acostado sobre la base del cilindro, 
 * tal que el rectángulo de 21cm x 30cm quepa sobre la base circular 
 * del cilindro, obtenemos que el radio del cilindro debe de ser la 
 * mitad de la diagonal de dicho rectángulo, la cual, 
 * con el Teorema de Pitágoras.*/
select sqrt(21^2+30^2)/2 as radio_cilindro;

---- Por lo tanto, el radio de la base del cilindro es 18.31 cm aprox.

/* Como el rectángulo de 21cm x 30cm es la "base", la altura de cada 
 * película es de 8cm. Como cada cilindro almacena hasta 100 películas, 
 * la altura es de: */
select 100*8 as altura_cilindro;
/* Así, cada cilindro debe ser de 8m de altura y 18.31cm de radio aprox.
 * Juntando todo, cada cilindro tiene un volúmen de:  */
select pi()*((21^2+30^2)/4)*(50/0.5)*8 as volumen_cilindro;
/* Aproximadamente 842,575.15 cm^3, que cumple con nuestro mínimo de
 * 504,000 cm^3. Aunque halla mucho espacio de sobra, esto se debe a que
 * la base del cilindro es un círculo y no un rectángulo.
 * 
 * Con esto, dado espacio de sobra para los cilindros, cada una de nuestras 
 * tiendas necesita.*/
select i.store_id, ceiling(count(i.inventory_id)/(50/0.5)) as cilindros_por_tienda
from inventory i 
group by store_id;