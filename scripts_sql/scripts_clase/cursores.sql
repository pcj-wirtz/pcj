--ejemplo de cursores
--include actual execution plan
use adventureworks2019
go

declare employee_cursor cursor for
	select[BusinessEntityID], jobtitle
	from advetureworks2019.humanresources.employee;
open employee_cursor;
fetch next from employee_cursor;
while @@fetch_status = 0
	begin
		fetch next from employee_cursor
	end;

close employee_cursor;
deallocate employee_cursor;
go
