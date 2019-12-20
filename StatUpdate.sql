DECLARE esquema VARCHAR2(100);

CURSOR c IS SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME NOT LIKE 'SHADOW_%';

BEGIN

SELECT '"'||sys_context('USERENV', 'CURRENT_SCHEMA')||'"' INTO esquema FROM dual;
FOR taula IN c LOOP
DBMS_STATS.GATHER_TABLE_STATS( 
    ownname => esquema, 
    tabname => taula.table_name, 
    estimate_percent => NULL,
    method_opt =>'FOR ALL COLUMNS SIZE REPEAT',
    granularity => 'GLOBAL',
    cascade => TRUE
    );
END LOOP;

END;