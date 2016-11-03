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
        ## Different types of datasets to parse. This is important,
        ## because depending on what we set here, the parser will do
        ## different things.
        $ParseType
    )

    $DataFolder = (Split-Path -Path $PSScriptRoot -Parent) + "\Data"
    $DataFilePath = $DataFolder + "\$ParseType" + ".psd1"
    if (-not(Test-Path $DataFilePath -PathType Leaf))
    {
        throw "Not a valid file -- $DataFile"
    }

    $DataFile = Import-PowerShellDataFile -Path $DataFilePath
    [PSCustomObject]$DataFile
}

Parse-String -String "test" -ParseType Leases
