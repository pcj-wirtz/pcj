
--ejemplo de cursores
--include actual execution plan
use Workout_Training_PCJ
go

declare entrenador_cursor cursor for
	select [id_monitor],[Nombre],[especialidad_id_especialidad]
	from Workout_Training_PCJ.dbo.entrenadores
open entrenador_cursor;

fetch next from entrenador_cursor;
while @@fetch_status = 0
	begin
		fetch next from entrenador_cursor
	end;

close entrenador_cursor;
deallocate entrenador_cursor;
go
