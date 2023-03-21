# Batch Submit Scripts
This includes scripts to execute a single program in batch as well as execute multiple programs in batch.

It includes techniques using CMD and using PowerShell.  For these scripts, you will need to make sure that the they are pointing to the correct location of the SAS config file.

# Single Batch
CMD: Th scripts use the location of where they are being executed from, so there is no need to edit the file unless the SAS config files are stored in a different location than what is specified in the script.

PowerShell: this is using a drag and drop technique, where the SAS program is dragged and dropped onto the BAT file that sends in the file name to the PS1 script.  The BAT file that is used with the PS1 file is "Batch_for_PS_DD_Script.bat".  Within the BAT file, you need to edit it so that it points to the location where the PS1 script is saved.

# Single Batch with Right-Click Menu
CMD: The BAT file is the same BAT as "drag_and_drop_batch.bat" found in "Single Batch".  It was just renamed to illustrate the adding an item to the registry to create a right-click menu item.  If you choose to use the "drag_and_drop_batch.bat", then the "Create-SAS Single Batch.reg" needs to be edited to reference the correct BAT file.

PowerShell: It uses the "PowerShell_Drag_and_Drop.ps1" found in "Single Batch". Also copied to "Single Batch with Right-Click Menu" for convenience.
