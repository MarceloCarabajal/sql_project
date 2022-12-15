DROP SCHEMA IF EXISTS CARABAJAL_DESAFIOS;
CREATE SCHEMA IF NOT EXISTS CARABAJAL_DESAFIOS;
USE CARABAJAL_DESAFIOS;

-- Creo primero tablas STAGE para poder importar archivo CSV

-- Table: PAIS
 -- drop table IF EXISTS stg_pais;
CREATE TABLE IF NOT EXISTS STG_PAIS (
    id_pais varchar(100),
    nombre_pais varchar(100)
);

-- drop table IF EXISTS PAIS;
CREATE TABLE IF NOT EXISTS PAIS (
    id_pais int not null,
    nombre_pais varchar(100),
    primary key (id_pais)
);

insert into pais select * from stg_pais;

select * from pais;

-- Table: PROVINCIA
-- drop table IF EXISTS stg_provincia;
CREATE TABLE IF NOT EXISTS STG_PROVINCIA (
    id_prov varchar(100),
    nombre_prov varchar(100),
    id_pais varchar(100)
);

-- drop table IF EXISTS provincia;
CREATE TABLE IF NOT EXISTS PROVINCIA (
    id_provincia int not null primary key,
    nombre_prov varchar(100),
    id_pais int not null,
    constraint ´fk_idpais´ foreign key (id_pais) references pais (id_pais)
);

insert into provincia select * from stg_provincia;

select * from provincia;

-- Table: PARTIDO
-- drop table IF EXISTS stg_partido;
CREATE TABLE IF NOT EXISTS STG_PARTIDO (
    id_partido varchar(100),
    nombre_partido varchar(100),
    id_provincia varchar(100)
);

-- drop table IF EXISTS partido;
CREATE TABLE IF NOT EXISTS PARTIDO (
    id_partido int not null,
    nombre_partido varchar(100),
    id_provincia int not null,
    constraint ´pk_idpartido´ primary key(id_partido),
    constraint ´fk_idprov2´ foreign key (id_provincia) references provincia (id_provincia)
);


insert into partido select * from stg_partido;

select * from partido;

-- Table: CLIENTE
-- drop table IF EXISTS stg_cliente;
CREATE TABLE IF NOT EXISTS STG_CLIENTE (
    id_cliente varchar(100),
    nombre_cliente varchar(100),
    telefono_cliente varchar(100),
    email_cliente varchar(100),
    fecha_nacimiento varchar(100),
    id_partido varchar(100)
);

-- drop table IF EXISTS cliente;
CREATE TABLE IF NOT EXISTS CLIENTE (
    id_cliente int NOT NULL,
    nombre_cliente varchar(200) NOT NULL,
    telefono_cliente varchar(30) NOT NULL,
    email_cliente varchar(50) NOT NULL,
    fecha_nacimiento date not null,
    id_partido int not null,
    primary key (id_cliente),
    constraint ´fk_idpartido´ foreign key (id_partido) references partido(id_partido)
);

insert into cliente select * from stg_cliente;

select * from cliente;

-- Table: PROVEEDOR
-- drop table IF EXISTS STG_PROVEEDOR;
CREATE TABLE IF NOT EXISTS STG_PROVEEDOR (
    id_prov varchar(100),
    nombre_prov varchar(100),
    tel_prov varchar(100),
    email_prov varchar(100)
);

-- drop table IF EXISTS proveedor;
CREATE TABLE IF NOT EXISTS PROVEEDOR (
    id_prov int NOT NULL,
    nombre_prov varchar(200) NOT NULL,
    tel_prov int NOT NULL,
    email_prov varchar(200) NOT NULL,
    CONSTRAINT PK_IDPROV PRIMARY KEY (id_prov)
);

insert into PROVEEDOR select * from STG_PROVEEDOR;

select * from proveedor;

-- Table: CATEGORIA
-- drop table IF EXISTS stg_categoria;
CREATE TABLE IF NOT EXISTS STG_CATEGORIA (
    id_categoria varchar(100),
    nombre_cat varchar(100)
);

-- drop table IF EXISTS categoria;
CREATE TABLE IF NOT EXISTS CATEGORIA (
    id_categoria int NOT NULL,
    nombre_cat varchar(100),
    CONSTRAINT PK_IDPEDIDO PRIMARY KEY (id_categoria)
    );

insert into CATEGORIA select * from STG_CATEGORIA;

select * from CATEGORIA;

-- Table: ARTICULO
-- drop table IF EXISTS stg_articulo;
CREATE TABLE IF NOT EXISTS STG_ARTICULO (
    id_art varchar(100),
    nombre_art varchar(100),
    stock varchar(100),
    id_cat varchar(100),
    id_proveedor varchar(100),
    precio_100g varchar (100)
);

-- drop table IF EXISTS articulo;
CREATE TABLE IF NOT EXISTS ARTICULO (
    id_art int NOT NULL,
    nombre_art varchar(100) NOT NULL,
    stock int NOT NULL,
    id_categoria int not null,
    id_proveedor int not null,
    precio_100g int not null,
    CONSTRAINT PK_IDART PRIMARY KEY (id_art),
    CONSTRAINT FK_IDPROVEEDOR FOREIGN KEY (ID_PROVEEDOR) REFERENCES PROVEEDOR(ID_PROV),
    CONSTRAINT FK_IDCAT2 FOREIGN KEY (ID_CATEGORIA) REFERENCES CATEGORIA(ID_CATEGORIA)
);


insert into articulo select * from stg_articulo;
select * from articulo;

-- Table: COMPRA
-- drop table IF EXISTS stg_compra;
CREATE TABLE IF NOT EXISTS STG_COMPRA (
    id_compra varchar(100),
    fecha_compra varchar(100),
    id_cliente varchar(100)
);

-- drop table IF EXISTS compra;
CREATE TABLE IF NOT EXISTS COMPRA (
    id_compra int NOT NULL,
    fecha_compra date NOT NULL,
    id_cliente int NOT NULL,
    CONSTRAINT PK_IDPEDIDO PRIMARY KEY (id_compra),
    CONSTRAINT FK_IDCLIENTE2 FOREIGN KEY (id_cliente) REFERENCES CLIENTE (id_cliente)
);

insert into COMPRA select * from STG_COMPRA;

select * from COMPRA;

-- Table: COMPRA-ARTICULO
-- drop table IF EXISTS stg_compra_articulo;
CREATE TABLE IF NOT EXISTS STG_COMPRA_ARTICULO (
	id_compra_articulo varchar(100),
    id_compra varchar(100),
    id_articulo varchar(100),
    cantidad varchar(100)
);

-- drop table IF EXISTS compra_articulo;
CREATE TABLE IF NOT EXISTS COMPRA_ARTICULO (
	id_compra_articulo int not null primary key,
    id_compra int NOT NULL,
    id_articulo int NOT NULL,
    cantidad int NOT NULL,
    CONSTRAINT FK_IDCOMPRA2 foreign key (id_compra) REFERENCES COMPRA (id_compra),
    CONSTRAINT FK_IDART2 FOREIGN KEY (ID_ARTICULO) REFERENCES ARTICULO (ID_ART)
);

insert into compra_articulo select * from STG_compra_articulo;

select * from compra_articulo;

-- DESAFIO VIEW
-- VIEW 1: muestra todos los clientes y su partido/ciudad
-- drop view if exists VW_CLIENTE_PARTIDO;
create view VW_CLIENTE_PARTIDO
as (
select C.*, P.NOMBRE_PARTIDO as CLIENTE_PARTIDO
from CLIENTE as C join PARTIDO as P
on C.ID_PARTIDO = P.ID_PARTIDO
);

select * from vw_cliente_partido;

-- VIEW 2: mostrar cantidad de ventas por articulo, en este caso art 2
-- drop view if exists VW_VENTAS_ART;
create view VW_VENTAS_ART 
AS(
	select ca.id_articulo,
	COUNT(ca.id_articulo) as VENTAS_POR_ART
	from compra_articulo as ca 
	group by ca.id_articulo
	having ca.id_articulo = 2
);

select * from VW_VENTAS_ART;

-- VIEW 3: mostrar los clientes que realizaron alguna compra en orden ascendente
-- drop view if exists VW_COMPRAS;
create view VW_COMPRAS
AS(   
	SELECT NOMBRE_CLIENTE, C.ID_COMPRA, FECHA_COMPRA
	FROM COMPRA AS C JOIN CLIENTE AS CL
    ON C.ID_CLIENTE = CL.ID_CLIENTE
	ORDER BY NOMBRE_CLIENTE
);

-- VIEW 4: mostrar la categoria donde aparezca "frutos" por frutos secos
-- drop view if exists VW_CATEGORIA_FRUTOS;
create view VW_CATEGORIA_FRUTOS
AS(
	SELECT ca.id_categoria, ca.nombre_cat 
    FROM categoria AS ca
    WHERE ca.nombre_cat like '%frutos%'
);

-- VIEW 5: MOSTRAR QUE PAIS CORRESPONDE AL ID = 3
-- drop view if exists VW_MOSTRAR_ID_DE_PAIS;
CREATE VIEW VW_MOSTRAR_ID_DE_PAIS
AS(
	SELECT P.NOMBRE_PAIS, ID_PAIS
	FROM PAIS AS P
	WHERE ID_PAIS = 3
);

-- VIEW 6: MOSTRAR CANTIDAD DE ARTICULOS QUE HAY DE LA CATEGORIA frutas deshidratadas

drop view if exists VW_CANT_ARTICULOS_CAT;
CREATE VIEW VW_CANT_ARTICULOS_CAT
AS(
   SELECT COUNT(A.ID_CATEGORIA) as cantidad_articulos, A.ID_CATEGORIA
   FROM ARTICULO AS A
   WHERE A.ID_CATEGORIA IN (SELECT ID_CATEGORIA FROM CATEGORIA WHERE NOMBRE_CAT = "frutas deshidratadas")
   GROUP BY A.ID_CATEGORIA

);

-- Desafio 7: Funciones
-- función 1: Detallar la edad de un cliente

-- SELECT timestampdiff(YEAR, fecha_nacimiento, curdate()) as edad
-- from cliente
-- where id_cliente = 1 ;

DROP FUNCTION IF EXISTS FN_EDAD;
DELIMITER $$
CREATE FUNCTION FN_EDAD(P_EDAD INT)
RETURNS INT 
deterministic
BEGIN
DECLARE edad int;
set edad =
			(SELECT timestampdiff(YEAR, fecha_nacimiento, curdate()) as edad
			from cliente
			where id_cliente = p_edad 
            );
return edad;
end $$
DELIMITER ;

SELECT FN_EDAD(3); -- ejemplo cliente con id 3

-- función 2: descuentos 
-- funcion para que te traiga por ejemplo un descuento del 20% del total de la compra
-- el tipo de dato de retorno es un numero que tenga decimales 
-- Aplique (sum(cantidad * precio_100g) para que me traiga el total de la compra con cierto id que le pasamos como parametro
-- y resto este total por el descuento del 20% de esa compra y ahi ya obtengo el total de la compra con el descuento 
-- aplicado.
 drop function IF EXISTS fn_descuento ;
 delimiter $$
 create function fn_descuento (p_desc decimal(6,1) ,
                                 p_id_compra int)
 returns decimal(6,1)
 deterministic 
 begin
 declare descuento decimal(6,1) ;
 set descuento =  
      (select distinct ((sum(cantidad * precio_100g))-(p_desc * (sum(cantidad * precio_100g)))) as descuento
      from compra_articulo as ca
      join articulo as a on ca.id_articulo = a.id_art
      where id_compra = p_id_compra
      group by id_compra
		) 
       ;
   return  descuento;   
 end$$ 
 delimiter ;
 
 select fn_descuento (0.2, 1) as total_compra_descuento;
 
 -- DESAFIO 8 : STORED PROCEDURES
 -- EJEMPLO 1: El primer S.P. debe permitir indicar a través de un parámetro el campo de ordenamiento 
 -- de una tabla y mediante un segundo parámetro, si el orden es descendente o ascendente.
    
drop procedure  if exists SP_ORDENAR ; 
DELIMITER //
CREATE PROCEDURE SP_ORDENAR (INOUT PARAM_ORDER VARCHAR(32),
							 INOUT PARAM_ASC_DESC VARCHAR(32))
BEGIN
-- declare t1 int ;
-- select * from libros order by  autor  desc ;
  SET @t1 =  CONCAT('SELECT * FROM articulo U ORDER BY',' ',PARAM_ORDER,' ',PARAM_ASC_DESC);
  PREPARE param_stmt FROM @t1;
  EXECUTE param_stmt;  
  DEALLOCATE PREPARE param_stmt;
END //
DELIMITER ;
SET @PARAM_ORDER = 'id_art'; 
SET @PARAM_ASC_DESC = 'DESC'; 

CALL SP_ORDENAR (@PARAM_ORDER ,@PARAM_ASC_DESC);

-- EJEMPLO 2: Agregar un PROVEEDOR nuevo con estado (si retorno 0 = existe, no se agrega 
-- si retorna 1 = no existe y lo agrega)

use carabajal_desafios;
DROP PROCEDURE IF EXISTS SP_AGREGAR_PROVEEDOR;
DELIMITER //
CREATE PROCEDURE SP_AGREGAR_PROVEEDOR( 
								 IN p_id_prov int,
								 IN p_nombre_prov varchar(200),
                                 IN p_tel_prov int,
                                 IN p_email_prov varchar(50),
                                 OUT p_notificacion varchar(60),
								 OUT p_estado varchar(60)
)
BEGIN 
	IF (SELECT COUNT(id_prov) from proveedor
			WHERE id_prov = p_id_prov) = 1 THEN
		SELECT CONCAT_WS(" ", "El registro con id:", id_prov, "ya existe"), 
        "No insertado" into p_notificacion, p_estado
        from proveedor 
        WHERE id_prov = p_id_prov;
        -- Se puede hacer que si un registro existe lo elimine e indicas la intruccion debajo del select
        -- y se cambia el mensaje y el estado a eliminado
	ELSE
		INSERT INTO proveedor (id_prov, nombre_prov, tel_prov, email_prov)
        VALUES (p_id_prov, p_nombre_prov, p_tel_prov, p_email_prov);
        SELECT CONCAT_WS(" ", "Se inserto el registro con id:", id_prov), "Insertado" into p_notificacion, p_estado
        from proveedor 
        WHERE id_prov = p_id_prov;
	END IF;
END //
DELIMITER ;

-- SELECT * FROM PROVEEDOR;

SET @p_id_prov = 5;
SET @p_nombre_prov = 'Semillitas2';
SET @p_tel_prov = 1132325252;
SET @p_email_prov = 'semillitas2@semillitas2.com';


CALL SP_AGREGAR_PROVEEDOR(@p_id_prov, @p_nombre_prov, 
@p_tel_prov, @p_email_prov, @p_notificacion, @p_estado);

SELECT @p_notificacion, @p_estado;

-- DESAFÍO 9: TRIGGERS
-- TRIGGER 1: Dar de baja un artículo y almacenarlo en mi tabla
-- log_baja_articulos para poder hacer un seguimiento desde el 
-- área de IT. 


drop table if exists log_baja_articulos;

create table if not exists log_baja_articulos(

id_log int auto_increment, -- pk de la tabla

id_art int,

nombre_art varchar(50),

nombre_de_accion varchar(10), -- iria si es insert, update o delete

nombre_tabla varchar(50), -- provincia, class, departamento, etc

usuario varchar(100), -- quien ejecuta la sentencia DML

fecha_upd_ins_del date, -- momento en que se genero el DML

primary key(id_log)

);

drop trigger if exists trg_log_baja_art;

delimiter //

create trigger trg_log_baja_art after delete on carabajal_desafios.articulo

for each row

begin

insert into log_baja_articulos(id_art, nombre_art, nombre_de_accion, nombre_tabla, usuario, fecha_upd_ins_del)

values(old.id_art, old.nombre_art, 'delete', 'articulo', current_user(), now());

end//

delimiter ;

select * from log_baja_articulos;

-- TRIGGER 2: Dar alta a proveedor nuevo


drop table if exists log_alta_proveedor;

create table if not exists log_alta_proveedor(

id_log int auto_increment, -- pk de la tabla

id_prov int,

nombre_prov varchar(50),

nombre_de_accion varchar(10), -- iria si es insert, update o delete

nombre_tabla varchar(50), -- provincia, class, departamento, etc

usuario varchar(100), -- quien ejecuta la sentencia DML

fecha_upd_ins_del date, -- momento en que se genero el DML

primary key(id_log)

);

drop trigger if exists trg_alta_proveedor;

delimiter //

create trigger trg_alta_proveedor after insert on carabajal_desafios.proveedor

for each row

begin

insert into log_alta_proveedor(id_prov, nombre_prov, nombre_de_accion, nombre_tabla, usuario, fecha_upd_ins_del)

values(new.id_prov, new.nombre_prov, 'insert', 'proveedor', current_user(), now());

end//

delimiter ;

select * from proveedor;
select * from log_alta_proveedor;


-- DESAFIO 11: SUBLENGUAJE DCL
-- USUARIO 1:

-- base que no es visible para nosotros pero en la cual se encuentra la info de los usuarios que fueron creados

use mysql;

-- Tabla en la que podemos ver los permisos que fueron otorgados a cada usuario

select * from db;

-- Tabla en la que podemos ver los usuarios creados

select * from user;

-- Este usuario solo podra leer la infomracion de la base de datos.

drop user if exists 'asistente_lectura'@'localhost';

-- asistente_lectura es el nombre que le damos al usuario, y localhost es el servidor en el que trabaja

create user 'asistente_lectura'@'localhost' identified by 'read1234';

-- con identified by le indicamos la password que va a tener ese usuario en este caso es read1234

-- Es importante que respetes las comillas como estan ya que si pones todo entre comillas tanto el nombre

-- del usuario como el servidor no se te va a crear el usuaurio correctamente.

-- Aqui solo otorgamos poderes de lectura dentro de la base de datos.

grant select on carabajal_desafios.* to 'asistente_lectura'@'localhost';


-- USUARIO 2:
-- Este usuario podra leer, insertar y actualizar informacion de la base de datos.

drop user if exists 'asistente_actualizacion'@'localhost';

create user 'asistente_actualizacion'@'localhost' identified by 'update1234';

grant select, update, insert on carabajal_desafios.* to 'asistente_actualizacion'@'localhost';


-- DESAFIO 12: SUBLENGUAJE TCL

-- PUNTO 1:

use carabajal_desafios;

set @@autocommit = 0;
set sql_safe_updates = 0;
select @@autocommit;

start transaction;
select * from a where id_categoria = 6;

insert into categoria values (6, 'otros');
delete from categoria where id_categoria = 6;


select * from categoria where id_categoria = 6;


-- EJEMPLO 2
use carabajal_desafios;

set @@autocommit = 0;
set sql_safe_updates = 0;
select @@autocommit;

start transaction;
select * from articulo where id_art = 18;

set foreign_key_checks = 0;

delete from articulo where id_art = 18;
-- insert into articulo values (17, 'pasa de uva', 3000, 4, 1, 300);

select * from articulo where id_categoria = 6;


-- rollback;
-- commit;

-- PUNTO 2:
-- El autocommit en cero se traduce en que cualquier modificacion o manipulacion de datos que
-- realice debe pasar por una confirmacion o se debe deshacer lo que haya realizado
-- autocommit es una variable de entorno con valor cero o uno
-- Cada vez que se desconecta la informacion volvemos a reiniciar todas las variables y quedan prendidas devuelta
-- Por esa razon siempre que hacemos inserciones, actualizaciones y eliminaciones siempre las podriamos hacer sin 
-- la necesidad de utilizar ninguna transaccion de control, y eso se da porque gracias a la variable de autocommit
-- cada vez que ejecutabamos cualquier sentencia, la variable de autocommit decia ahi estoy prendido en 1,
-- y estoy diciendo que cada vez que alguien ejecute codigo voy a darlo como confirmacion porque estoy en 1 basicamente
-- Cada vez que desconectamos y conectamos el autocommit vuelve a quedar en su valor inicialmente que es 1.
use carabajal_desafios;
set @@autocommit = 0;

-- Variable que me protege los datos cuando voy a updetear o a eliminar sin las relaciones correspondientes
-- Si la variable esta en cero quiere decir que requiero o un commit o un rollback para que realmente 
-- impactemos la informacion
set sql_safe_updates = 0;
select @@autocommit;

-- start transaction hace la confirmacion de informacion a todo lo que haya utilizado antes de esta linea de codigo
start transaction;
insert into carabajal_desafios.cliente values 
(16, 'Lucia', '2432434434', 'luc@gmail.com', '1990-07-07', 4),
(17, 'Mariano', '3453453457', 'marian@gmail.com', '1992-11-07', 5),
(18, 'Emiliano', '4564564680', 'emi@gmail.com', '1995-12-07', 5),
(19, 'Miguel', '5674342367', 'mig@gmail.com', '1997-03-07', 4);
savepoint sp1;
-- savepoint me genera o permite que nosotros vayamos listando dentro de nuestro script, puntos donde podamos guardar
-- determinada manipulacion de datos (cualquier insert, delete o update) y de ahi para adelante realice una confirmacion
-- o deshaga cualquiera de las anteriores
insert into cliente values 
(20, 'Marta', '3535784326', 'mart@gmail.com', '1991-07-12', 5),
(21, 'Ruperta', '2345345353', 'rup@gmail.com', '1992-09-17', 5),
(22, 'Aldana', '4637289504', 'ald@gmail.com', '1993-10-27', 4),
(23, 'Beatriz', '3820564738', 'beat@gmail.com', '1994-01-05', 4);
savepoint sp2;

select * from cliente;
-- rollback to sp1;
-- rollback;
-- rollback deshace esa operacion o transaccion que nosotros hemos generado previamente
-- commit;
-- commit me confirma cualquier operacion DML(insert, update o delete) que yo haya realizado en mi codigo o script de insercion
-- release savepoint sp1;
-- release savepoint sp1 es una forma de eliminar un savepoint o si aplico commit tambien lo puedo eliminar
use carabajal_desafios;
describe compra_articulo;