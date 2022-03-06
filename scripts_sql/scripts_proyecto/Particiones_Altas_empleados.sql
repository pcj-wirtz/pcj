


USE master 
go

-- crear primero carpeta data
--esta parte no seria necesaria si lla la tenemos creada anteriormente 

/*
CREATE DATABASE Workout_Training_PCJ ON PRIMARY
( NAME = N'Workout_Training_PCJ', FILENAME = N'C:\Data\Workout_Training_PCJ_principal.mdf' , SIZE = 15360KB , MAXSIZE = UNLIMITED,
FILEGROWTH = 0)
LOG ON 
( NAME = N'Workout_Training_PCJ_log', FILENAME =
N'C:\Data\Workout_Training_PCJ_log.ldf' , SIZE = 10176KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
*/


USE Workout_Training_PCJ
GO

-- CREATE FILEGROUPS para las particiones 
ALTER DATABASE Workout_Training_PCJ ADD FILEGROUP [FG_Archivo] 
GO 
ALTER DATABASE Workout_Training_PCJ ADD FILEGROUP [FG_2016] 
GO 
ALTER DATABASE Workout_Training_PCJ ADD FILEGROUP [FG_2017] 
GO 
ALTER DATABASE Workout_Training_PCJ ADD FILEGROUP [FG_2018]
GO

select * from sys.filegroups
GO

-- -- CREATE FILES

ALTER DATABASE Workout_Training_PCJ ADD FILE ( NAME = 'Altas_Archivo', FILENAME = 'c:\DATA\Altas_Archivo.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_Archivo] 
GO
ALTER DATABASE Workout_Training_PCJ ADD FILE ( NAME = 'altas_2016', FILENAME = 'c:\DATA\altas_2016.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_2016] 
GO
ALTER DATABASE Workout_Training_PCJ ADD FILE ( NAME = 'altas_2017', FILENAME = 'c:\DATA\altas_2017.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_2017] 
GO
ALTER DATABASE Workout_Training_PCJ ADD FILE ( NAME = 'altas_2018', FILENAME = 'c:\DATA\altas_2018.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_2018] 
GO

select * from sys.database_files
GO

--continuamos desde aqui-----------------------

-- PARTITION FUNCTION
-- BOUNDARIES (LIMITES)

CREATE PARTITION FUNCTION FN_altas_fecha (datetime) 
AS RANGE RIGHT 
	FOR VALUES ('2016-01-01','2017-01-01')
GO

-- PARTITION SCHEME

CREATE PARTITION SCHEME altas_fecha 
AS PARTITION FN_altas_fecha 
	TO (FG_Archivo,FG_2016,FG_2017,FG_2018) 
GO

-- Se ha creado correctamente el esquema de partición 'altas_fecha'. 'FG_2018' 
-- tiene la marca de grupo de archivos usado a continuación en el esquema de partición 'altas_fecha'.


DROP TABLE IF EXISTS alta_empleados
GO

--vamos a crear una tabla donde vamos a registrar a los empleados que no son monitores
CREATE TABLE alta_empleados
	( id_alta int identity (1,1), 
	nombre varchar(20), 
	apellido varchar (20),
	puesto varchar (100),
	fecha_alta datetime ) 
	ON altas_fecha -- partition scheme
		(fecha_alta) -- the column to apply the function within the scheme
GO





-- SSMS TABLE PROPERTIES PARTITIONS

INSERT INTO alta_empleados 
	Values ('marcos','Ruiz','dietista','2015-01-01'), 
			('miriam','García','limpiadora','2015-05-05'), 
			('romeo','Sanchez','secretario','2015-08-11')
Go


----------------
-- METADATA INFORMATION

SELECT *,$Partition.FN_altas_fecha(fecha_alta) AS Partition
FROM alta_empleados
GO

--1	marcos	Ruiz	dietista	2015-01-01 00:00:00.000	1
--2	miriam	García	limpiadora	2015-05-05 00:00:00.000	1
--3	romeo	Sanchez	secretario	2015-11-08 00:00:00.000	1


-- partition function
select name, create_date, value from sys.partition_functions f 
inner join sys.partition_range_values rv 
on f.function_id=rv.function_id 
where f.name = 'FN_altas_fecha'
gO



select p.partition_number, p.rows from sys.partitions p 
inner join sys.tables t 
on p.object_id=t.object_id and t.name = 'alta_empleados' 
GO

--partition_number	rows
--1					3
--2					0
--3					0

DECLARE @TableName NVARCHAR(200) = N'alta_empleados' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

--object			p#	filegroup	rows	pages	comparison	value	first_page
--dbo.alta_empleados	1	FG_Archivo	3		9			less than	2016-01-01 00:00:00.000	3:8
--dbo.alta_empleados	2	FG_2016		0		0			less than	2017-01-01 00:00:00.000	0:0
--dbo.alta_empleados	3	FG_2017		0		0			less than	NULL	0:0
-------------------
INSERT INTO alta_empleados 
	VALUES ('Laura','Muñoz','recepcion','2016-06-06'), 
	('Rosa Maria','Leandro','fisioterapia','2016-02-03'), 
	('Federico','Ramos','limpieza','2016-04-06')
GO

SELECT *,$Partition.FN_altas_fecha(fecha_alta) 
FROM alta_empleados
GO

-- (3 rows affected)


select name, create_date, value from sys.partition_functions f 
inner join sys.partition_range_values rv 
on f.function_id=rv.function_id 
where f.name = 'FN_altas_fecha'
gO

--name				create_date	value
--FN_altas_fecha	2022-01-26 11:38:18.493	2016-01-01 00:00:00.000
--FN_altas_fecha	2022-01-26 11:38:18.493	2017-01-01 00:00:00.000

select p.partition_number, p.rows from sys.partitions p 
inner join sys.tables t 
on p.object_id=t.object_id and t.name = 'alta_empleados' 
GO

--partition_number	rows
--1					3
--2					3
--3					0


DECLARE @TableName NVARCHAR(200) = N'alta_empleados' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

--object	p#	filegroup	rows	pages	comparison	value	first_page
--dbo.alta_empleados	1	FG_Archivo	3	9	less than	2016-01-01 00:00:00.000	3:8
--dbo.alta_empleados	2	FG_2016	3	9	less than	2017-01-01 00:00:00.000	4:8
--dbo.alta_empleados	3	FG_2017	0	0	less than	NULL	0:0

--------------------
INSERT INTO alta_empleados 
	VALUES ('julio','Cabana','rh','2017-05-6'), 
	('adrian','Martinez','mantenimiento','2017-07-09'), 
	('jessi','Verdes','administracion','2017-09-12')
GO

--(3 rows affected)

SELECT *,$Partition.FN_altas_fecha(fecha_alta) 
FROM alta_empleados
GO


--id_alta	nombre	apellido	fecha_alta	(No column name)
--1	Antonio	Ruiz	2015-01-01 00:00:00.000	1
--2	Lucas	García	2015-05-05 00:00:00.000	1
--3	Manuel	Sanchez	2015-08-11 00:00:00.000	1
--4	Laura	Muñoz	2016-06-23 00:00:00.000	2
--5	Rosa Maria	Leandro	2016-02-03 00:00:00.000	2
--6	Federico	Ramos	2016-04-06 00:00:00.000	2
--7	Ismael	Cabana	2017-05-21 00:00:00.000	3
--8	Alejandra	Martinez	2017-07-09 00:00:00.000	3
--9	Alfonso	Verdes	2017-09-12 00:00:00.000	3


select name, create_date, value from sys.partition_functions f 
inner join sys.partition_range_values rv 
on f.function_id=rv.function_id 
where f.name = 'FN_altas_fecha'
gO


select p.partition_number, p.rows from sys.partitions p 
inner join sys.tables t 
on p.object_id=t.object_id and t.name = 'alta_empleados' 
GO

DECLARE @TableName NVARCHAR(200) = N'alta_empleados' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

--object	p#	filegroup	rows	pages	comparison	value	first_page
--dbo.alta_empleados	1	FG_Archivo	3	9	less than	2016-01-01 00:00:00.000	3:8
--dbo.alta_empleados	2	FG_2016	3	9	less than	2017-01-01 00:00:00.000	4:8
--dbo.alta_empleados	3	FG_2017	3	9	less than	NULL	5:8

------------------


INSERT INTO alta_empleados 
	VALUES ('Amanda','Smith','rh','2018-02-5'), 
	('Adolfo','Muñiz','facturacion','2018-01-6'), 
	('Rosario','Fuertes','proveedor','2018-02-2')
GO



SELECT *,$Partition.FN_altas_fecha(fecha_alta) as PARTITION
FROM alta_empleados
GO

--id_alta	nombre	apellido	fecha_alta	PARTITION
--1	Antonio	Ruiz	2015-01-01 00:00:00.000	1
--2	Lucas	García	2015-05-05 00:00:00.000	1
--3	Manuel	Sanchez	2015-08-11 00:00:00.000	1
--4	Laura	Muñoz	2016-06-23 00:00:00.000	2
--5	Rosa Maria	Leandro	2016-02-03 00:00:00.000	2
--6	Federico	Ramos	2016-04-06 00:00:00.000	2
--7	Ismael	Cabana	2017-05-21 00:00:00.000	3
--8	Alejandra	Martinez	2017-07-09 00:00:00.000	3
--9	Alfonso	Verdes	2017-09-12 00:00:00.000	3
--10	Amanda	Smith	2018-02-12 00:00:00.000	3
--11	Adolfo	Muñiz	2018-01-23 00:00:00.000	3
--12	Rosario	Fuertes	2018-02-23 00:00:00.000	3

select name, create_date, value from sys.partition_functions AS f 
inner join sys.partition_range_values AS rv 
on f.function_id=rv.function_id 
where f.name = 'FN_altas_fecha'
gO

--apunte con AS asignas algo al alias que tu indiques 
select p.partition_number, p.rows from sys.partitions as p 
inner join sys.tables as t 
on p.object_id=t.object_id and t.name = 'alta_empleados' 
GO

DECLARE @TableName NVARCHAR(200) = N'alta_empleados' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO


--object	p#	filegroup	rows	pages	comparison	value	first_page
--dbo.alta_empleados	1	FG_Archivo	3	9	less than	2016-01-01 00:00:00.000	3:8
--dbo.alta_empleados	2	FG_2016		3	9	less than	2017-01-01 00:00:00.000	4:8
--dbo.alta_empleados	3	FG_2017		6	9	less than	NULL	5:8


--siguiente fase--
-- PARTITIONS OPERATIONS

-- SPLIT = partir algo 

--alteramos la particion en modo split partiendola desde el rango '2018-01-01' y creando una 4 particion
ALTER PARTITION FUNCTION FN_altas_fecha() 
	SPLIT RANGE ('2018-01-01'); 
GO

SELECT *,$Partition.FN_altas_fecha(fecha_alta) as PARTITION
FROM alta_empleados
GO

DECLARE @TableName NVARCHAR(200) = N'alta_empleados' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

--object			p#	filegroup	rows	pages	comparison	value	first_page
--dbo.alta_empleados	1	FG_Archivo	3	9	less than	2016-01-01 00:00:00.000	3:8
--dbo.alta_empleados	2	FG_2016		3	9	less than	2017-01-01 00:00:00.000	4:8
--dbo.alta_empleados	3	FG_2017		3	9	less than	2018-01-01 00:00:00.000	5:8
--dbo.alta_empleados	4	FG_2018		3	9	less than	NULL	6:8



-- MERGE = fusionar particiones o unir algo--

ALTER PARTITION FUNCTION FN_Altas_Fecha ()
MERGE RANGE ('2016-01-01'); 
GO

SELECT *,$Partition.FN_altas_fecha(fecha_alta) 
FROM alta_empleados
GO


DECLARE @TableName NVARCHAR(200) = N'alta_empleados' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

--object			p#	filegroup	rows	pages	comparison	value	first_page
--dbo.alta_empleados	1	FG_Archivo	6	9	less than	2017-01-01 00:00:00.000	3:8
--dbo.alta_empleados	2	FG_2017		3	9	less than	2018-01-01 00:00:00.000	5:8
--dbo.alta_empleados	3	FG_2018		3	9	less than	NULL	6:8



-- Example SWITCH
USE master
GO

--borramos de la base  el file del filegrroup FG_2016
ALTER DATABASE Workout_Training_PCJ REMOVE FILE Altas_2016
go
--borramos el filegroup FG_2016
ALTER DATABASE Workout_Training_PCJ REMOVE FILEGROUP FG_2016 
GO

--The file 'Altas_2016' has been removed.
--The filegroup 'FG_2016' has been removed.

use [Workout_Training_PCJ]
go

select * from sys.filegroups
GO

select * from sys.database_files
GO


-- SWITCH

USE [Workout_Training_PCJ]
go

SELECT *,$Partition.FN_altas_fecha(fecha_alta) 
FROM alta_empleados
GO

DECLARE @TableName NVARCHAR(200) = N'alta_empleados' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

--object			p#	filegroup	rows	pages	comparison	value	first_page
--dbo.alta_empleados	1	FG_Archivo	6	9	less than	2017-01-01 00:00:00.000	3:8
--dbo.alta_empleados	2	FG_2017		3	9	less than	2018-01-01 00:00:00.000	5:8
--dbo.alta_empleados	3	FG_2018		3	9	less than	NULL	6:8


--creamos la tabla que vamos a utilizar para la particion 1 
CREATE TABLE Archivo_Altas 
( id_alta int identity (1,1), 
nombre varchar(20), 
apellido varchar (20),
puesto varchar (100),
fecha_alta datetime ) 
ON FG_Archivo
go

--vamos a cambiar la particion 1 a la tabla nueva Archivo_altas
ALTER TABLE alta_empleados 
	SWITCH Partition 1 to Archivo_Altas
go

--como vemos en la tabla empleados ya no tenemos los empleados de la primera particion
--que corresponden a 2015-2016

select * from alta_empleados 
go

--id_alta	nombre	apellido	puesto			fecha_alta
--7			julio	Cabana		rh				2017-06-05 00:00:00.000
--8			adrian	Martinez	mantenimiento	2017-09-07 00:00:00.000
--9			jessi	Verdes		administracion	2017-12-09 00:00:00.000
--10		Amanda	Smith		rh				2018-05-02 00:00:00.000
--11		Adolfo	Muñiz		facturacion		2018-06-01 00:00:00.000
--12		Rosario	Fuertes		proveedor		2018-02-02 00:00:00.000

select * from Archivo_Altas 
go

--id_alta	nombre			apellido	puesto			fecha_alta
--1			marcos			Ruiz		dietista		2015-01-01 00:00:00.000
--2			miriam			García		limpiadora		2015-05-05 00:00:00.000
--3			romeo			Sanchez		secretario		2015-11-08 00:00:00.000
--4			Laura			Muñoz		recepcion		2016-06-06 00:00:00.000
--5			Rosa Maria		Leandro		fisioterapia	2016-03-02 00:00:00.000
--6			Federico		Ramos		limpieza		2016-06-04 00:00:00.000



DECLARE @TableName NVARCHAR(200) = N'alta_empleados' SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows
, au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

--object			p#	filegroup	rows	pages	comparison	value	first_page
--dbo.alta_empleados	1	FG_Archivo	0	0	less than	2017-01-01 00:00:00.000	0:0
--dbo.alta_empleados	2	FG_2017		3	9	less than	2018-01-01 00:00:00.000	5:8
--dbo.alta_empleados	3	FG_2018		3	9	less than	NULL	6:8

-- TRUNCATE
-- vamos a indicartle con truncate que borre todas las filas despues de la tercera posicion el numero indica la posicion
TRUNCATE TABLE alta_empleados 
	WITH (PARTITIONS (3));
go

select * from alta_empleados
GO

--id_alta	nombre	apellido	puesto			fecha_alta
--7			julio	Cabana		rh				2017-06-05 00:00:00.000
--8			adrian	Martinez	mantenimiento	2017-09-07 00:00:00.000
--9			jessi	Verdes		administracion	2017-12-09 00:00:00.000


DECLARE @TableName NVARCHAR(200) = N'alta_empleados' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

--object			p#	filegroup	rows	pages	comparison	value	first_page
--dbo.alta_empleados	1	FG_Archivo	0	0	less than	2017-01-01 00:00:00.000	0:0
--dbo.alta_empleados	2	FG_2017		3	9	less than	2018-01-01 00:00:00.000	5:8
--dbo.alta_empleados	3	FG_2018		0	0	less than	NULL	0:0










