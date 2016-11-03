function Connect-DHCPServer
{
    [CmdletBinding()]
    param
    (
        [Parameter(
            Position = 0,
            Mandatory = $True
        )]
        [Alias("Server", "cn")]
        $ComputerName,

        [Parameter(
            Position = 1,
            Mandatory = $True
        )]
        [Alias("Credentials", "cred")]
        $Credential
    )

    Import-Module Posh-SSH -ErrorAction Stop -Verbose:$False
    $Session = New-SSHSession -ComputerName $ComputerName -Credential $Credential -AcceptKey

    Write-Verbose "Connected to $ComputerName."

    $Session
}
