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


    
}
