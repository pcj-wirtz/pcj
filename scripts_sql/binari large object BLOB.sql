use pubs
go

drop table if exists logo
go

create table logo 
( 
	logoid int,
	logoname varchar (255),
	logoimage varbinary (max)
	)
go

insert into dbo.logo
(
	logoid,
	logoname,
	logoimage
)
select 1,'brad pit',
	* from openrowset
	( bulk 'C:\BLOB\brad.jfif' , single_blob) as imagefile
go


insert into dbo.logo
(
	logoid,
	logoname,
	logoimage
)
select 2,'will',
	* from openrowset
	( bulk 'C:\BLOB\will.jfif' , single_blob) as imagefile
go


insert into dbo.logo
(
	logoid,
	logoname,
	logoimage
)
select 3,'tom hanks',
	* from openrowset
	( bulk 'C:\BLOB\tom.jfif' , single_blob) as imagefile
go


select *from logo
go


--version con azure data estudio .exe como BLOB
use tempdb
go

drop table if exists tbldata
go

create table tbldata
(
fileid int,
filedata varbinary(max)
)
go

insert into tbldata
(fileid, filedata)
select 1, bulkcolumn
from openrowset ( bulk 'C:\BLOB\azuredatastudio.exe', single_blob) as ejecutable
go

select *from tbldata
go
