@echo off
REM --- Copy Contents from Aras and SQL ---
REM Define Source and Destination folders
SET SourceDirAras=C:\Innovator
SET DestDirAras=C:\innovator_data_tmp

SET SourceDirSQL=c:\\program files\\microsoft sql server\\mssql15.mssqlserver\\mssql\\data
SET DestDirSQL=C:\mssql_data_tmp

net stop "SQL Server (MSSQLSERVER)"

REM Run Robocopy command to mirror the directories if they exist
IF EXIST "%DestDirAras%\" (
    robocopy "%SourceDirAras%" "%DestDirAras%" /E
)

IF EXIST "%DestDirSQL%\" (
    robocopy "%SourceDirSQL%" "%DestDirSQL%" /E
)

net start "SQL Server (MSSQLSERVER)"