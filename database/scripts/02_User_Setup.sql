ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;

CREATE TABLESPACE tbs_nursing_data 
    DATAFILE 'nursing_data.dbf' 
    SIZE 100M 
    AUTOEXTEND ON NEXT 10M MAXSIZE 2G;

CREATE TABLESPACE tbs_nursing_idx 
    DATAFILE 'nursing_idx.dbf' 
    SIZE 50M 
    AUTOEXTEND ON NEXT 5M MAXSIZE 1G;

CREATE TEMPORARY TABLESPACE tbs_nursing_temp
    TEMPFILE 'nursing_temp.dbf'
    SIZE 50M
    AUTOEXTEND ON;

CREATE USER Grp_28888_Gerardine_Nursing_DB 
    IDENTIFIED BY Gerardine
    DEFAULT TABLESPACE tbs_nursing_data
    TEMPORARY TABLESPACE tbs_nursing_temp
    QUOTA UNLIMITED ON tbs_nursing_data
    QUOTA UNLIMITED ON tbs_nursing_idx;

GRANT CONNECT, RESOURCE, DBA TO Grp_28888_Gerardine_Nursing_DB;
GRANT CREATE SESSION TO Grp_28888_Gerardine_Nursing_DB;
GRANT CREATE VIEW TO Grp_28888_Gerardine_Nursing_DB;
GRANT CREATE PROCEDURE TO Grp_28888_Gerardine_Nursing_DB;
GRANT CREATE TRIGGER TO Grp_28888_Gerardine_Nursing_DB;
GRANT CREATE ANY CONTEXT TO Grp_28888_Gerardine_Nursing_DB;

PROMPT User and Tablespaces Setup Successfully.