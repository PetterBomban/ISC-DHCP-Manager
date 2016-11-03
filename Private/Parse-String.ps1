function Parse-String
{
    [CmdletBinding()]
    param
    (
        [Parameter(
            Mandatory = $True
        )]
        $String,

        [Parameter(
            Mandatory = $True
        )]
        [ValidateSet(
            "Scope",
            "Leases"
        )]
        $ParseType
    )

    $DataFolder = (Split-Path -Path $PSScriptRoot -Parent) + "\Data"
    $DataFilePath = $DataFolder + "\$ParseType" + ".psd1"
    if (-not(Test-Path $DataFilePath -PathType Leaf))
    {
        throw "Not a valid file -- $DataFile"
    }

    ## Import .psd1-file and cast it to an object
    $DataFile = Import-PowerShellDataFile -Path $DataFilePath
    $Datafile = [PSCustomObject]$DataFile

    ## We need to do slightly different things, depending on waht kind of 
    ## ParseType we get.
    switch ($ParseType)
    {
        "Scope" { Parse-Scope -String $String -DataFile $DataFile; break }
        "Leases" { Parse-Leases -String $String -DataFile $DataFile; break }
    }
}

Parse-String -String "test" -ParseType Leases
