# A BATCH SCRIPT TO RUN A MULTIPLE PROGRAMS
# BATCH SCRIPT SHOULD BE SAVED IN THE SAME FOLDER AS THE SAS PROGRAMS

# Retrieve the name of the current location
$PgmPath = (gl).path
gv pgmpath

# Check to see if log and lst folders exist
# If they do not exist then create them
$logdir = "$PgmPath\Log"
if ( -Not (Test-Path $logdir.trim() ))
{
 New-Item -Path $logdir -ItemType Directory
}

# Purposely used $((get-location).path) instead of $PgmPath to show can do all in one line
$lstdir = "$((get-location).path)\Lst"
if ( -Not (Test-Path $lstdir.trim() ))
{
 New-Item -Path $lstdir -ItemType Directory
}

# Set the location and configuration file for SAS
$sasexe = "C:\Program Files\SASHome\SASFoundation\9.4\sas.exe" 
$sascfg = "C:\Program Files\SASHome\SASFoundation\9.4\nls\en\sasv9.cfg"


$sasfiles = $(Get-ChildItem -Path $PgmPath -Filter *.sas)

ForEach ($file in $sasfiles) {
   $saspgm = $File.basename
   $saspgmex = $File.Name

   # Assign the full path (i.e., includes file name) for the log and lst
   $LogPath = "$($logdir)\$saspgm.log"
   $LstPath = "$($lstdir)\$saspgm.lst"

   # Execute the SAS program and write log and lst to appropriate folder
   # Out-Null forces PowerShell to wait till it is complete
   Write-Host "EXECUTING PROGRAM: " $File
   $sasProgram = "$PgmPath\$saspgmex"
   & "$sasexe" "$sasProgram" -NOLOGO -RSASUSER -CONFIG "$sascfg" -LOG "$logpath" -PRINT "$lstpath" | Out-Null
}

exit
