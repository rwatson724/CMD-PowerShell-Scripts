# A BATCH SCRIPT TO RUN A SINGLE PROGRAM USING DRAG-AND-DROP

$File = $args[0]
$PgmPath = (gl).path
$PgmName = (gi $File).basename

# Check to see if log and lst folders exist
# If they do not exist then create them
$logdir = "$PgmPath\Logs"
if ( -Not (Test-Path $logdir.trim() ))
{
 New-Item -Path $logdir -ItemType Directory
}

$lstdir = "$PgmPath\Lsts"
if ( -Not (Test-Path $lstdir.trim() ))
{
 New-Item -Path $lstdir -ItemType Directory
}

# Assign the full path (i.e., includes file name) for the log and lst
$LogPath = "$($logdir)\$PgmName.log"
$LstPath = "$($lstdir)\$PgmName.lst"

# Set the location and configuration file for SAS
$sasexe = "C:\Program Files\SASHome\SASFoundation\9.4\sas.exe" 
$sascfg = "C:\Program Files\SASHome\SASFoundation\9.4\nls\en\sasv9.cfg"

# Execute the SAS program and write log and lst to appropriate folder
# Out-Null forces PowerShell to wait till it is complete
Write-Host "EXECUTING PROGRAM: " $File
 & "$sasexe" "$File" -NOLOGO -RSASUSER -CONFIG "$sascfg" -LOG "$logpath" -PRINT "$lstpath" | Out-Null

exit