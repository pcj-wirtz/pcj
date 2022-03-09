sqlplus

sys /as sysdba

ALTER SESSION SET container = XEPDB1;

ALTER PLUGGABLE DATABASE open;

CREATE SMALLFILE TABLESPACE PCJ DATAFILE 'C:\app\PCJ\product\18.0.0\oradata\XE\XEPDB1\PCJ.DBF' 
SIZE 200M LOGGING EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO;

CREATE USER JAIR PROFILE DEFAULT IDENTIFIED BY oracle DEFAULT 
TABLESPACE PCJ TEMPORARY TABLESPACE TEMP ACCOUNT UNLOCK quota unlimited on PCJ;

GRANT CONNECT TO JAIR;

GRANT ALL PRIVILEGES TO JAIR;

GRANT RESOURCE TO JAIR;

GRANT INSERT ANY TABLE TO JAIR;

ALTER SESSION SET CURRENT_SCHEMA = JAIR;

-- CREO CONEXIÓN AL USUARIO jair

-- CAMBIO DE CONEXIÓN A jair

-- creando las tablas lanzando scripts

-- @co_ddl

-- @co_dml

-- INGENIERIA INVERSA

-- GENERACIÓN SCRIPT SQL SERVER

-- SSMS EJECUTAR SCRIPT

-- GENERAR DIAGRAMA

-- BACKUP


