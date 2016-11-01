function Get-DHCPScope
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
            Mandatory = $False
        )]
        $Scope,

        [Parameter(
            Mandatory = $False
        )]
        $ConfigFile = "/etc/dhcp/dhcpd.conf",

        [Parameter(
            Mandatory = $False
        )]
        $Raw,

        [Parameter(
            Mandatory = $True
        )]
        [Alias("Cred", "Creds")]
        $Credentials
    )

    begin
    {
        #Import-Module Posh-SSH -ErrorAction Stop -Verbose:$False

        ## For testing:
        . "C:\Users\pette\Documents\GitHub\ISC-DHCP-Manager\Private\Remove-Comments.ps1"
        . "C:\Users\pette\Documents\GitHub\ISC-DHCP-Manager\Private\Get-StringBetween.ps1"
    }

    process
    {
        #$Session = New-SSHSession -ComputerName $Server -Credential $Credentials -AcceptKey
        #$Output = Invoke-SSHCommand -SSHSession $Session -Command "cat $ConfigFile"
        #$Output = $Output.Output

        ## For testing
        $Output = Remove-Comments -Path "C:\Users\pette\Documents\GitHub\ISC-DHCP-Manager\.TestFiles\dhcpd.conf" 

        ## Output the raw output from the config file and exit
        if ($Raw -eq $true)
        {
            return $Output
        }

        ## Regex match everything between 'subnet ' and '}'
        $MatchSubnet = Get-StringBetween -String $Output -Start 'subnet ' -End '}'
        $MatchSubnet

        ##Loop through the matches we got
        foreach ($Scope in $MatchSubnet)
        {
            ## Split the Scope by newline and loop through
            $Scope -split "`r`n" | foreach {

                ## Split the current line by spaces to get the values from it
                $Split = $PSItem -split ' '
                ## Start getting the values we need from each line
                ## TODO: Maybe add all of this to a data-file or something.
                switch -Wildcard ($Split)
                {
                    "subnet *"
                    {
                        $Subnet = $Split[1]
                        $Netmask = $Split[3]
                    }
                    "option routers *"
                    {
                        $Gateway = $Split[3]
                    }
                    "option broadcast-address *"
                    {
                        $Broadcast = $Split[2] -replace ';', ''
                    }
                    "option domain-name-servers *"
                    {
                        $DNSServers = @()
                        $DNSServers += $Split[]
                    }
                    "range *"
                    {
                        $StartRange = $Split[1]
                        $EndRange = $Split[2]
                    }
                    ""
                }
            }
        }
    }
}

Get-DHCPScope -Server 172.18.0.10 -Credentials test
