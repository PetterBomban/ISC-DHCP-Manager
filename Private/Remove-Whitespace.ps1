function Remove-Whitespace
{
    param
    (
        [Parameter(
            Mandatory = $True
        )]
        $String
    )

    ## Replace either two or more spaces, or tabs with newlines.
    $String -replace '\ {2,}|\t', "`r`n"
}