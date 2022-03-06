use master
go

drop database if exists Workout_Training_PCJ
go

/*creamos nuestra base de datos */


CREATE DATABASE Workout_Training_PCJ ON PRIMARY
( NAME = N'Workout_Training_PCJ', FILENAME = N'C:\Data\Workout_Training_PCJ_principal.mdf' , SIZE = 15360KB , MAXSIZE = UNLIMITED,
FILEGROWTH = 0)
LOG ON 
( NAME = N'Workout_Training_PCJ_log', FILENAME =
N'C:\Data\Workout_Training_PCJ_log.ldf' , SIZE = 10176KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO

use Workout_Training_PCJ
go


CREATE TABLE acondicionamiento 
    (
     id_acondicionamiento INTEGER NOT NULL , 
     peso_actual VARCHAR (50) , 
     dieta_id_dieta INTEGER NOT NULL , 
     entrenadores_id_monitor INTEGER NOT NULL , 
     cliente_id_cliente INTEGER NOT NULL 
    )
GO

ALTER TABLE acondicionamiento ADD CONSTRAINT acondicionamiento_PK PRIMARY KEY CLUSTERED (id_acondicionamiento)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE CCAA 
    (
     id_CCAA INTEGER NOT NULL , 
     Nombre VARCHAR (50) NOT NULL 
    )
GO

ALTER TABLE CCAA ADD CONSTRAINT CCAA_PK PRIMARY KEY CLUSTERED (id_CCAA)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE cliente 
    (
     id_cliente INTEGER NOT NULL , 
     DNI NVARCHAR (9) NOT NULL , 
     Nombre VARCHAR (50) NOT NULL , 
     Apellido VARCHAR (50) NOT NULL , 
     Apellido2 VARCHAR (50) NOT NULL , 
     direccion_id_direccion INTEGER NOT NULL , 
     medidas_medidas INTEGER NOT NULL , 
     objetivos_id_objetivos INTEGER NOT NULL,
	 fecha_alta datetime NULL
    )
GO 

    


CREATE UNIQUE NONCLUSTERED INDEX 
    cliente__IDX ON cliente 
    ( 
     direccion_id_direccion 
    ) 
GO

ALTER TABLE cliente ADD CONSTRAINT cliente_PK PRIMARY KEY CLUSTERED (id_cliente)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE dieta 
    (
     id_dieta INTEGER NOT NULL , 
     tipo VARCHAR (100) 
    )
GO

ALTER TABLE dieta ADD CONSTRAINT dieta_PK PRIMARY KEY CLUSTERED (id_dieta)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE direccion 
    (
     id_direccion INTEGER NOT NULL , 
     calle VARCHAR (100) NOT NULL , 
     CP INTEGER NOT NULL , 
     Localidad_id_Loc INTEGER NOT NULL 
    )
GO

ALTER TABLE direccion ADD CONSTRAINT direccion_PK PRIMARY KEY CLUSTERED (id_direccion)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE entrenadores 
    (
     id_monitor INTEGER NOT NULL , 
     DNI NVARCHAR (9) NOT NULL , 
     Nombre VARCHAR (50) NOT NULL , 
     Apellido VARCHAR (50) NOT NULL , 
     Apellido2 VARCHAR (50) NOT NULL , 
     especialidad_id_especialidad INTEGER NOT NULL , 
     Localidad_id_Loc INTEGER NOT NULL 
    )
GO

ALTER TABLE entrenadores ADD CONSTRAINT entrenadores_PK PRIMARY KEY CLUSTERED (id_monitor)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE especialidad 
    (
     id_especialidad INTEGER NOT NULL , 
     tipo_entrenamiento VARCHAR (100) NOT NULL 
    )
GO

ALTER TABLE especialidad ADD CONSTRAINT especialidad_PK PRIMARY KEY CLUSTERED (id_especialidad)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE Localidad 
    (
     Provincia_id_Prov INTEGER NOT NULL , 
     id_Loc INTEGER NOT NULL , 
     Nombre VARCHAR (50) NOT NULL 
    )
GO

ALTER TABLE Localidad ADD CONSTRAINT Localidad_PK PRIMARY KEY CLUSTERED (id_Loc)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE material 
    (
     id_material INTEGER NOT NULL , 
     pesas BIT , 
     cintas BIT , 
     guantes BIT , 
     colchonetas BIT 
    )
GO

ALTER TABLE material ADD CONSTRAINT material_PK PRIMARY KEY CLUSTERED (id_material)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE medidas 
    (
     medidas INTEGER NOT NULL , 
     peso VARCHAR (50) NOT NULL , 
     altura VARCHAR (50) NOT NULL 
    )
GO

ALTER TABLE medidas ADD CONSTRAINT medidas_PK PRIMARY KEY CLUSTERED (medidas)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE objetivos 
    (
     id_objetivos INTEGER NOT NULL , 
     tipo_objetivo VARCHAR (100) NOT NULL 
    )
GO

ALTER TABLE objetivos ADD CONSTRAINT objetivos_PK PRIMARY KEY CLUSTERED (id_objetivos)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE Provincia 
    (
     CCAA_id_CCAA INTEGER NOT NULL , 
     id_Prov INTEGER NOT NULL , 
     Nombre VARCHAR (50) NOT NULL 
    )
GO

ALTER TABLE Provincia ADD CONSTRAINT Provincia_PK PRIMARY KEY CLUSTERED (id_Prov)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE sesiones 
    (
     entrenadores_id_monitor INTEGER NOT NULL , 
     cliente_id_cliente INTEGER NOT NULL , 
     hora_inicio TIME NOT NULL , 
     duracion NVARCHAR (50) NOT NULL , 
     material_id_material INTEGER NOT NULL 
    )
GO

ALTER TABLE sesiones ADD CONSTRAINT sesiones_PK PRIMARY KEY CLUSTERED (entrenadores_id_monitor, cliente_id_cliente)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

ALTER TABLE acondicionamiento 
    ADD CONSTRAINT acondicionamiento_cliente_FK FOREIGN KEY 
    ( 
     cliente_id_cliente
    ) 
    REFERENCES cliente 
    ( 
     id_cliente 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE acondicionamiento 
    ADD CONSTRAINT acondicionamiento_dieta_FK FOREIGN KEY 
    ( 
     dieta_id_dieta
    ) 
    REFERENCES dieta 
    ( 
     id_dieta 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE acondicionamiento 
    ADD CONSTRAINT acondicionamiento_entrenadores_FK FOREIGN KEY 
    ( 
     entrenadores_id_monitor
    ) 
    REFERENCES entrenadores 
    ( 
     id_monitor 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE cliente 
    ADD CONSTRAINT cliente_direccion_FK FOREIGN KEY 
    ( 
     direccion_id_direccion
    ) 
    REFERENCES direccion 
    ( 
     id_direccion 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE cliente 
    ADD CONSTRAINT cliente_medidas_FK FOREIGN KEY 
    ( 
     medidas_medidas
    ) 
    REFERENCES medidas 
    ( 
     medidas 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE cliente 
    ADD CONSTRAINT cliente_objetivos_FK FOREIGN KEY 
    ( 
     objetivos_id_objetivos
    ) 
    REFERENCES objetivos 
    ( 
     id_objetivos 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE direccion 
    ADD CONSTRAINT direccion_Localidad_FK FOREIGN KEY 
    ( 
     Localidad_id_Loc
    ) 
    REFERENCES Localidad 
    ( 
     id_Loc 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE entrenadores 
    ADD CONSTRAINT entrenadores_especialidad_FK FOREIGN KEY 
    ( 
     especialidad_id_especialidad
    ) 
    REFERENCES especialidad 
    ( 
     id_especialidad 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE entrenadores 
    ADD CONSTRAINT entrenadores_Localidad_FK FOREIGN KEY 
    ( 
     Localidad_id_Loc
    ) 
    REFERENCES Localidad 
    ( 
     id_Loc 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE Localidad 
    ADD CONSTRAINT Localidad_Provincia_FK FOREIGN KEY 
    ( 
     Provincia_id_Prov
    ) 
    REFERENCES Provincia 
    ( 
     id_Prov 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE Provincia 
    ADD CONSTRAINT Provincia_CCAA_FK FOREIGN KEY 
    ( 
     CCAA_id_CCAA
    ) 
    REFERENCES CCAA 
    ( 
     id_CCAA 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE sesiones 
    ADD CONSTRAINT sesiones_cliente_FK FOREIGN KEY 
    ( 
     cliente_id_cliente
    ) 
    REFERENCES cliente 
    ( 
     id_cliente 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE sesiones 
    ADD CONSTRAINT sesiones_entrenadores_FK FOREIGN KEY 
    ( 
     entrenadores_id_monitor
    ) 
    REFERENCES entrenadores 
    ( 
     id_monitor 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE sesiones 
    ADD CONSTRAINT sesiones_material_FK FOREIGN KEY 
    ( 
     material_id_material
    ) 
    REFERENCES material 
    ( 
     id_material 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO


