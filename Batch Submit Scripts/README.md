# Batch Submit Scripts
This includes scripts to execute a single program in batch as well as execute multiple programs in batch.

It includes techniques using CMD and using PowerShell.

For CMD scripts, they are driven off the location of where they are being executed from.

For PowerShell script, this is using a drag and drop technique, where the SAS program is dragged and dropped onto the BAT file that sends in the file name to the PS1 script.  The BAT file that is used with the PS1 file is "Batch_for_PS_DD_Script.bat".  Within the BAT file, you need to edit it so that it points to the location where the PS1 script is saved.
