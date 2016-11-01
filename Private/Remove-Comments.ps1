function Remove-Comments
{
    param
    (
        [Parameter(
            Mandatory = $True,
            ParameterSetName = "String"
        )]
        $String,

        [Parameter(
            Mandatory = $True,
            ParameterSetName = "File"
        )]
        $Path
    )

    ## Get content as raw string if $Path is set
    if($Path) { $String = Get-Content -Path $Path -Raw }

    ## Output a string without comments (#)
    $String -replace '#.*'
}
