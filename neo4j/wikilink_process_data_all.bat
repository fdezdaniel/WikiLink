@echo off
cls
xcopy /s/e /y .\wikilink_process_data.cql c:\neo4j\import
for /L %%i in (1,1,10) do (
	echo Batch %%i start
	PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '.\wikilink_process_data.ps1'"
	echo Batch %%i end
)