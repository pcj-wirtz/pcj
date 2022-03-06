
--activamos el acces level de nivel dos 
EXEC sp_configure filestream_access_level, 2
RECONFIGURE
GO



USE [master]
GO

-- Createe FileTable con funcion rollback immediate
--para que eche a los usuarios i se ejecute immediatamente 
ALTER DATABASE [Workout_Training_PCJ] SET FILESTREAM( NON_TRANSACTED_ACCESS = FULL, 
DIRECTORY_NAME = N'Workout_Training_PCJ' ) WITH
rollback immediate
GO

USE Workout_Training_PCJ
GO

DROP TABLE IF EXISTS documentos_Workout 
GO

--vamos a crear una tabla donde vamos a guardar nuestros documentos de entrenamiento
CREATE TABLE documentos_Workout AS FILETABLE
WITH 
(
    FileTable_Directory = 'documentos_Workout',
    FileTable_Collate_Filename = database_default,
	Filetable_streamid_unique_constraint_name=uq_stream_id
);
GO




-- vemos  la tabla en el explorador de la base dentro de la carpeta de filetables 

--se nos creara una carpeta compartida en red 

--comprobamos la filetable pare ver que esta vacia
SELECT * FROM documentos_Workout
GO


-- abro la carpeta  dentro arrasto tablas de entrenamiento 

--select para ver el nombre de los archivos y la id_stream
SELECT  [stream_id],[name]
  FROM Workout_Training_PCJ.dbo.documentos_Workout
GO

--  stream_id									           name
--B4608232-B146-EA11-9BCD-000C29A5C7F8					hiremenow.png
--B5608232-B146-EA11-9BCD-000C29A5C7F8					names.xls
--B7608232-B146-EA11-9BCD-000C29A5C7F8					Seguridad Encerado.jpeg






