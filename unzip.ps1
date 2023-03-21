# Retrieve the current date and format as yyyy-MM-dd - NOTE that MM must be capitalized because mm represents minutes
$today_hyp = get-date -format "yyyy-MM-dd"
$today_noh = get-date -format "yyyyMMdd"
$today_uns = get-date -format "yyyy_MM_dd"

# Retrieve the name of the current location
$PgmPath = (gl).path
# gv pgmpath

# Check to see if received folder exist - if it exists then proceed
$rcvd = "$PgmPath\Received"
if ( Test-Path $rcvd.trim() )
{
    # Look for a zip file that has current date with hyphens in the file name, yyyy-MM-dd
    $rcvdfile = $(get-childitem -path $rcvd -filter *$today_hyp*.zip)

    # If zip file with current date with hypens is not found then look for one with current date and no hyphens, yyyyMMdd
    if ( -not($rcvdfile) )  {    $rcvdfile = $(get-childitem -path $rcvd -filter *$today_noh*.zip)    }

    # If zip file with current date with hypens or without hyphens is not found then look for one with current date and underscores, yyyy_MM_dd
    if ( -not($rcvdfile) )  {    $rcvdfile = $(get-childitem -path $rcvd -filter *$today_uns*.zip)    }

    # If zip file found with the current date in file name regardless of format set a fdate to the current date with hyphens
    # Otherwise if still no zip file with current date then look for most current zip file based on creation date
    if ( $rcvdfile ) { $fdate = $today_hyp }
    else {    $rcvdfile = gci -path $rcvd -filter *.zip | sort-object -property creationtime | select -last 1    }

    # If there is a file found, then retrieve date and use that to create folder
    # Write the name of the file to be unzipped to a file 
    if ( $rcvdfile )
    {  
        if ( -not($fdate) ) {   $fdate = $(gci $rcvd\$rcvdfile | select -expandproperty creationtime | get-date -f "yyyy-MM-dd")   }
        echo "ZIP file is $rcvdfile" | out-file $pgmpath\unzip_ps_$today_hyp.txt

        # Check to see if dated folder exist
        # If it does not exist then create it and unzip file and move SAS data sets to folder
        $uzdir = "$PgmPath\$fdate"
        if ( -Not (Test-Path $uzdir.trim() )) 
        {
            New-Item -Path $uzdir -ItemType Directory
            echo "- $uzdir folder was created" | out-file $pgmpath\unzip_ps_$today_hyp.txt -append

            # Create a temporary location to store all the files in the zipped file 
            ni -path $PgmPath\__TEMP -it directory

            # Unzip the entire file
            Expand-Archive $rcvd\$rcvdfile $PgmPath\__TEMP

            # Move only the SAS7BDAT files to the final location - search all folders and subfolders in the zipped file
            gci $PgmPath\__TEMP -recurse -include *.sas7bdat | move-item -dest $uzdir

            # Once SAS data sets are moved to final location delete the temporary folder
            remove-item $PgmPath\__TEMP -recurse -force

            echo "- SAS data sets have been extracted from $rcvdfile" | out-file $pgmpath\unzip_ps_$today_hyp.txt -append
        }
        else 
        {
            echo "This folder $fdate already exists within $PgmPath" | out-file $pgmpath\unzip_ps_$today_hyp.txt
            echo "Either confirm received file is already unzipped or delete the folder" | out-file $pgmpath\unzip_ps_$today_hyp.txt -append
        }
    }
    else
    {
        echo "There is no zipped file in the Received folder" | out-file $pgmpath\unzip_ps_$today_hyp.txt
    }
}

#exit