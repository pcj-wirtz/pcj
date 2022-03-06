use Workout_Training_PCJ
go

drop table if exists imagen_materiales_dentroDB
go

create table imagen_materiales_dentroDB
( 
	materialid int,
	materialname varchar (255),
	materialimage varbinary (max)
	)
go

insert into dbo.imagen_materiales_dentroDB
(
	materialid,
	materialname,
	materialimage
)
select 1,'pesas',
	* from openrowset
	( bulk 'C:\imagenes_materiales\pesas.jfif' , single_blob) as imagefile
go


insert into dbo.imagen_materiales_dentroDB
(
	materialid,
	materialname,
	materialimage
)
select 2,'bandas elasticas',
	* from openrowset
	( bulk 'C:\imagenes_materiales\bandas.jfif' , single_blob) as imagefile
go


insert into dbo.imagen_materiales_dentroDB
(
	materialid,
	materialname,
	materialimage
)
select 3,'guantes de entrenamiento',
	* from openrowset
	( bulk 'C:\imagenes_materiales\guantes.jfif' , single_blob) as imagefile
go


select *from imagen_materiales_dentroDB
go

