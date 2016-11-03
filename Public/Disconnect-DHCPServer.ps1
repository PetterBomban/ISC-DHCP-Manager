function Disconnect-DHCPServer
{
    [CmdletBinding()]
    param
    (
        [Parameter(
            Position = 0,
            Mandatory = $True,
            ValueFromPipeline = $True
        )]
        [Alias("ssh")]
        $Session
    )

    Import-Module Posh-SSH -ErrorAction Stop -Verbose:$False
    
    Remove-SSHSession -SSHSession $Session
}
