function Get-DHCPScope
{
    [CmdletBinding()]
    param
    (
        [Parameter(
            Position = 0,
            Mandatory = $True
        )]
        [Alias("ComputerName", "cn")]
        $Session,

        [Parameter(
            Mandatory = $False
        )]
        $Scope, ## Not yet implemented

        [Parameter(
            Position = 2,
            Mandatory = $False
        )]
        $ConfigFile = "/etc/dhcp/dhcpd.conf",

        [Parameter(
            Mandatory = $False
        )]
        [switch]$Raw
    )

    begin
    {
        Import-Module Posh-SSH -ErrorAction Stop -Verbose:$False

        ## For testing:
        #. "C:\Users\Petter\Documents\GitHub\ISC-DHCP-Manager\Private\Get-StringBetween.ps1"
        #. "C:\Users\Petter\Documents\GitHub\ISC-DHCP-Manager\Private\Remove-Comments.ps1"
        #. "C:\Users\Petter\Documents\GitHub\ISC-DHCP-Manager\Private\Remove-Whitespace.ps1"
    }

    process
    {
        if (-not($Session.Connected))
        {
            throw "You are not connected to a server!"
        }
        $Output = Invoke-SSHCommand -SSHSession $Session -Command "cat $ConfigFile"
        $Output = $Output.Output

        ## Output the raw output from the config file and exit
        if ($Raw -eq $true)
        {
            return $Output
        }

        ## Collection of objects to return at the end
        $ObjCollection = @()
        ## Regex match everything between 'subnet ' and '}'
        $MatchSubnet = Get-StringBetween -String $Output -Start 'subnet ' -End '}'
        ## Replace either two or more spaces, or tabs with newlines.
        $MatchSubnet = Remove-Whitespace -String ($MatchSubnet.Value)

        ##Loop through the matches we got
        foreach ($Scope in $MatchSubnet)
        {
            ## Split the Scope by newline and loop through
            $Scope -split "`r`n" | foreach {

                ## Split the $Scope into lines and strip away bad characters
                $Split = $PSItem.Split() `
                    -replace ';', '' `
                    -replace '}', '' `
                    -replace '{', '' `
                    -replace ',', '' `
                    -replace '"', ''

                ## Start getting the values that we need.
                ## TODO: Maybe add this to some data-file?
                switch -Wildcard ($PSItem)
                {
                    "subnet *"
                    {
                        $Subnet = $Split[1]
                        $Netmask = $Split[3]
                    }
                    "option routers *"
                    {
                        $Gateway = $Split[2]
                    }
                    "option broadcast-address *"
                    {
                        $Broadcast = $Split[2]
                    }
                    "option domain-name-servers *"
                    {
                        $DNS = @()
                        $DNS += $Split[2]
                        $DNS += $Split[3]
                        $DNS += $Split[4]
                    }
                    "option domain-name *"
                    {
                        $DomainName = $Split[2]
                    }
                    "range *"
                    {
                        $StartRange = $Split[1]
                        $EndRange = $Split[2]
                    }
                    "next-server *"
                    {
                        $NextServer = $Split[1]
                    }
                    "filename *"
                    {
                        $Filename = $Split[1]
                    }
                    "option bootfile-name *"
                    {
                        $BootfileName = $Split[2]
                    }
                }
            }

            ## Object for scopes
            $ScopeObj = [PSCustomObject]@{
                Subnet = $Subnet
                Netmask = $Netmask
                Gateway = $Gateway
                Broadcast = $Broadcast
                StartRange = $StartRange
                EndRange = $EndRange
                DomainName = $DomainName
                DNS = $DNS
                NextServer = $NextServer
                Filename = $Filename
                BootfileName = $BootfileName
            }
            $ObjCollection += $ScopeObj
        }

        $ObjCollection

    }
}
#$Session = Connect-DHCPServer -cn 172.18.0.10 -cred (Get-Credential -Credential "IKT-Fag\Petter")
#Get-DHCPScope -Session $Session
