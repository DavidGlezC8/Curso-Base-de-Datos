--David Emmanuel Gonz�lez C�zares 198582--
--Base de Datos--
--Tarea 2--
--Tabla superh�roes--

create table marv_heroes_mail(
	id_marv_heroes_mail numeric(4) constraint pk_marv_heroes_mail primary key,
	nombres varchar (500) not null,
	mail varchar (500) not null
);
create sequence marv_heroes_mail_id_marv_heroes_mail_seq start 1 increment 1;
alter table marv_heroes_mail alter column id_marv_heroes_mail set default nextval('marv_heroes_mail_id_marv_heroes_mail_seq');

--para poder crearla le vamos a pedir a la funcion que por cada nombre y mail se forme un "usuario" dentro de la tabla (o sea una l�ena)
--Para hacer esto, simplemente le inidcamos que lo inserte dentro de la tabla que creamos en la parte de arriba
INSERT INTO marv_heroes_mail
(nombres, mail)
VALUES ('Wanda Maxinoff', 'wanda.maximoff@avengers.org'),
('Pietro Maxinoff', 'pietro@mail.sokovia.ru'),
('Erik Lensherr', 'fuck_you_charles@brotherhood.of.evil.mutants.space'),
('Charles Xavier', 'i.am.secretely.filled.with.hubris@xavier-school-4-gifted-youngste.'),
('Steve Rogers', 'americas_ass@anti_avengers'),
('The Vision', 'vis@westview.sword.gov'),
('Clint Barton', 'bul@lse.ye'),
('Natasja Romanov', 'blackwidow@kgb.ru'),
('Thor', 'god_of_thunder-^_^@royalty.asgard.gov'),
('Logan', 'wolverine@cyclops_is_a_jerk.com'),
('Ororo Monroe', 'ororo@weather.co'),
('Scott Summers', 'o@x'),
('Nathan Summers', 'cable@xfact.or'),
('Groot', 'iamgroot@asgardiansofthegalaxyledbythor.quillsux'),
('Nebula', 'idonthaveelektras@complex.thanos'),
('Gamora', 'thefiercestwomaninthegalaxy@thanos.'),
('Rocket', 'shhhhhhhh@darknet.ru');


--query para mails inv�lidos--
--Busca caract�res inv�lidos como %, #, etc. o caract�res en �rdenes inv�lidos, como "@.", etc.--
select m.nombres ,m.mail
from marv_heroes_mail m
where m.mail like '%.' or m.mail not like '%@%.%' or m.mail like '%^%' or m.mail like '%_%' or m.mail like '%.' or m.mail like '%@'
or m.mail like '%-%' or m.mail like '@%' or m.mail like '%@%0%' or m.mail like '%@%1%' or m.mail like '%@%2%' or m.mail like '%@%3%' 
or m.mail like '%@%4%' or m.mail like '%@%5%' or m.mail like '%@%6%' or m.mail like '%@%7%' or m.mail like '%@%8%' or m.mail like '%@%9%'
or m.mail like '%+%' or m.mail like '%*%' or m.mail like '%/%' or m.mail like '%(%' or m.mail like '%{%' or m.mail like '%[%' 
or m.mail like '%\%' or m.mail like '%)%' or m.mail like '%}%' or m.mail like '%]%' or m.mail like '%&%' or m.mail like '%$%' 
or m.mail like '%#%' or m.mail like '%"%' or m.mail like '%!%' or m.mail like '%?%' or m.mail like '%�%' or m.mail like '%�%' ;