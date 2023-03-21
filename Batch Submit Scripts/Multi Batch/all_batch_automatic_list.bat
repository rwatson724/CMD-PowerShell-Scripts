@ECHO OFF
CLS
REM: A BATCH SCRIPT TO RUN ALL PROGRAMS
REM: BATCH SCRIPT IS STORED IN SAME LOCATION AS THE PROGRAMS
REM: NO PARAMETERS ARE REQUIRED

REM: Check to see if log and lst folders are existing as subfolder
REM: Location of where logs and lst files should be stored
REM: Typically subfolder of current directory
if exist "%CD%\Logs" (set plog=-log %CD%\Logs) else (
  mkdir Logs
  set plog=-log %CD%\Logs
)

if exist "%CD%\Lsts"(set plst=-print %CD%\LstFolder) else (
  mkdir Lsts
  set plst=-print %CD%\Lsts
)

REM: Location and configuration file for SAS program
set sas="C:\Program Files\SASHome\SASFoundation\9.4\sas.exe" -CONFIG "C:\Program Files\SASHome\SASFoundation\9.4\nls\en\sasv9.cfg"

REM: Loop through the current folder looking for any file with '.sas' extension and execute the program
for %%I in (DIR "%CD%\*.sas" /B) DO (
if exist %%I  (%sas% -sysin "%%I" %plog% %plst%)
)

REM: END OF BATCH SCRIPT

exit
