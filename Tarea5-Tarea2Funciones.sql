--David Emmanuel Gonz�lez C�zares
--000198582
--Base de Datos
--Tarea 5
--Tarea 2 Funciones

--Datos:
--Arn�s 30cm x 21cm x 8cm
--Peso: 0.5 kg por pel�cula
--Peso m�ximo de cilindro: 50 kg

--Nota: Las medidas calculadas son en cent�metros y kilogramos

/* Calculamos cuantas pel�culas puede haber por cilindro. Como las
dimensiones del cilindro pueden ser libres (con la restricci�n
de que cada uno aguanta 50kg), nos conviene maximizar esta medida. */
select 50/0.5 as peliculas_por_cilindro;
--Aguanta hasta 100. Como cada pel�cula mide 5,040 cm^3, entonces:
select 5040*100 as volumen_min_cilindro;
	
/*Por lo tanto, el vol�men del cilindro es >= 504,000. Con la f�rmula 
 * �rea=(pi*r^2*h), se construye el cilindro.
 * 
 * Si ponemos el disco con arnes acostado sobre la base del cilindro, 
 * tal que el rect�ngulo de 21cm x 30cm quepa sobre la base circular 
 * del cilindro, obtenemos que el radio del cilindro debe de ser la 
 * mitad de la diagonal de dicho rect�ngulo, la cual, 
 * con el Teorema de Pit�goras.*/
select sqrt(21^2+30^2)/2 as radio_cilindro;

---- Por lo tanto, el radio de la base del cilindro es 18.31 cm aprox.

/* Como el rect�ngulo de 21cm x 30cm es la "base", la altura de cada 
 * pel�cula es de 8cm. Como cada cilindro almacena hasta 100 pel�culas, 
 * la altura es de: */
select 100*8 as altura_cilindro;
/* As�, cada cilindro debe ser de 8m de altura y 18.31cm de radio aprox.
 * Juntando todo, cada cilindro tiene un vol�men de:  */
select pi()*((21^2+30^2)/4)*(50/0.5)*8 as volumen_cilindro;
/* Aproximadamente 842,575.15 cm^3, que cumple con nuestro m�nimo de
 * 504,000 cm^3. Aunque halla mucho espacio de sobra, esto se debe a que
 * la base del cilindro es un c�rculo y no un rect�ngulo.
 * 
 * Con esto, dado espacio de sobra para los cilindros, cada una de nuestras 
 * tiendas necesita.*/
select i.store_id, ceiling(count(i.inventory_id)/(50/0.5)) as cilindros_por_tienda
from inventory i 
group by store_id;