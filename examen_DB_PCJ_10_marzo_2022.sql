use master 
go

drop database if exists DB_PCJ_10_marzo
go



CREATE DATABASE DB_PCJ_10_marzo ON PRIMARY
( NAME = N'DB_PCJ_10_marzo', FILENAME = N'C:\Data\DB_PCJ_10_marzo_principal.mdf' , SIZE = 15360KB , MAXSIZE = UNLIMITED,
FILEGROWTH = 0)
LOG ON 
( NAME = N'DB_PCJ_10_marzo_log', FILENAME =
N'C:\Data\DB_PCJ_10_marzo_log.ldf' , SIZE = 10176KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO



use  DB_PCJ_10_marzo
go


drop table table_pcj_10_marzo
go


--copiar tabla 
select * 
into table_pcj_10_marzo 
from AdventureWorks2017.Sales.SalesOrderHeader
go

select * from table_pcj_10_marzo
go

--para crar la particion primero añadimos los file groups i los file 

--añadimos los file group
-- CREATE FILEGROUPS para las particiones 
ALTER DATABASE DB_PCJ_10_marzo ADD FILEGROUP [FG_Archivo] 
GO 
ALTER DATABASE DB_PCJ_10_marzo ADD FILEGROUP [FG_2011] 
GO 
ALTER DATABASE DB_PCJ_10_marzo ADD FILEGROUP [FG_2012] 
GO 
ALTER DATABASE DB_PCJ_10_marzo ADD FILEGROUP [FG_2013]
GO

select * from sys.filegroups
GO

-- -- CREATE FILES

ALTER DATABASE DB_PCJ_10_marzo ADD FILE ( NAME = 'Altas_Archivo', FILENAME = 'c:\DATA\Altas_Archivo.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_Archivo] 
GO
ALTER DATABASE DB_PCJ_10_marzo ADD FILE ( NAME = 'altas_2011', FILENAME = 'c:\DATA\altas_2011.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_2011] 
GO
ALTER DATABASE DB_PCJ_10_marzo ADD FILE ( NAME = 'altas_2012', FILENAME = 'c:\DATA\altas_2012.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_2012] 
GO
ALTER DATABASE DB_PCJ_10_marzo ADD FILE ( NAME = 'altas_2013', FILENAME = 'c:\DATA\altas_2013.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_2013] 
GO

select * from sys.database_files
GO

drop PARTITION FUNCTION FN_altas_fecha
go

CREATE PARTITION FUNCTION FN_altas_fecha (datetime) 
AS RANGE RIGHT 
	FOR VALUES ('2011-01-01','2012-01-01','2013-01-01')
GO


CREATE PARTITION SCHEME altas_fecha 
AS PARTITION FN_altas_fecha 
	TO (FG_Archivo,FG_2011,FG_2012,FG_2013) 
GO

--anadir tabla al esquema de particiones
CREATE CLUSTERED INDEX nombreIndex
        ON table_pcj_10_marzo
        (
            OrderDate asc --(normalmentePK)
        )
        ON altas_fecha(OrderDate)
go



SELECT *,$Partition.FN_altas_fecha(OrderDate) AS Partition
FROM table_pcj_10_marzo
GO

-- partition function
select name, create_date, value from sys.partition_functions f 
inner join sys.partition_range_values rv 
on f.function_id=rv.function_id 
where f.name = 'FN_altas_fecha'
gO

--name				create_date					value
--FN_altas_fecha	2022-03-10 18:44:37.500		2011-01-01 00:00:00.000
--FN_altas_fecha	2022-03-10 18:44:37.500		2012-01-01 00:00:00.000
--FN_altas_fecha	2022-03-10 18:44:37.500		2013-01-01 00:00:00.000



select p.partition_number, p.rows from sys.partitions p 
inner join sys.tables t 
on p.object_id=t.object_id and t.name = 'table_pcj_10_marzo' 
GO


--partition_number	rows
--1					0
--2					1607
--3					3915
--4					25943





DECLARE @TableName NVARCHAR(200) = N'table_pcj_10_marzo' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO


--object	p#	filegroup	rows	pages	comparison	value	first_page
--dbo.table_pcj_10_marzo	1	FG_Archivo	0	0	less than	2011-01-01 00:00:00.000	0:0
--dbo.table_pcj_10_marzo	2	FG_2011	1607	57	less than	2012-01-01 00:00:00.000	4:80
--dbo.table_pcj_10_marzo	3	FG_2012	0	0	less than	2013-01-01 00:00:00.000	0:0
--dbo.table_pcj_10_marzo	4	FG_2013	6270	185	less than	2013-09-01 00:00:00.000	6:688
--dbo.table_pcj_10_marzo	5	partir_2013	19673	521	less than	NULL	7:8




--siguiente fase--
-- PARTITIONS OPERATIONS

-- SPLIT = partir algo 

--añadimos el filegroup vacio que  para que split  use la particion 

--para split
ALTER DATABASE DB_pcj_10_marzo ADD FILEGROUP partir_2013
go

ALTER DATABASE DB_pcj_10_marzo ADD FILE (NAME = N'partir_2013',FILENAME = N'C:\DATA\DataFilepartir_2013.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP partir_2013
go



alter partition SCHEME altas_fecha next used partir_2013
go




--alteramos la particion en modo split partiendola desde el rango '2013-01-01' y creando una 4 particion
ALTER PARTITION FUNCTION FN_altas_fecha() 
	SPLIT RANGE ('2013-01-09'); 
GO


----------
SELECT groupname
FROM sys.sysfilegroups
go

--groupname
--PRIMARY
--FG_Archivo
--FG_2011
--FG_2012
--FG_2013
--partir_2013



DECLARE @TableName NVARCHAR(200) = N'table_pcj_10_marzo' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

--object	p#	filegroup	rows	pages	comparison	value	first_page
--dbo.table_pcj_10_marzo	1	FG_Archivo	0	0	less than	2011-01-01 00:00:00.000	0:0
--dbo.table_pcj_10_marzo	2	FG_2011	1607	57	less than	2012-01-01 00:00:00.000	4:80
--dbo.table_pcj_10_marzo	3	FG_2012	3915	113	less than	2013-01-01 00:00:00.000	5:144
--dbo.table_pcj_10_marzo	4	FG_2013	6270	185	less than	2013-09-01 00:00:00.000	6:688
--dbo.table_pcj_10_marzo	5	partir_2013	19673	521	less than	NULL	7:8



-- TRUNCATE
-- vamos a indicartle con truncate que borre todas las filas de la tercera particion
TRUNCATE TABLE table_pcj_10_marzo 
	WITH (PARTITIONS (3));
go

--como vemos la tercera particion aparece vacia 

--object	p#	filegroup	rows	pages	comparison	value	first_page
--dbo.table_pcj_10_marzo	1	FG_Archivo	0	0	less than	2011-01-01 00:00:00.000	0:0
--dbo.table_pcj_10_marzo	2	FG_2011	1607	57	less than	2012-01-01 00:00:00.000	4:80
--dbo.table_pcj_10_marzo	3	FG_2012	0	0	less than	2013-01-01 00:00:00.000	0:0
--dbo.table_pcj_10_marzo	4	FG_2013	6270	185	less than	2013-09-01 00:00:00.000	6:688
--dbo.table_pcj_10_marzo	5	partir_2013	19673	521	less than	NULL	7:8


select p.partition_number, p.rows from sys.partitions p 
inner join sys.tables t 
on p.object_id=t.object_id and t.name = 'table_pcj_10_marzo' 
GO

--partition_number	rows
--1	0
--2	1607
--3	0
--4	6270
--5	19673


--parte de usuarios y paswords 

ALTER TABLE table_pcj_10_marzo
ADD NOMBREUSUARIO VARCHAR(50) 
GO

ALTER TABLE table_pcj_10_marzo
ADD PASSWORD VARCHAR(10) 
GO

SELECT * FROM table_pcj_10_marzo
GO

--añadimos tres usuarios 

UPDATE table_pcj_10_marzo
SET NOMBREUSUARIO = 'marta',PASSWORD='marta'
WHERE [SalesOrderID]=43659
GO
UPDATE table_pcj_10_marzo
SET NOMBREUSUARIO = 'jose',PASSWORD='jose'
WHERE [SalesOrderID]=43660
GO
UPDATE table_pcj_10_marzo
SET NOMBREUSUARIO = 'marcos',PASSWORD='marcos'
WHERE [SalesOrderID]=43661
GO



--creamos la vista i el procedimiento almacenado para controlar los usuarios que tienen acceso 
CREATE OR ALTER VIEW view_pcj_10_marzo
AS 
	SELECT * FROM table_pcj_10_marzo
GO

SELECT * FROM view_pcj_10_marzo
GO

CREATE OR ALTER PROC sp_pcj_10_marzo
	@NOMBRE VARCHAR(50), @PASSWORD VARCHAR(10)
AS
IF EXISTS(SELECT *  
			FROM view_pcj_10_marzo
			WHERE NOMBREUSUARIO=@NOMBRE AND PASSWORD=@PASSWORD)
				BEGIN
					UPDATE view_pcj_10_marzo
					SET [PASSWORD]='Abcd1234.'
					WHERE [NOMBREUSUARIO]=@NOMBRE;
					SELECT * FROM view_pcj_10_marzo
				END
		ELSE
			BEGIN
				PRINT 'ACCESO PROHIBIDO'
			END
GO


--cuando ejecutemos el proceso para un usuario determinado le cambiara la contraseña 
--y perdera el acceso 
EXECUTE sp_pcj_10_marzo 'marcos', 'marcos'
GO


SELECT * FROM table_pcj_10_marzo
GO

EXECUTE sp_pcj_10_marzo 'marta', 'marta'
GO


-- ACCESO PROHIBIDO

EXECUTE sp_pcj_10_marzo 'marta', 'marta'
GO

--ACCESO PROHIBIDO

--Completion time: 2022-03-10T19:50:05.7221757+01:00


--vamos a crear una tabla PCJ_departamento 

drop table  PCJ_departamento_10_marzo
go

create table PCJ_departamento_10_marzo
	(   
	DeptID int Primary Key Clustered,  
	DeptName varchar(50),  
	DepCreado integer,
	NumEmpleados integer,
	SysStartTime datetime2 generated always as row start not null,  
	SysEndTime datetime2 generated always as row end not null,  
	period for System_time (SysStartTime,SysEndTime) ) 
	with (System_Versioning = ON (History_Table = dbo.PCJ_departamento_10_marzo_historico)
	) 
go


--la tabla de departamento esta vacia 
SELECT * FROM [dbo].PCJ_departamento_10_marzo
GO

--el historico tambien esta vacio
SELECT * FROM PCJ_departamento_10_marzo_historico
GO


--creamos añadimos departamentos 
insert into PCJ_departamento_10_marzo (DeptID,DeptName,DepCreado,NumEmpleados) 
values 
	(1,'desarollo',1,4), 
	(2,'hr',2,7), 
	(3,'seguridad',3,2)
	
GO 

-- (5 rows affected)

SELECT * FROM PCJ_departamento_10_marzo
GO

--DeptID	DeptName	DepCreado	NumEmpleados	SysStartTime	SysEndTime
--1	desarollo	1	4	2022-03-10 19:21:57.9053394	9999-12-31 23:59:59.9999999
--2	hr	2	7	2022-03-10 19:21:57.9053394	9999-12-31 23:59:59.9999999
--3	seguridad	3	2	2022-03-10 19:21:57.9053394	9999-12-31 23:59:59.9999999

--el historico sigue vacio lla que no hay cambios desde la primera insercion 
SELECT * FROM PCJ_departamento_10_marzo_historico
GO


--actualizamos el numero de empleados en seguridad
update PCJ_departamento_10_marzo 
	set NumEmpleados = 7
	where DeptName = 'seguridad'
GO

SELECT * FROM PCJ_departamento_10_marzo
GO

--DeptID	DeptName	DepCreado	NumEmpleados	SysStartTime	SysEndTime
--1	desarollo	1	4	2022-03-10 19:21:57.9053394	9999-12-31 23:59:59.9999999
--2	hr	2	7	2022-03-10 19:21:57.9053394	9999-12-31 23:59:59.9999999
--3	seguridad	3	7	2022-03-10 19:26:55.7639642	9999-12-31 23:59:59.9999999



--en el historico vemos los empledos nuevos que hemos metid en seguridad
SELECT * FROM PCJ_departamento_10_marzo_historico
GO


--DeptID	DeptName	DepCreado	NumEmpleados	SysStartTime	SysEndTime
--3	seguridad	3	2	2022-03-10 19:21:57.9053394	2022-03-10 19:26:55.7639642



--quitamos un empleado de desarrollo
update PCJ_departamento_10_marzo 
	set NumEmpleados = 3
	where DeptName = 'desarollo'
GO

SELECT * FROM PCJ_departamento_10_marzo
GO

--DeptID	DeptName	DepCreado	NumEmpleados	SysStartTime	SysEndTime
--1	desarollo	1	3	2022-03-10 19:31:43.0799721	9999-12-31 23:59:59.9999999
--2	hr	2	7	2022-03-10 19:21:57.9053394	9999-12-31 23:59:59.9999999
--3	seguridad	3	7	2022-03-10 19:26:55.7639642	9999-12-31 23:59:59.9999999


--vemos que lla tenemos modificados dos departamentos
SELECT * FROM PCJ_departamento_10_marzo_historico
GO


--DeptID	DeptName	DepCreado	NumEmpleados	SysStartTime	SysEndTime
--3	seguridad	3	2	2022-03-10 19:21:57.9053394	2022-03-10 19:26:55.7639642
--1	desarollo	1	4	2022-03-10 19:21:57.9053394	2022-03-10 19:31:43.0799721