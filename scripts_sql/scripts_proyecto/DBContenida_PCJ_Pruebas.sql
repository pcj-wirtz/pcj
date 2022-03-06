use master
go

--con el numero 1 se activan opciones avanzadas del procedimiento almacenado 
exec sp_configure 'show advanced options',1
go

--activamos la caracteristica de autentificacion de base de datos contenida
exec sp_configure 'contained database authentication',1
go

--actualizamos de nuevo la configuracionaplicada
reconfigure
go

--hasta aqui preparamos el entorno para lo que vamos a ejecutar

--controlamos la existencia de la base de datos
drop database if exists contenida_pcj
go


-- con el parametro containment=partial creamos la base de datos en modo contenida
create database contenida_pcj
containment=partial
go


--una vez creada la activamos 
use contenida_pcj
go

--creo un usuario jair asociado esquema dbo
--si existe lo borro
drop user if exists jair 
go

--lo creo con password
create user jair
	with password='abcd1234.',
	default_schema=[dbo]
go


--añadimos al usuario jair al rol dbo_owner
alter role db_owner add member jair
go

--damos permiso grant para que jair se pueda conectar
grant connect to jair 
go

--tenemos que colocar unos  parametros adicionales en las opciones de conecxion  colocamos
--database=contenida_pcj

--desde jair pruebo a crear una tabla para comprobar que tengo permisos 
create table [dbo].tablacontenida_pcj (
	codigo nchar (10) null,
	nombre nchar (10) null
) on [primary]
go

