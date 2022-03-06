use Workout_Training_PCJ
go


--creamos el file group optimizado para memoria
ALTER DATABASE Workout_Training_PCJ ADD FILEGROUP FG_InMemory CONTAINS MEMORY_OPTIMIZED_DATA
go


--creamos el archivo de ese filegroup
ALTER DATABASE Workout_Training_PCJ ADD FILE (name='inmemory', filename='c:\Data\inmemory') TO FILEGROUP FG_InMemory
go


--creamos tabla proovedor
CREATE TABLE proovedor(  
  proovedorID nchar (5) NOT NULL PRIMARY KEY NONCLUSTERED,  
  empresa nvarchar (30) NOT NULL   
) WITH (MEMORY_OPTIMIZED=ON)  
GO  


--creamos tabla pedidos
CREATE TABLE pedidos(  
  pedidosID int NOT NULL PRIMARY KEY NONCLUSTERED,  
  proovedorID nchar (5) NOT NULL INDEX IX_proovedorID HASH(proovedorID) WITH (BUCKET_COUNT=100000),  
  Fecha_pedido date NOT NULL INDEX IX_Fecha_pedido HASH(Fecha_pedido) WITH (BUCKET_COUNT=100000)  
) WITH (MEMORY_OPTIMIZED=ON)  
GO  

--insertamos datos en proovedor
insert into proovedor ( proovedorID,empresa)
values 
		(1,'cocacola'),
		(2,'myprotein'),
		(3,'prozis')
go

select * from proovedor
go

--proovedorID	empresa
--2    			myprotein
--1    			cocacola
--3    			prozis


--insertamos los pedidos realizados
insert into pedidos(pedidosID,proovedorID,Fecha_pedido)
values 
		(1,3,'2021-12-12'),
		(2,1,'2022-01-01'),
		(3,2,'2022-02-02')
go

select *from pedidos
go

--pedidosID	proovedorID	Fecha_pedido
--1			3    		2021-12-12
--2			1    		2022-01-01
--3			2    		2022-02-02


--vamos arealizar una consulta inner join entre las dos tablas 

SELECT o.pedidosID, c.* FROM proovedor c INNER JOIN pedidos o ON c.proovedorID = o.proovedorID
go


