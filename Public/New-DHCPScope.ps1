Function New-DHCPScope.ps1
{
    [CmdletBinding()]
    param
    (
        [Parameter(
            Mandatory = $True
        )]
        [Alias("ComputerName", "cn")]
        $Server,

        [Parameter(
            Mandatory = $True
        )]
        $Subnet,

        [Parameter(
            Mandatory = $True
        )]
        [Alias("Mask")]
        $Netmask,

        [Parameter(
            Mandatory = $True
        )]
        [Alias("Cred", "Creds")]
        $Credentials
    )

    begin
    {
        Import-Module Posh-SSH -ErrorAction Stop -Verbose:$False
    }

    process
    {
        #$Session = New-SSHSession -ComputerName $Server -Credential $Credentials -AcceptKey
         $Output
    }
}