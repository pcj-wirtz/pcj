
--usando un historico sobre una tabbla para ver como estaba la tabla 

-- Temporal Tables 


USE Workout_Training_PCJ
GO

--vamos a crear una tabla para reservar las sesiones de entrenamiento 
create table reserva_sesion 
	(   
	sesiones varchar(20) Primary Key Clustered,  
	num_reservas integer,  
	SysStartTime datetime2 generated always as row start not null,  
	SysEndTime datetime2 generated always as row end not null,  
	period for System_time (SysStartTime,SysEndTime) ) 
	with (System_Versioning = ON (History_Table = dbo.reserva_sesion_historico)
	) 
go

--la tabla de reserva de sesiones esta vacia
SELECT * FROM [dbo].[reserva_sesion]
GO

--el historico tambien esta vacio
SELECT * FROM [dbo].[reserva_sesion_historico]
GO


--creamos reservas
insert into reserva_sesion (sesiones,num_reservas) 
values 
	('sesiones1',2), 
	('sesiones2',1), 
	('sesiones3',4), 
	('sesiones4',2), 
	('sesiones5',6) 
GO 

-- (5 rows affected)

SELECT * FROM [dbo].[reserva_sesion]
GO



--el historico sigue vacio lla que no hay cambios desde la primera insercion 
SELECT * FROM [dbo].[reserva_sesion_historico]
GO

-- sesiones	num_reservas	SysStartTime	SysEndTime


--actualizamos el numero de sesiones 1
update reserva_sesion 
	set num_reservas = 7
	where sesiones = 'sesiones1'
GO

SELECT * FROM [dbo].[reserva_sesion]
GO





--en el historico vemos el estado de sesiones 1 antes de los cambios 
SELECT * FROM [dbo].[reserva_sesion_historico]
GO




SELECT * FROM [dbo].[reserva_sesion]
GO
--actualizamos las reservas de sesiones2
update reserva_sesion 
	set num_reservas = 9 
	where sesiones = 'sesiones2'
GO



--volvemos a ver  los cambios en el historico 
SELECT * FROM [dbo].[reserva_sesion_historico]
GO



update reserva_sesion 
	set num_reservas = 12 
	where sesiones = 'sesiones2' 
go

SELECT * FROM [dbo].[reserva_sesion]
GO



SELECT * FROM [dbo].[reserva_sesion_historico]
GO


--procedemos a borrar las reservas de las sesiones 5
delete from reserva_sesion 
	where sesiones='sesiones5'
GO

SELECT * FROM [dbo].[reserva_sesion]
GO


SELECT * FROM [dbo].[reserva_sesion_historico]
GO





insert into reserva_sesion (sesiones,num_reservas) 
	values ('sesiones6',13)
GO

SELECT * FROM [dbo].[reserva_sesion]
GO




SELECT * FROM [dbo].[reserva_sesion_historico]
GO



delete from reserva_sesion 
	where sesiones='sesiones6'
GO

SELECT * FROM [dbo].[reserva_sesion]
GO





SELECT * FROM [dbo].[reserva_sesion_historico]
GO


-- Con “for system_time all” vemos todas las operaciones realizadas sobre la tabla

select * 
from dbo.reserva_sesion 
for system_time all 
go




select * 
from [dbo].[reserva_sesion_historico]
for system_time all 
go


-- Msg 13544, Level 16, State 2, Line 234
--Temporal FOR SYSTEM_TIME clause can only be used with system-versioned tables. 'Workout_Training_PCJ.dbo.reserva_sesion_historico' is not a system-versioned table.

SELECT * FROM [dbo].[reserva_sesion]
GO



SELECT * FROM [dbo].[reserva_sesion_historico]
GO




-- Con “for system_time as of” vemos el estado de la tabla en un determinado punto en el tiempo.
select * 
from dbo.reserva_sesion 
for system_time as of '2022-03-02 01:56:39.9137628' 
go

-- Con “for system_time from ‘fecha’ to ‘fecha’” vemos los cambios sufridos en la tabla en un rango de fechas
select * 
from reserva_sesion 
for system_time from '2022-03-02 01:56:39.9137628' to '2022-03-02 01:56:39.9137628' 
go

-- Between es similar al anterior pero toma referencia el SysStartTime
select * 
from reserva_sesion 
for system_time between '2022-03-02 01:56:39.9137628' and '2022-03-02 01:56:39.9137628'
GO

-- Con “for system_time contained in” se ven los registros que se introdujeron entre las 10:13 
-- y se cambiaron hasta las 10:21
select * 
from reserva_sesion 
for system_time contained in ('2022-03-02 01:56:39.9137628','2022-03-02 01:56:39.9137628')
GO


SELECT * FROM [dbo].[reserva_sesion]
GO

SELECT * FROM [dbo].[reserva_sesion_historico]
GO
