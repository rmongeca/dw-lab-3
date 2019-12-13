BEGIN
	
FOR t IN (SELECT table_name FROM user_tables) LOOP

EXECUTE IMMEDIATE ('drop table '||t.table_name||' cascade constraints');

END LOOP;

END;