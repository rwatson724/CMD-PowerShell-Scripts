@ECHO OFF
CLS
REM: A BATCH SCRIPT TO RUN A SINGLE PROGRAM
REM: BATCH SCRIPT IS STORED IN SAME LOCATION AS THE PROGRAMS

REM: Check to see if log and lst folders are existing as subfolder
if exist "%~d1%~p1\Logs" (set LogFolder=%~d1%~p1\Logs) else (
  mkdir Logs
  set LogFolder=%~d1%~p1\Logs
)

if exist "%~d1%~p1\Lsts"(set LstFolder=%~d1%~p1\LstFolder) else (
  mkdir Lsts
  set LstFolder=%~d1%~p1\Lsts
)

REM: Find the name of the current file (~nA) without the extension (if want extension use ~xA)
for %%A in (%*) do set pgm=%%~nA

REM: Location and configuration file for SAS program
set sas="C:\Program Files\SASHome\SASFoundation\9.4\sas.exe" -CONFIG "C:\Program Files\SASHome\SASFoundation\9.4\nls\en\sasv9.cfg"

REM: Open a fresh SAS session and execute the program
%sas% -sysin "%~d1%~p1%pgm%" -log "%LogFolder%\%pgm%.log" -print "%LstFolder%\%pgm%.lst" -icon -nosplash -rsasuser

REM: END OF BATCH SCRIPT
exit
