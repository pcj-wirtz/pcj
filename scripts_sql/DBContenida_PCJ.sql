use master
go

--a uno se activan opciones avanzadas 
exec sp_configure 'show advanced options',1
go

--activamos la caracteristica
exec sp_configure 'contained database authentication',1
go

--actualizamos de nuevo 
reconfigure
go

--asta aqui preparamos el entorno para lo que vamos a ejecutar

drop database if exists contenida_pcj
go


-- con el parametro containment=partial creamos la base de datos en modo contenida
create database contenida_pcj
containment=partial
go


--una vez creada la activamos 
use contenida_pcj
go

--creo un usuario juan asociado esquema dbo
drop user if exists juan 
go

create user juan
	with password='abcd1234.',
	default_schema=[dbo]
go


--añadimos al usuario juan al rol dbo_owner
--en desuso 
exec sp_addrolemember 'db_owner' ,'juan'
go

--forma nueva 
alter role db_owner
add member juan
go

--damos permiso grant para que juan se pueda conectar
grant connect to juan 
go

--additional database parametros en opciones de conecxion  colocamos
--database=contenida_pcj

--desde juan pruebo a crear una tabla 

create table [dbo].tablacontenida_pcj (
	codigo nchar (10) null,
	nombre nchar (10) null
) on [primary]
go

