-- Extract jobinformations from job_name nnnnnn/uuuuuuuuuu/jjjjjjjjjj
--  Number, user and job
--  Created on 13.07.2020 by Christian Brunner

CREATE OR REPLACE FUNCTION NORMALIZE_JOB_NAME (IN_JOB VARCHAR(28))
 RETURNS TABLE
   (JOB_NUMBER INTEGER,
    JOB_USER VARCHAR(10),
    JOB_NAME VARCHAR(10))   
 LANGUAGE SQL 
 SPECIFIC NJOBNAME
 NOT DETERMINISTIC 
 READS SQL DATA 
 NO EXTERNAL ACTION 
 ALLOW PARALLEL
 NOT SECURED 
 SET OPTION COMMIT = *NONE , DBGVIEW = *SOURCE , DYNUSRPRF = *OWNER , USRPRF = *OWNER

BEGIN 
  
 DECLARE JOB_NUMBER INTEGER;
 DECLARE JOB_USER VARCHAR(10);
 DECLARE JOB_NAME VARCHAR(10);
 DECLARE I1 SMALLINT;
 DECLARE I2 SMALLINT;
 
 SET I1 = LOCATE('/', IN_JOB);
 SET I2 = LOCATE('/', IN_JOB, (I1 + 1));
 
 SET JOB_NUMBER = INTEGER(LEFT(IN_JOB, (I1 - 1)));
 SET JOB_USER = RTRIM(SUBSTRING(IN_JOB, (I1 + 1), (I2 - I1 - 1)));
 SET JOB_NAME = RTRIM(SUBSTRING(IN_JOB, (I2 + 1), (LENGTH(RTRIM(IN_JOB)) - I2)));

 RETURN SELECT JOB_NUMBER, JOB_USER, JOB_NAME FROM SYSIBM.SYSDUMMY1;

END;