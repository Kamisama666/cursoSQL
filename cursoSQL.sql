/* 
 ____                              ____   ___  _     
|  _ \ ___ _ __   __ _ ___  ___   / ___| / _ \| |    
| |_) / _ \ '_ \ / _` / __|/ _ \  \___ \| | | | |    
|  _ <  __/ |_) | (_| \__ \ (_) |  ___) | |_| | |___ 
|_| \_\___| .__/ \__,_|___/\___/  |____/ \__\_\_____|
          |_|                                        

						Kamisama666
						v 1.3 

Todos los ejemplos y explicaciones están basados en la base de datos MySQL (aplicable también a MariaDB).
En otras pueden variar algunas cosas.

Para la realización de la mayoría de los ejemplos se usaran dos bases de datos: jardineria y nba. 
El codigo fuente de ambas se distribuye junto con el curso.


Para ejecutar los archivos de texto con el codigo (como el de las bases de datos que usaremos)deberas 
usar el comando:
source <ruta_archivo>;

Todas las sentencias sql deberan finalizar con el caracter ";".
*/

--! Comandos utiles

show databases; --muestra las bases de datos que tenemos creadas
use <nombre_database> --selecciona una base de datos para trabajar con ella;
show tables; --Muestra las tablas que contiene la base de datos que tenemos seleccionada
describe <nombre_tabla>; --muestra las columnas y su información de una tabla de la base de datos seleccionada


--! Creacion de bases de datos--------------------------------------------------------


--crear base de datos
create database accidentes;

--borrar base de datos
drop database accidentes;


--! Creacion y modificación de tablas-------------------------------------------------------

--Crear tabla de forma normal

--Para crear una tabla usamos la istrucción: create table <nombre_tabla>
--Despues abrimos un parentesis en el que especificamos 
create table atropellados ( 
	nombre varchar(10)  not null,
	 apellidos varchar(20)  not null,
	  equipo varchar(20)  not null
	  );

--Definir una clave primaria
create table atropellados ( 
	nombre varchar(10) primary key not null,
	 apellidos varchar(20)  not null,
	  equipo varchar(20)  not null
	  );
--Otra forma sería:
create table atropellados ( 
	nombre varchar(10), 
	 apellidos varchar(20)  not null,
	  equipo varchar(20)  not null,
	  primary key (nombre)
	  );

--para crear un campo referenciado lo hacemos asi:

create table atropellados ( 
	nombre varchar(10)  not null,
	 apellidos varchar(20)  not null,
	  equipo varchar(20) references equipos(nombre) not null, --la estructura es: tabla(columna_referenciada)
	  primary key (nombre)
	  );

--tambien se puede crear una referencia de esta forma:

create table atropellados ( 
	nombre varchar(10)  not null,
	 apellidos varchar(20)  not null,
	  equipo varchar(20)  not null,
	  primary key (nombre),
	  foreign key (equipo) references equipos(nombre)
	  );

-- A la hora de hacer referencias podemos asignar un nombre a esta referencias para despues modificarla o eliminarla facimente

create table atropellados ( 
	nombre varchar(10)  not null,
	 apellidos varchar(20)  not null,
	  equipo varchar(20)  not null,
	  primary key (nombre),
	  constraint ref_equipo foreign key (equipo) references equipos(nombre)
	  );

-- Si no recordamos el nombre de la referencia o no le hemos asignado uno (por lo que se habrá asignado uno automaticamente) podemos
--averiguar su nombre mirando los comandos con los que se creo la tabla. 

show create table atropellados;

--La eliminacion de la referencia se vera mas adelante

--Por ultimo, al crear la tabla podemos definir el motor de almacenamiento. Este determina el modo en que la base de datos trabaja con 
--la tabla. POr defecto el motor es "myIsam" que es rapido pero no tiene integridad referencial. El que sí lo tiene es "innodb".
--Para especificar el motor se pone la opcion "engine":

CREATE TABLE Empleados_backup (
  CodigoEmpleado integer primary key NOT NULL,
  Nombre varchar(50) NOT NULL;
  foreign key(nombre) references atropellados(nombre) 
  ) engine=innodb;


--crear tabla copiando las columnas y el contenido de otra tabla a través de un select (también podriamos usar filtros y todo lo de las consultas)

Create table Empleados_backup select * from Empleados;
--Al crearla así no se copian las referencias ni las restricciones o las claves primarias por lo que hay que crearlas a mano con Alter

--También se pueden coger sólo algunas columnas

Create table Empleados_backup select Nombre,Apellido1 from Empleados;


--! Modificación de tablas

--Añadir una columna
alter table atropellados add codigo int primary key first; --con firs le decimos que la coloque al principio. S
alter table atropellados add codigo int primary key after nombre; -- con after <nombre columna> le decimos que lo ponga despues de esa columna
alter table libros add constraint ref_libroautor FOREIGN KEY (`escritor`) REFERENCES `autores` (`idautor`); --añadimos una clave foranea

--Modificar la definicion de una columna que ya existe
alter table atropellados modify equipo varchar(10);

--Eliminamos una columna de una tabla
alter table atropellados drop column equipo;

--Eliminamos una referencia
alter table libros drop foreign key ref_libroautor;

--Renombramos una tabla
rename table atropellados to atro;

--Borramos una tabla
drop table atro;



--! Restricciones
/*
Las restricciones nos permiten determinar lo que ocurre cuando con los datos de un campo cuando se modifican los
datos de un campo al que hacemos referencia. Existen dos ocasiones que podemos controla:
	-On update: cuando se modifican los datos
	-On delete: cuando se borran  los datos
Y tres cosas que podemos hacer cuando ocurre estas acciones:
	-No action: impedimos que se borre o se modifique. Para poder hacer deberemos eliminar o modificar la referencia
	-Cascade: se aplica la misma accion que a la tabla padre. Es decir, si borramos un campo tambien se borra el campo que 
	lo esta referenciando
	-set null: se deja a NULL los campos que hacen la referencia
	*/

--Ejemplo: cuando se modifiquen campos en la tabla padre que tambien lo hagan en la tabla hijo y cuando se borren 
--que se ponga a NULL en la hijo

	CREATE TABLE Empleados_backup (
  CodigoEmpleado integer primary key NOT NULL,
  Nombre varchar(50) NOT NULL;
  foreign key(nombre) references atropellados(nombre) on update cascade on delete set null
) engine=innodb;



--! Modificación del contenido de tablas------------------------------------------------


--Insertar datos en una tabla
insert into atropellados values ('Sergio','Tarde','DAM'); --como no especificamos columnas hay que poner datos para todas las columnas
insert into atropellados (nombre,apellidos,equipo) values ('Falete','Chuleton','Pata Negra'); --también podemos especificar las columnas en las que queremos introducir los datos

--Podemos insertar varias filas al mismo tiempo separandolo por comas
insert into autores values (2,"Lope de vega","1652-07-21"),(3,"Thomas Mann","1780-02-21");cd

--Insertar datos de otras tablas (para poder hacerlo deberan tener el mismo numero de columnas y ser del mismo tipo, el nombre da igual)
insert into Empleados_backup select * from Empleados; 

--Aunque podemos cojer solo las columnas que nos interesen y no tener que tener todas las columnas por duplicado
insert into Empleados_backup select CodigoEmpleado,Nombre from Empleados;
insert into Empleados_backup select CodigoEmpleado,Nombre from Empleados where Nombre='Mariko';

--Borrar datos de una tabla
delete from Empleados_backup where CodigoEmpleado=31 or CodigoEmpleado=21; --Se puede (y generalmente se debe) usar filtros para seleccionar los datos que queremos borrar 
delete from Empleados_backup; --Si no lo hacemos borrararemos todos los datos de la tabla
--Usamos un filtro y la orden "IN" para decir que borre los empleados cuyo codigo este en (IN) el codigo de representante de algun cliente
delete from Empleados_backup where CodigoEmpleado in (select CodigoEmpleadoRepVentas from Clientes);

--Cambiar los datos de una tabla
update Empleados_backup set Nombre='Marika' where Nombre='Mariko'; --Decimos que donde (where) la colummna Nombre sea igual a 'Mariko' lo cambiamos por el valor 'Marika'


--! Consultas -------------------------------------------------------------

/*Las consultas nos permiten recuperar los datos guardados en la base de datos. Su estructura básica es:

 select <columnas> from <tabla>;

En columnas ponemos el nombre de las columnas cuyos datos queremos recuperar y en tabla el nombre de la tabla a la
que pertenecen;

*/

--Ejemplo básico

select nombre from jugadores; --con esta recuperamos todos los datos de la columna nombre de la tabla jugadores
select * from jugadores; --mediante el caracter "*" indicamos que recupere los datos de todas las columnas

--Con distinct cogemos tan solo aquellos valores que no se repitan. Es decir, si un valor aparece
--varias veces solo saldra una
select distinct Nombre_equipo from jugadores;
--Hay que tener cuidado por que si seleccionamos varias columnas y solo aparecen campos repetidos
--en una de ellas no las juntara. Por ejemplo, en esta no lo haría ya que los nombres no se repiten:
select distinct Nombre,Nombre_equipo from jugadores;

--! Filtros
/*
Los filtros nos permiten filstrar el resultado de una consulta en funcion de las condiciones que especifiquemos
Parra ello usamos el comando "where" de esta forma

  select <columnas> from <tabla> where <condicion>;

*/

--ejemplos:

select Nombre from jugadores where Peso > 60; --Esto selecciona el nombre de los jugadores con un peso mayor de 60
select nombre from equipos where ciudad = "Philadelphia"; --Con esta cogemos el nombre del equipo cuya ciudad sea Philadelphia
select Nombre from jugadores where Peso > 60 AND procedencia = "Spain"; --esta ha de cumplir dos condiciones, que pese mas de 60
--y sea de españa
select Nombre from jugadores where Peso > 60 OR procedencia = "Spain"; --La diferencia con el anterior es que solo necesita que
--se cumple una de las condiciones
select Nombre from jugadores where not Peso > 60; --con esto hacemos que recojan los datos que no cumplan la condicion que 
--especifiquemos. Es decir, en este caso cogera aquellos que pesen menos de 60


--Filtro IN
--con IN comprobamos si algo coincide con cualquiera de una serie de valores. Si coincide con alguno de ellos recogerá ese dato

select Nombre from jugadores where Nombre_equipo in (Rockets,Spurs,Suns); --Esta consulta cogera los jugadores que pertenezcan a
--alguno de los equipos especificados entre parentesis


--Filtros Between
--Con ellos especifiquamos que un valor se encuentre comprendido entre dos valores

select nombre from jugadores where peso between 100 and 200;

--Filtros IS / IS NOT
--Se utilizan para comprobar si un valor es o no es nulo

select nombre from jugadores where procedencia is null; --aqui congemos los que tengan el campo procedencia nulo
select nombre from jugadores where procedencia is null; -- y con esta justo lo contrar

--Consultas resumen: sum max min count avg

select max(codigo) from jugadores; --Devuelve el codigo de jugador más alto
select min(codigo) from jugadores; --Devuelve el codigo de jugadore más bajo
select count(Nombre) from equipos; /*Cuenta el numero de jugadores (de todos). Es más util con filtros para que
nos cuente sólo los jugadores que cumplan un criterio- Ejemplo: */
select count(Nombre) from equipos where codigo>30;

/* Al usar consultas resumen el dato que nos devuelve "resume" todos los campos agrupandolos sin seguir ningún criterio
Para evitar esto podemos usar <group by>. De esta forma agrupamos los datos según el criterio que queramos.
Por ejemplo, ahora queremos que nos muestre la suma de los puntos que ha marcado cada equipo: */
select equipo_local,sum(puntos_local) from partidos group by equipo_local;



--! LIMIT 
--con limit podemos limitar el número de filas que nos devuelve la consulta

--Si solo le pasamos un numero nos cogerá tantas filas como ese número empezando por la primera
select * from jugadores limit 5; --Esta nos devolverá solo las 5 primeras filas

--Si le pasamos dos numeros el primero es a partir de que fila empieza a coger y el segundo el numero de filas que ha de coger
select * from jugadores limit 5,10; --Este nos cogerá 10 filas empezando por la 6 (empieza por el numero siguiente al que la digamos)



--! PATRONES

/* Los patrones nos permiten filtrar usando caracteres especiales que pueden ser sustituidos por otros
Tenemos "%" que puede ser sustituido por cualquier caracter y "_" que se sustituye por un solo caracter.
Para usar patrones filtramos usando "like"
*/
--Este selecciona los jugadores cuyo nombre empieze por "Mar" seguido por cualquier numero de caracters. Por ejemplo: "Marco","María",etc.
select * from jugadores where Nombre like 'Mar%'; 
--Este solo seleccionara los que empiezen por "Mart" y un solo caracter cualquiera mas. Ejemplo "Marta"
select * from jugadores where Nombre like 'Mart_';


--! ORDENAR

/* Podemos ordenar la salida de una consulta usando un campo como criterio y eligiendo un orden 
con el ultimo arriba o descendente (ASC) o con el primero arriba o descendente (DESC)
Si usamos un campo de texto lo ordenara según orden alfabético (que no analfabético)
*/

select * from jugadores order by codigo desc --Ordena a los jugadores segun su codigo empezando el mas alto y descendiendo hasta el mas bajo
select * from jugadores order by nombre asc  --Ordena a los jugadores por su nombre empezando por el primero arriba (los que empiezen por A)
select * from jugadores order by codigo desc,nombre asc; --Se pueden combinar varios criterios y se aplicara primero el de mas a la izquierda

/* 
Es interesante observar lo que ocurre al combinar el orden by y el limit. Dado que el que primero se ejecua es el de mas 
a la izquierda primera se ordenaran y, de el resultado de esa ordenacion, se nos devolvera el numero de lineas que le indiquemos
*/
--En este caso nos lo ordenara con el ultimo (el mayor) codigo arriba (el 613) y despues nos cogera los 10 siguientes (hasta el 604)
select * from jugadores order by codigo desc limit 10;



--! HAVING

--Having se usa para filtrar (exactamente como el while) cuando dentro del filtro usamos una sentencia resumen


--Aqui seleccionamos el nombre de los equipos y la media del peso de los jugadores agrupados por nombre de equipo, pero solo de aquellos
--equipos cuya media de peso sea mayor que 120
select Nombre_equipo,avg(peso) from jugadores group by Nombre_equipo having avg(peso)>120;

--Observa la diferencia con esta: En esta lo que hace esta es hacer la media del peso de los jugadores cuyo peso es mayor de 120
--Es decir, mientras que la anterior filtraba por la media de los jugadores esta lo hace solo del peso individual de cada uno,
--independientemente de quer luego calcules la media para mostrarla
select Nombre_equipo,avg(peso) from jugadores  where peso>120 group by Nombre_Equipo;




--! EJEMPLO PRACTICO DE REPASO

--En esta consulta queremos coger el nombre y el numero de jugadores españoles de los equipos que tengan un
--solo jugador español



--Para ello filtramos para que la procedencia sea españa y agrupamos por equipo ya que vamos utilizar una sentencia resumen.
--Hasta ahora la consulta que llevamos hecha nos devolveria el numero de jugadores españoles de cada equipo y seria mas o menos esta:
select Nombre_equipo,count(*) from jugadores where procedencia='Spain' group by Nombre_equipo

--Hemos de imaginarnos que lo que hace esta sentencia es devolvernos los jugadores españoles de cada equipo, lo que pasa es que
--para que lo visualizarlo mejor los hemos juntado a todos separandolos por equipos de esta forma:

/* 
	equipo1
			jugador1
			jugador2
	equipo2
			jugador3
	equipo3
			jugador4
			jugador5
*/
--De esta forma lo que hay que hacer es ir contando el numero de jugadores que hay que en cada grupo (equipo) de esta forma

/* 
	equipo1...........2 jugadores
			jugador1
			jugador2
	equipo2...........1 jugador
			jugador3
	equipo3...........2 jugadores
			jugador4
			jugador5
*/
--Para hacerlo usaremos count(*) y como ya hemos agrupado nos contara los que hay dentro de cada equipo. Usaremos having
--ya que estamos usando una consulta resumen en un filtro. Así quedará finalmente:
select Nombre_equipo,count(*) from jugadores where procedencia='Spain' group by Nombre_equipo having count(*)=1;



--! SUBCONSULTAS
/* 
Con ellas podemos filtrar comparando un valor con el resultado de una consulta (la consullta 
anidada). Para simplificar hemos de coger la subconsulta por separado y observar su resultado. 
De esta forma, al realizar la comparacion, no pensaremos que comparamos el valor con una consulta,que es
algo un poco abstracto, sino con el resultado de esa consulta, que algo mucho más simple como
un número o una cadena de texto.
*/

--Para ejemplificarlo haremos una consulta que devuelva el nombre el peso del jugador que pesa mas
--Lo primero que necesitamos es obtener el mayor peso de entre todos los jugadores. Para ello usaremos 
--una simple consulta:
select max(Peso) from jugadores;
--El resultado es 325. Ahora usaremos esta consulta como subconsulta de otra que compare el peso de cada
--jugador y coja a aquel cuyo peso coincida con el peso mayor que hemos obtenido en la subconsulta:

select Nombre,Peso from jugadores where Peso=(select max(Peso) from jugadores);

--Aunque lo expresemos así, hemos dicho que, en nuestra mente, lo que haremos será sustituir la 
--subconsulta por el valor que devuelve, lo cual es mucho mas simple. De esta forma 
--hemos de considerar que lo que estamos haciendo es en realidad esto:
select Nombre,Peso from jugadores where Peso=325;




--Sin embargo, una subconsulta no siempre devolvera un solo valor. Para manejarlo podemos usar "IN" Y "NOT IN" 

--Con esta consulta queremos obtener el nombre de los empleados que no tengan asignado un cliente

--Lo que hace es comprobar cada uno de los codigo de los empleados y asegurarse de que no esta en (not in) los empleados
-- que estan asignados a un cliente
select Nombre from Empleados where CodigoEmpleado not in (select CodigoEmpleadoRepVentas from Clientes);
--En esta cogemos solo los que sí estan en (in) los que tienen un cliente asignado
select Nombre from Empleados where CodigoEmpleado in (select CodigoEmpleadoRepVentas from Clientes);



--Podemos usar ALL y ANY para comparar con todos (ALL) o cualquiera (ANY) de los resultados que devuelva 
--una subconsulta

--Esta devolverá el nombre del jugador mas pesado ya que compara solo devuelve el que tenga un peso mayor 
--o igual al de todos los jugadores
select Nombre from jugadores where peso>= All(select Peso from jugadores);
--Esta devuelve todos los jugadores menos el que pesa menos ya que la condicion es que el jugador tenga 
--mayor peso que cualquir otro
--jugador. Es decir, todos los jugadores tienen al menos otro que pesa menos que ellos excepto uno, 
--el que pesa menos de todos
select Nombre from jugadores where peso>ANY(select Peso from jugadores);



--! Composiciones
/* 
Las composiciones son uniones que nos permite realizar consultas a traves de varias tablas.
Para ello usamos las relaciones que hemos definido previamente en las tablas. Estas las usaremos como puentes 
para pasar de una tabla a otra hasta llegar a la que necesitamos para obtener datos.Existen varios tipos.
*/

--Inner join: este es el join normal. Al unir dos tablas hay que indicarle la relacion que usaremos para 
--hacerlo con el "ON"
--En esta tabla mostramos a los empleados con la oficina en la que trabajan a traves de la relacion 
--Empleados.CodigoOficina=Oficinas.CodigoOficina
select Nombre,Ciudad from Empleados join Oficinas on Empleados.CodigoOficina=Oficinas.CodigoOficina;


--Natural join: funciona igual que el inner pero no hace falta indicarle los campos que conforman la 
--relacion sino que los detecta automaticamente. Para que esto sea posible los dos campos han de llamarse 
--igual.

--Esta consulta hace los mismo que la anterior y funciona dado que en ambas tablas el campo de la relacion
--se llaman igual (CodigoOficina)
select Nombre,Ciudad from Empleados natural join Oficinas;

/*
Outer Join: une tablas en las que haya campos que no tengan relacion. Para explicarlo lo veremos con un 
ejemplo. En la base de datos de jardineria tenemos clientes que tienen asignados representantes de ventas.
Todos los clientes tienen un representante pero no todos los empleados son representantes de un cliente. 
Por lo tanto esta consulta, si la hacemos con un join normal solo nos devolvera los empleados que sean 
representantes. Con el outer join, sim embargo, nos devolverá tanto los que tiene uno asignado como los 
que no. Pero para eso hemos de indicarle que la que queremos que tenga prioridad y, por tanto,nos muestre
 aunque no tenga relacion es la de la derecha (right) ya que es el lado de la tabla de empleados:
*/
select NombreCliente,Nombre from Clientes right outer join Empleados on CodigoEmpleadoRepVentas = CodigoEmpleado;
--Esta consulta nos muestra todos los empleados y sus clientes. Si no tiene ninguno asignado, dado que 
--le hemos dado prioridad a esa tabla, nos mostrara un null en los clientes. Si quisieramos hacerlo al 
--reves usariamos "left outer join".
select NombreCliente,Nombre from Clientes right outer join Empleados on CodigoEmpleadoRepVentas = CodigoEmpleado;
--Esta hara lo mismo que un join normal ya que se conserva la tabla de clientes y se pierde los datos de 
--la de empleados que no tengan relacion con ella.




/* 
Consultas recursivas: en ocasiones hemos de realizar una consulta usando una relacion que enlaza con si misma. Para poder
hacerlo hemos de crear a partir de la tabla origina dos tablas simbolicas que nos permitan referenciarlas por separado.
Para ello referenciaremos a la tabla usando dos alias diferentes que representen a las tablas simbolicas.
*/

--En esta consulta queremos que nos muentre a cada empleado con su jefe. El jefe de cada empleado se representa por el campo
--CodigoJefe que hace referencia a el codigo de otro empleado y que, por lo tanto se encuentra tambien en la tabla empleados
--Para poder hacerlo usaremos el elias "jefe" que representa a la tabla de los jefes y "emp" para sus empleados. La consulta
--queda asi: 
select emp.Nombre as empleado,jefe.Nombre as jefe from Empleados emp join Empleados jefe on emp.CodigoJefe=jefe.CodigoEmpleado;
--                                                           |                      |
--                                                           |                      |
--                                           aqui creamos la tabra emp              |
--                                                                             aqui la tabla jefe




/*
Consultas derivadas: podemos usar una consulta como si fuera una tabla y realizar consultas de ella. 
*/
--Por ejemplo, tomemos el resultado de esta consulta y consideremos que con él hacemos otra tabla llamada 
--tabladerivada
select NombreCliente,Fax from Clientes;
--De esa tabla (es decir, del resultado de la consulta) podemos realizar consultas de forma normal
select Fax as Fax2 from (select NombreCliente,Fax from Clientes) as tabladerivada;
--Al usar tablas derivadas siempre hemos de usar "as" para darle un nombre de forma que podamos refernciarla


--! Ejemplo final
/*
Sacar el nombre de los clientes y el nombre de sus representantes junto con la ciudad de la oficina a la que
perteneceel representante. Además, solo de los clientes que no hayan hecho pago. Veamos la solucion 
paso a paso:
*/

--1.Seleccionamos los campos que vamos a necesitar. Al seleccionar la ciudad especificamos que es de la tabla oficinas ya
--que hay un campo que se llama igual en la tabla clientes. Cogemos los datos de la tabla Empleados. Por lo tanto, sera
--de esta de la que partamos para llegar a los otras tablas
select NombreCliente,Nombre,Oficinas.Ciudad from Clientes join Empleados

--2. Necesitamos obtener el campo Nombre de la tabla empleados asi que usamos un join para llegar a ella
select NombreCliente,Nombre,Oficinas.Ciudad from Clientes join Empleados on CodigoEmpleadoRepVentas=CodigoEmpleado

--3. Ahora necesitamos el campo ciudad de la tabla oficinas. Como ya hemos llegado a la tabla empleados ahora podemos
--llegar a la tabla oficinas a traves de ella por medio de otro join
select NombreCliente,Nombre,Oficinas.Ciudad from Clientes join Empleados on CodigoEmpleadoRepVentas=CodigoEmpleado join Oficinas on Empleados.CodigoOficina=Oficinas.CodigoOficina

--4. Ya solo nos queda usar un filtro para coger solo los clientes que no hayan hecho pagos. Para ello usaremos una 
--subconsulta que nos devuelve el codigo de los clientes que esten en la tabla Pagos. Es decir, de aquellos
--que hayan realizado pagos. Despues solo nos queda filtrar para asegurarnos de que el codigo de los empleados no esta en esa tabla

select NombreCliente,Nombre,Oficinas.Ciudad from Clientes 
	join Empleados on CodigoEmpleadoRepVentas=CodigoEmpleado 
	join Oficinas on Empleados.CodigoOficina=Oficinas.CodigoOficina 
	where Clientes.CodigoCliente not in (select CodigoCliente from Pagos);
