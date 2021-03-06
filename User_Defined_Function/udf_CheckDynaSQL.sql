IF OBJECT_ID('dbo.udf_CheckDynaSQL', 'FN') IS NULL
EXECUTE ('CREATE FUNCTION dbo.udf_CheckDynaSQL() RETURNS INT AS BEGIN RETURN 1 END;');

CREATE FUNCTION dbo.udf_CheckDynaSQL (@dynamicSQL NVARCHAR (4000))
RETURNS NVARCHAR (2000)
/*
Author: Eli Leiba
Source link: https://www.mssqltips.com/sqlservertip/4981/sql-server-function-to-check-dynamic-sql-syntax/
Description: Check Dynamic SQL Statement Syntax
*/
AS
BEGIN
   DECLARE @Result NVARCHAR (2000);

   IF EXISTS (
         SELECT 1
         FROM sys.dm_exec_describe_first_result_set (@dynamicSQL, NULL, 0)
         WHERE [error_message] IS NOT NULL
            AND [error_number] IS NOT NULL
            AND [error_severity] IS NOT NULL
            AND [error_state] IS NOT NULL
            AND [error_type] IS NOT NULL
            AND [error_type_desc] IS NOT NULL
         )
   BEGIN
      SELECT @Result = [error_message]
      FROM sys.dm_exec_describe_first_result_set(@dynamicSQL, NULL, 0)
      WHERE column_ordinal = 0;
   END
   ELSE
   BEGIN
      SET @Result = 'OK'
   END

   RETURN (@Result);
END
GO
