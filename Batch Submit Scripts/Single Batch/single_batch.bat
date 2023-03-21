@ECHO OFF
CLS
REM: A BATCH SCRIPT TO RUN A SINGLE PROGRAM
REM: BATCH SCRIPT IS STORED IN SAME LOCATION AS THE PROGRAMS
REM: ONE INPUT PARAMETER IS REQUIRED

REM: Location and configuration file for SAS program
set sas="C:\Program Files\SASHome\SASFoundation\9.4\sas.exe" -CONFIG "C:\Program Files\SASHome\SASFoundation\9.4\nls\en\sasv9.cfg"

REM: Location of where logs and lst files should be stored
REM: Typically subfolder of current directory
set plog=-log "%CD%\Logs\"
set plst=-print "%CD%\Lsts\"

REM: Prompt to enter all or a portion of the file name to be executed
REM: Would like to find a way to make this data-driven so that if you right click on the file you can select an option to batch submit with this script
set pgm=
set /p pgm="Name of Program to be Executed - must be a complete name:  "

%sas% -sysin "%CD%\%pgm%.sas" %plog% %plst%

REM: END OF BATCH SCRIPT
exit
