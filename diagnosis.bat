@echo off


del C:\ProgramData\Microsoft\Diagnosis\ETLLogs\*.* /S /F /Q

SET Path2Del=C:\ProgramData\Microsoft\Diagnosis\ETLLogs\

for /R "%Path2Del%" %%F in (.) DO IF NOT "%%F"=="%Path2Del%." (RD /S /Q "%%F") ELSE (Del /F /S /Q "%Path2Del%*")



echo Vse vashe udalil da

exit

@echo ON
