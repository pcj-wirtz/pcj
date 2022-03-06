

use master
go

--	A nivel de BD mediante sp_configure @enablelevel, dónde @enablelevel indica:

EXEC sp_configure
go
--comprovamos el nivel del filestream
EXEC sp_configure filestream_access_level
go

--0 = Deshabilitado. Este es el valor por defecto.
--1 = Habilitado solo para acceso T-SQL.
--2 = Habilitado solo para T-SQL y acceso local al sistema de ficheros.
--3 = Habilitado para T-SQL, acceso local y remoto al sistema de ficheros.

--lo cambiamos a nivel 2




-- Activa la Opción en el SQL SERVER CONFIGURATION MANAGER

--Puedes ejecutarlo directamente desde el cuadro de diálogo ejecutar 

--SQLServerManager15.msc para SQL Server 2019

-- ENABLE FILESTREAM

-- RESTART MSSQLSERVER SERVICE



USE [Workout_Training_PCJ]
go

--creamos el filestream
ALTER DATABASE Workout_Training_PCJ 
	ADD FILEGROUP [PRIMARY_FILESTREAM] 
	CONTAINS FILESTREAM 
GO

ALTER DATABASE Workout_Training_PCJ
       ADD FILE (
             NAME = 'workout_filestream',
             FILENAME = 'C:\DATA\filestream'
       )
       TO FILEGROUP [PRIMARY_FILESTREAM]
GO

USE Workout_Training_PCJ
GO

DROP TABLE IF EXISTS imagenes_materiales
GO

CREATE TABLE imagenes_materiales(
       id UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL UNIQUE,
	   materialname varchar (255),
       archivo_imagen VARBINARY(MAX) FILESTREAM
);
GO

--creamos la carpeta 
-- FOLDER C:\imagenes_materiales\
INSERT INTO imagenes_materiales(id, materialname, archivo_imagen)
		SELECT NEWID(),'pesas', BulkColumn
		FROM OPENROWSET(BULK 'C:\imagenes_materiales\pesas.jfif', SINGLE_BLOB) as f;
GO

INSERT INTO imagenes_materiales(id,materialname, archivo_imagen)
	SELECT NEWID(),'guantes de entreno', BulkColumn
	FROM OPENROWSET(BULK 'C:\imagenes_materiales\guantes.jfif', SINGLE_BLOB) as f;
GO

INSERT INTO imagenes_materiales(id, materialname, archivo_imagen)
	SELECT NEWID(),'bandas elasticas', BulkColumn
	FROM OPENROWSET(BULK 'C:\imagenes_materiales\bandas.jfif', SINGLE_BLOB) as f;
GO

SELECT *
FROM imagenes_materiales;
GO


-- C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\filestream
-- Open with PAINT
-- Filestream columns

SELECT SCHEMA_NAME(t.schema_id) AS [schema], 
    t.[name] AS [table],
    c.[name] AS [column],
    TYPE_NAME(c.user_type_id) AS [column_type]
FROM sys.columns c
JOIN sys.tables t ON c.object_id = t.object_id
WHERE t.filestream_data_space_id IS NOT NULL
    AND c.is_filestream = 1
ORDER BY 1, 2, 3;


-- Filestream files and filegroups
SELECT f.[name] AS [file_name],
    f.physical_name AS [file_path],
    fg.[name] AS [filegroup_name]
FROM sys.database_files f 
JOIN sys.filegroups fg ON f.data_space_id = fg.data_space_id
WHERE f.[type] = 2
ORDER BY 1;
GO

/*
ALTER TABLE [dbo].[imagenes_materiales] DROP COLUMN [archivo_imagen]
GO

--no necesario imagenes_materiales 
ALTER TABLE [imagenes_materiales] SET (FILESTREAM_ON="NULL")
GO


ALTER DATABASE [Workout_Training_PCJ] REMOVE FILE workout_filestream;
GO

--Msg 5042, Level 16, State 13, Line 134
--The file 'workout_filestream' cannot be removed because it is not empty.

USE master
GO

ALTER DATABASE [Workout_Training_PCJ] REMOVE FILE workout_filestream;
GO

--The file 'MyDatabase_filestream' has been removed.

ALTER DATABASE [Workout_Training_PCJ] REMOVE FILEGROUP  [PRIMARY_FILESTREAM]
GO

-- The filegroup 'PRIMARY_FILESTREAM' has been removed.

DROP DATABASE [imagenes_materiales]
GO*/

