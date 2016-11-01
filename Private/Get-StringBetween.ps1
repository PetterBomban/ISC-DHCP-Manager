function Get-StringBetween
{
    param
    (
        [Parameter(
            Mandatory = $True
        )]
        $String,

        [Parameter(
            Mandatory = $True
        )]
        $Start,

        [Parameter(
            Mandatory = $True
        )]
        $End
    )

    ## Add escape character required by regex for '{' and '}' .
    if ($Start -like '*{*')
    {
        $Start = $Start -replace '{', '\{'
    }
    if ($End -like '*}*')
    {
        $End = $End -replace '}', '\}'
    }

    ## Match everything between $Start and $End.
    ## TODO:This fails horribly if we do this on for example
    ##      dhcpd.conf, and it contains pool {...}. Fix somehow
    $Regex = "(?is)($Start).*?(?=$End)"
    $MatchSubnet = [regex]::Matches($String, $Regex)

    ## Return value(s) that was/were found.
    $MatchSubnet
}
