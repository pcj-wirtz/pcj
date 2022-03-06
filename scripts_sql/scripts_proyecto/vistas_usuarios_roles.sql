

use master
go



use [Workout_Training_PCJ]
go


drop schema if exists HR
go

create schema HR;
go


drop table if exists HR.empleado
go

create table HR.empleado
(
empleadoID char (2),
nombre varchar (50),
apellido varchar (50),
ssn char (9) 
);
go

--importamos un fichero flat files empleados

--desde entorno grafico desde la opcion task import data eligiendo esquema hr al final 


drop view if exists HR.lookupempleado
go

create view HR.lookupempleado
as
select
	empleadoID,nombre,apellido
	from HR.empleado;
go

drop role if exists humanresourcesanalyst
go

create role humanresourcesanalyst;
go

grant select on HR.lookupempleado to humanresourcesanalyst;
go


drop user if exists janedoe
go

create user janedoe without login;
go


alter role humanresourcesanalyst
add member janedoe;
go

execute as user = 'janedoe';
go

print user 

--compruevo la vista y funciona 
select * from HR.lookupempleado;
go

--compruevo la tabla y  no funciona ya que no tengo permisos sobre la tabla
--solo tengo permisos en la vista 
select * from HR.empleado;
go

--Msg 229, Level 14, State 5, Line 77
--Se denegó el permiso SELECT en el objeto 'empleado', base de datos 'testDB', esquema 'HR'.

--Completion time: 2021-12-02T19:31:41.2338205+01:00


--vuelvo a dbo
revert;
go

--compruevo que soy dbo
print user 
go

--stored procedure

drop  procedure HR.insertnewempleado
go

create or alter procedure HR.insertnewempleado
 --parametros de entrada en variable 
	@empleadoID int,
	@nombre varchar (50),
	@apellido varchar (50),
	@ssn char (9)
as
begin
	insert into HR.empleado
	( empleadoID, nombre, apellido, ssn )
	values
	( @empleadoID, @nombre, @apellido, @ssn);
end;
go
	
drop role HumanResourcesRecruiter;
go

CREATE ROLE HumanResourcesRecruiter;
GO 

GRANT EXECUTE ON SCHEMA::[HR] TO HumanResourcesRecruiter;
GO 

drop user JohnSmith
go

CREATE USER JohnSmith WITHOUT LOGIN;
GO 

ALTER ROLE HumanResourcesRecruiter
ADD MEMBER JohnSmith;
GO

EXECUTE AS USER = 'JohnSmith';
GO 



EXEC HR.InsertNewempleado 
      @empleadoID = 4, 
      @nombre = 'Miguel', 
      @apellido = 'Martinez', 
      @SSN = '444';
GO 


print user
go

SELECT * FROM HR.empleado;
GO 

--Msg 229, Level 14, State 5, Line 140
--Se denegó el permiso SELECT en el objeto 'empleado', base de datos 'testDB', esquema 'HR'.

--Completion time: 2021-12-14T21:38:01.4862732+01:00

REVERT;
GO

-- Verifying the insert
SELECT empleadoID, nombre, apellido, SSN 
FROM HR.empleado;
GO 

--empleadoID	nombre	apellido	SSN
--1 			marcos	arias		111      
--2 			maria	gomez		222      
--3 			emilio	perez		333      
--4 			Miguel	Martinez	444      
