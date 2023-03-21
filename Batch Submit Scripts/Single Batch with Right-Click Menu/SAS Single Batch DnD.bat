@ECHO OFF
CLS
REM: A BATCH SCRIPT TO RUN A SINGLE PROGRAM
REM: RUN FROM THE RIGHT-CLICK MENU

REM: Check to see if log and lst folders exist as subfolders
REM: If they do not exist then create them
if exist "%~d1%~p1\Logs" (set LogFolder=%~d1%~p1\Logs) else (
  mkdir Logs
  set LogFolder=%~d1%~p1\Logs
)

if exist "%~d1%~p1\Lsts" (set LstFolder=%~d1%~p1\LstFolder) else (
  mkdir Lsts
  set LstFolder=%~d1%~p1\Lsts
)

REM: Find the name of the current file (~nA) without the extension (if want extension use ~xA)
for %%A in (%*) do set pgm=%%~nA

REM: Location and configuration file for SAS program
set sas="C:\Program Files\SASHome\SASFoundation\9.4\sas.exe" -CONFIG "C:\Program Files\SASHome\SASFoundation\9.4\nls\en\sasv9.cfg"

ECHO DO NOT CLOSE WINDOW PROGRAM IS EXECUTING - WINDOW WILL CLOSE ON ITS OWN

REM: Open a fresh SAS session and execute the program
REM: Write log and lst files to appropriate folders rather than in the same folder as program
%sas% -sysin "%~d1%~p1%pgm%" -log "%LogFolder%\%pgm%.log" -print "%LstFolder%\%pgm%.lst" -icon -nosplash -rsasuser

REM: END OF BATCH SCRIPT
exit
