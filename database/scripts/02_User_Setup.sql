
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;

CREATE TABLESPACE tbs_smartresto_data 
    DATAFILE 'smartresto_data.dbf' 
    SIZE 100M 
    AUTOEXTEND ON NEXT 10M MAXSIZE 2G;

CREATE TABLESPACE tbs_smartresto_idx 
    DATAFILE 'smartresto_idx.dbf' 
    SIZE 50M 
    AUTOEXTEND ON NEXT 5M MAXSIZE 1G;

CREATE TEMPORARY TABLESPACE tbs_smartresto_temp
    TEMPFILE 'smartresto_temp.dbf'
    SIZE 50M
    AUTOEXTEND ON;


CREATE USER GrpA_27253_Tricia_SmartResto_DB 
    IDENTIFIED BY Tricia
    DEFAULT TABLESPACE tbs_smartresto_data
    TEMPORARY TABLESPACE tbs_smartresto_temp
    QUOTA UNLIMITED ON tbs_smartresto_data
    QUOTA UNLIMITED ON tbs_smartresto_idx;

GRANT CONNECT, RESOURCE, DBA TO GrpA_27253_Tricia_SmartResto_DB;
GRANT CREATE SESSION TO GrpA_27253_Tricia_SmartResto_DB;
GRANT CREATE VIEW TO GrpA_27253_Tricia_SmartResto_DB;
GRANT CREATE PROCEDURE TO GrpA_27253_Tricia_SmartResto_DB;
GRANT CREATE TRIGGER TO GrpA_27253_Tricia_SmartResto_DB;