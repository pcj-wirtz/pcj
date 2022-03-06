use master 
go

drop procedure if exists backup_all_db_parametroentrada
go

create or alter proc backup_all_db_parametroentrada
	@path varchar(256)
	as

--declarando variables 
declare
	@name varchar (50),
	@filename varchar(256),
	@filedate varchar (20),
	@backupcount int

create table #tempbackup
(intID int identity (1,1),
name varchar (200))
--crear la carpeta backup
--set @path = 'C:\BACKUP\'
-- inclulle la fecha en el filename
set @filedate = convert (varchar(20), getdate(),112)

--incllulle la date  y el time en el filename 
--set@filedate = convert (varchar)(20),getdate(),112)


--insertamos en tabla temporal  #tenmpbackup 
insert into #tempbackup (name)
	select name
	from master.dbo.sysdatabases
	where name in ('contenida_pcj','Workout_Training_PCJ')

--creamo un contador 
select top 1 @backupcount = intID
from #tempbackup
order by intID desc

--utilidad solo comprobacion nº backups a realizar
print @backupcount

if ((@backupcount is not null) and (@backupcount > 0 ))
begin
	declare
		@currentbackup int
	set @currentbackup = 1
	while (@currentbackup <= @backupcount)
		begin
			select
			@name = name,
			@filename = @path + name + '_' + @filedate + '.BAK'
			from #tempbackup
			where intID = @currentbackup

			--utilidad solo comprobacion nombre backup
			print @filename
			backup database @name to disk = @filename
			--si quiero sobreescribir el backup 
			--backup database @name to disk = @filename with init

			set @currentbackup = @currentbackup + 1
		end
end

select * from #tempbackup
go

exec backup_all_db_parametroentrada 'C:\BACKUP\'
go
