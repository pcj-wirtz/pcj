
-- How to Map Multiple Partitions to a Single Filegroup in SQL Server (T-SQL)
-- https://database.guide/how-to-map-multiple-partitions-to-a-single-filegroup-in-sql-server-t-sql/

-- Example 1 – Map All Partitions to a Single Filegroup

USE master
GO
DROP DATABASE IF EXISTS test1
GO
CREATE DATABASE test1
GO
USE test1
GO

-- -- CREATE FOLDER test1
-- 'C:\test1\
-- Create filegroups AND Files

-- Create one filegroup
ALTER DATABASE test1 ADD FILEGROUP OrdersNewFg1;
GO

ALTER DATABASE test1   
ADD FILE   
(  
    NAME = OrdersNewFg1dat,  
    FILENAME = 'C:\test1\OrdersNewFg1dat.ndf',  
    SIZE = 5MB,  
    MAXSIZE = 100MB,  
    FILEGROWTH = 5MB  
)  
TO FILEGROUP OrdersNewFg1;
GO

-- Create a partition function that will result in twelve partitions  
CREATE PARTITION FUNCTION OrdersNewPartitionFunction (date)  
    AS RANGE RIGHT FOR VALUES (
        '20200201', 
        '20200301',
        '20200401', 
        '20200501',
        '20200601',
        '20200701',
        '20200801',
        '20200901',
        '20201001',
        '20201101',
        '20201201'
    );
GO

-- Create a partition scheme that maps all partitions to the OrdersNewFg1 filegroup
CREATE PARTITION SCHEME OrdersNewPartitionScheme
    AS PARTITION OrdersNewPartitionFunction  
    ALL TO (OrdersNewFg1);  
GO

-- Create a partitioned table
CREATE TABLE OrdersNew (
    OrderDate date NOT NULL,
    OrderId int IDENTITY NOT NULL,
    OrderDesc varchar(255) NOT NULL
    )  
    ON OrdersNewPartitionScheme (OrderDate);  
GO


SELECT 
    p.partition_number AS [Partition], 
    fg.name AS [Filegroup], 
    p.Rows
FROM sys.partitions p
    INNER JOIN sys.allocation_units au
    ON au.container_id = p.hobt_id
    INNER JOIN sys.filegroups fg
    ON fg.data_space_id = au.data_space_id
WHERE p.object_id = OBJECT_ID('OrdersNew');
GO

-- Example 2 – Map Some Partitions to a Single Filegroup

-- Create two filegroups
ALTER DATABASE test1 ADD FILEGROUP OrdersNewFg1;
GO

ALTER DATABASE test1   
ADD FILE   
(  
    NAME = OrdersNewFg1dat,  
    FILENAME = 'C:\test1\OrdersNewFg1dat.ndf',  
    SIZE = 5MB,  
    MAXSIZE = 100MB,  
    FILEGROWTH = 5MB  
)  
TO FILEGROUP OrdersNewFg1;
GO

ALTER DATABASE test1 ADD FILEGROUP OrdersNewFg2;
GO

ALTER DATABASE test1   
ADD FILE   
(  
    NAME = OrdersNewFg2dat,  
    FILENAME = 'C:\test1\OrdersNewFg2dat.ndf',  
    SIZE = 5MB,  
    MAXSIZE = 100MB,  
    FILEGROWTH = 5MB  
)  
TO FILEGROUP OrdersNewFg2;
GO

-- Create a partition function that will result in twelve partitions  
CREATE PARTITION FUNCTION OrdersNewPartitionFunction (date)  
    AS RANGE RIGHT FOR VALUES (
        '20200201', 
        '20200301',
        '20200401', 
        '20200501',
        '20200601',
        '20200701',
        '20200801',
        '20200901',
        '20201001',
        '20201101',
        '20201201'
    );
GO

-- Create a partition scheme that maps all partitions to the OrdersNewFg1 filegroup
CREATE PARTITION SCHEME OrdersNewPartitionScheme
    AS PARTITION OrdersNewPartitionFunction  
    TO (
        OrdersNewFg1,
        OrdersNewFg1,
        OrdersNewFg1,
        OrdersNewFg1,
        OrdersNewFg1,
        OrdersNewFg1,
        OrdersNewFg2,
        OrdersNewFg2,
        OrdersNewFg2,
        OrdersNewFg2,
        OrdersNewFg2,
        OrdersNewFg2
        );  
GO

-- Create a partitioned table
CREATE TABLE OrdersNew (
    OrderDate date NOT NULL,
    OrderId int IDENTITY NOT NULL,
    OrderDesc varchar(255) NOT NULL
    )  
    ON OrdersNewPartitionScheme (OrderDate);  
GO
--Check the Mapping
--Let’s see how the partitions are mapped to the filegroups.

SELECT 
    p.partition_number AS [Partition], 
    fg.name AS [Filegroup], 
    p.Rows
FROM sys.partitions p
    INNER JOIN sys.allocation_units au
    ON au.container_id = p.hobt_id
    INNER JOIN sys.filegroups fg
    ON fg.data_space_id = au.data_space_id
WHERE p.object_id = OBJECT_ID('OrdersNew');
GO

-- As expected, the first six partitions are mapped to the first filegroup, 
-- and the remainder are mapped to the second.

