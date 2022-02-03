

drop database if exists testDB
go

create database testDB
go

use testDB
go


drop schema if exists HR
go

create schema HR;
go


drop table if exists HR.employee
go

create table HR.employee
(
employeeID char (2),
givenname varchar (50),
surname varchar (50),
ssn char (9) 
);
go

--importamos un fichero flat files employees
--desde entorno grafico desde la opcion task 


drop view if exists HR.lookupemployee
go

create view HR.lookupemployee
as
select
	employeeID,givenname,surname
	from HR.employee;
go

drop role if exists humanresourcesanalyst
go

create role humanresourcesanalyst;
go

grant select on HR.lookupemployee to humanresourcesanalyst;
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
select * from HR.lookupemployee;
go

--compruevo la tabla y  no funciona ya que no tengo permisos desobre la tabla
--solo tengo permisos en la vista 
select * from HR.employee;
go

--Msg 229, Level 14, State 5, Line 77
--Se denegó el permiso SELECT en el objeto 'employee', base de datos 'testDB', esquema 'HR'.

--Completion time: 2021-12-02T19:31:41.2338205+01:00


--vuelvo a dbo
revert;
go

--compruevo que soy dbo
print user 
go

--stored procedure

create or alter procedure HR.insertnewemployee
 --parametros de entrada en variable 
	@employeeID int,
	@givenname varchar (50),
	@surname varchar (50),
	@ssn char (9)
as
begin
	insert into HR.employee
	( employeeID, givenname, surname, ssn )
	values
	( @employeeID, @givenname, @surname, @ssn);
end;
go
	
CREATE ROLE HumanResourcesRecruiter;
GO 

GRANT EXECUTE ON SCHEMA::[HR] TO HumanResourcesRecruiter;
GO 

CREATE USER JohnSmith WITHOUT LOGIN;
GO 

ALTER ROLE HumanResourcesRecruiter
ADD MEMBER JohnSmith;
GO

EXECUTE AS USER = 'JohnSmith';
GO 


EXEC HR.InsertNewEmployee 
      @EmployeeID = 4, 
      @GivenName = 'Miguel', 
      @Surname = 'Martinez', 
      @SSN = '444';
GO 


print user
go

SELECT * FROM HR.Employee;
GO 

--Msg 229, Level 14, State 5, Line 140
--Se denegó el permiso SELECT en el objeto 'employee', base de datos 'testDB', esquema 'HR'.

--Completion time: 2021-12-14T21:38:01.4862732+01:00

REVERT;
GO

-- Verifying the insert
SELECT EmployeeID, GivenName, Surname, SSN 
FROM HR.Employee;
GO 

--EmployeeID	GivenName	Surname	SSN
--1 	luis	arias	111      
--2 	ana	gomez	222      
--3 	juzn	perez	333      
--4 	Miguel	Martinez	444    

