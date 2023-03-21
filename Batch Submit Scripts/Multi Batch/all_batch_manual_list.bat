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

REM: Specify a call for each program to be executed
REM: Program calls should be listed in order in which they should be run

%sas% -sysin "%CD%\ANYNOT Functions.sas" %plog% %plst%
%sas% -sysin "%CD%\CALL SORTC Routine.sas" %plog% %plst%
%sas% -sysin "%CD%\CATQ Function.sas" %plog% %plst%
%sas% -sysin "%CD%\COALESCE Functions.sas" %plog% %plst%
%sas% -sysin "%CD%\COMPRESS Functions.sas" %plog% %plst%
%sas% -sysin "%CD%\COUNT Functions.sas" %plog% %plst%
%sas% -sysin "%CD%\DATE and TIME Functions.sas" %plog% %plst%
%sas% -sysin "%CD%\FIND Functions.sas" %plog% %plst%
%sas% -sysin "%CD%\FIRST, REVERSE Functions and PROC FCMP.sas" %plog% %plst%
%sas% -sysin "%CD%\INDEX Functions.sas" %plog% %plst%
%sas% -sysin "%CD%\MISSING Routine and Functions.sas" %plog% %plst%
%sas% -sysin "%CD%\PATHNAME Function.sas" %plog% %plst%
%sas% -sysin "%CD%\PRX Functions.sas" %plog% %plst%
%sas% -sysin "%CD%\RESOLVE Function.sas" %plog% %plst%
%sas% -sysin "%CD%\SCAN Functions.sas" %plog% %plst%
%sas% -sysin "%CD%\TRANSLATE Functions.sas" %plog% %plst%
%sas% -sysin "%CD%\V Functions.sas" %plog% %plst%

REM: END OF BATCH SCRIPT
exit
