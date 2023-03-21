@echo off
cls

REM: Parse out the date into components so it can be put together in the proper format
set dy=%date:~7,2%
set mo=%date:~4,2%
set yr=%date:~10,4%
set today=%yr%-%mo%-%dy%
set runday=%today%

REM: Set parameters for the Received folder
set rcvd=%CD%\Received

set __today=%today%
for /F "delims=|" %%I in ('DIR "%rcvd%\*%__today%*.zip" /B /O:-D') DO (
set rcvdfile=%%I
goto FoundFile
)

REM: Check to see if a file was found. If so proceed to next step otherwise check next date pattern.
REM: if defined rcvdfile (goto FoundFile)

set __today=%yr%_%mo%_%dy%
for /F "delims=|" %%I in ('DIR "%rcvd%\*%__today%*.zip" /B /O:-D') DO (
set rcvdfile=%%I
goto FoundFile
)

REM: Check to see if a file was found. If so proceed to next step otherwise check next date pattern.
REM: if defined rcvdfile (goto FoundFile)

set __today=%yr%%mo%%dy%
for /F "delims=|" %%I in ('DIR "%rcvd%\*%__today%*.zip" /B /O:-D') DO (
set rcvdfile=%%I
goto FoundFile
)

REM: Check to see if a file was found. If so proceed to next step otherwise check for newest file.
REM: if defined rcvdfile (goto FoundFile)

REM: Retrieve the latest file. Once found get out and go to FMTDate
for /F "delims=|" %%I in ('DIR "%rcvd%\*.zip" /A:-D /B /O:-D /T:C') DO (
set rcvdfile=%%I 
goto FMTDate
)

REM: If using the latest file need to put the file name in quotes in case there are spaces
:FMTDate
set __rcvdfile="%rcvdfile%"

REM: If there is a file found, then retrieve date and use that to create folder
REM: File date is saved in a temporary file so that the date can be extracted and formatted
if defined __rcvdfile (
forfiles /P "%rcvd%" /M %__rcvdfile% /C "cmd /c echo @fdate" > __TEMPTEXT.TXT
for /F "tokens=1" %%A in (__TEMPTEXT.TXT) DO set fdate=%%A 
)

REM: If a file date is extracted, then need to break it into day, month and year components
if defined fdate (
for /F "tokens=1,2,3 delims=/" %%A in ("%fdate%") do (
   set dy=%%B
   set mo=%%A
   set yr=%%C
)
)

REM: Need to make sure that the day and month components are two digits
if %dy% LSS 10 set dy=0%dy%
if %mo% LSS 10 set mo=0%mo%

REM: Need to make sure there are no trailing spaces for year
set yr=%yr:~0,4%

set today=%yr%-%mo%-%dy%

REM: Delete the temporary file that contained the date of the latest file
del __TEMPTEXT.TXT

if defined rcvdfile (goto FoundFile) else goto NoFile

REM: If a file is found then list name of file and proceed to see if a dated folder already exists
:FoundFile
echo ZIP file is %rcvdfile% > "%CD%\unzip_%runday%.txt"

REM: Determine if there is a folder with indicated date that already exists
set fldr=%today%
if exist %fldr% goto :FolderExists

REM: If Folder does not exist make the folder
mkdir __TEMP
mkdir %today%
echo - %today% folder was created >> "%CD%\unzip_%runday%.txt"

@echo off
setlocal

call :UnZipFile "%CD%\__TEMP\" "%rcvd%\%rcvdfile%"
echo - SAS data sets have been extracted from %rcvd%\%rcvdfile% >> "%CD%\unzip_%runday%.txt"
exit /b

REM: Create a Subroutine using VBScript for Powershell to unzip files
:UnZipFile <ExtractTo> <newzipfile>
set vbs="%temp%\_.vbs"
if exist %vbs% del /f /q %vbs%
( echo strExtractTo = WScript.Arguments.Item(0^)
  echo strNewZipFile = WScript.Arguments.Item(1^)
  echo WScript.echo strExtractTo, strNewZipFile
  echo set objFSO = CreateObject("Scripting.FileSystemObject"^)
  echo set objShell = CreateObject("Shell.Application"^)
  echo set FilesInZip = objShell.NameSpace(strNewZipFile^).items
  echo objShell.NameSpace(strExtractTo^).CopyHere(FilesInZip^)
  echo set objFSO = Nothing
  echo set objshell = Nothing
) > %vbs%

for %%A in ("%~2") do cscript //nologo //B "%vbs%" "%~1" "%%~A"
if exist "%vbs%" del /f /q "%vbs%"

REM: Move only the SAS7BDAT files to the final location - search all folders and subfolders in the zipped file
for /R "%CD%\__TEMP\" %%A in (*.sas7bdat) do move "%%A" "%CD%\%today%\"

REM: Delete the temporary folder and all its files (/s deletes files and subfolders) without confirmation (/q)
rmdir /s /q "%CD%\__TEMP\"

goto Done

REM: If Folder does exist, go to the end
:FolderExists
echo - This folder %today% already exists within %CD% > "%CD%\unzip_%runday%.txt"
echo - Either confirm received file is already unzipped or delete the folder >> "%CD%\unzip_%runday%.txt"
goto Done

REM: If no file is found, stop
:NoFile
echo - There is no zipped file in the Received folder > "%CD%\unzip_%runday%.txt"
goto Done

:Done