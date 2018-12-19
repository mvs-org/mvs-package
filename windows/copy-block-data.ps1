
# run powershell as administrator
# set-executionpolicy remotesigned
#

$AppDataDir="$env:appdata"
$MetaverseDir=$AppDataDir + "\Metaverse"
if ($args[0]) {
    $MetaverseDir=$args[0]
}

$MainnetDir=$MetaverseDir + "\mainnet"
$AccountBakDir=$MetaverseDir + "\account_bak"
$DatabaseZipFile = $PSScriptRoot + "\mainnet.zip"

function CopyAccountInformation($SrcDir,$DstDir) 
{
    $fileNames = "account_address_rows","account_address_table","account_asset_row","account_asset_table","account_table"
    $fileNames | foreach {
        $Src=$SrcDir + "\" + $_
        $Dst=$DstDir + "\" + $_

        if (Test-Path $Src -pathType leaf) {
            echo "Copy $Src to $Dst"
            Copy-Item $Src $Dst
        }
    }
}

function PressKeyToExit()
{
    Write-Host "Press any key to exit!" -NoNewline
    $null = [Console]::Read()
}

if (-not (Test-Path $DatabaseZipFile)) {
    echo "Error: Database file $MainnetZipFile does not exist!"
    PressKeyToExit
}
else {
    if (Test-Path $MetaverseDir) {
        if (Test-Path $MainnetDir) {
            echo "Backup account information."
            if (-not (Test-Path $AccountBakDir)) {
                echo "Create $AccountBakDir"
                mkdir $AccountBakDir
            }

            CopyAccountInformation $MainnetDir $AccountBakDir

            # Delete mainnet
            Remove-Item $MainnetDir -Recurse -Force
        }
    }
    else {
        echo "Create $MetaverseDir"
        mkdir $MetaverseDir
    }

    # Unzip file to $MetaverseDir
    echo "Unzip to $MetaverseDir"
    Expand-Archive $DatabaseZipFile -DestinationPath $MetaverseDir

    # Restore account information
    if (Test-Path $AccountBakDir) {
        echo "Restore account information."
        CopyAccountInformation $AccountBakDir $MainnetDir
    }

    echo ""
    echo ">> Upgrade database Success!"

    # Exit
    PressKeyToExit
}