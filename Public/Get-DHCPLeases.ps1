function Get-DHCPLeases
{
    [CmdLetBinding()]
    param
    (
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [alias("ip", "cn")]
        $Server,

        [Parameter(
            Position = 1,
            Mandatory = $true
        )]
        [alias("cred")]
        $Credentials,

        [Parameter(
            Position = 2,
            Mandatory = $false
        )]
        [alias("ex")]
        [string[]]$Excludes = @(),

        [Parameter(
            Mandatory = $false
        )]
        [alias("file", "path", "dhcpd")]
        $LeaseFile = "/var/lib/dhcp/dhcpd.leases", ## Default

        [Parameter(
            Mandatory = $false
        )]
        [alias("all", "allow")]
        [switch]$AllowOldLeases,

        [Parameter(
            Mandatory = $false
        )]
        [switch]$Raw
    )

    begin
    {
        Import-Module Posh-SSH -ErrorAction Stop -Verbose:$false
    }

    process
    {
        $Session = New-SSHSession -ComputerName $Server -Credential $Credentials -AcceptKey
        $Output = Invoke-SSHCommand -SSHSession $Session -Command "cat $LeaseFile"
        $Output = $Output.Output

        ## Output the raw text from the lease file and exit
        if ($Raw -eq $true)
        {
            return $Output
        }

        $CurrentDate = Get-Date                                 ## Current date
        $ObjCollection = @()                                    ## For collecting all of the leases
        $Matches = [regex]::Matches($Output, 'lease(.*?)\}')    ## Detecting individual leases from the file
        
        foreach ($Match in $Matches)
        {
            ## Replace three spaces with a newline. Todo: find a better sollution?
            $Value = $Match.Value -replace "   ", "`r`n"
            
            ## Filter out excludes and junk-data
            $Excludes += "leases(5)"
            $Excludes | foreach {
                if ($Value -like "*$PSItem*")
                {
                    Write-Verbose "Skipped a lease because it contained: $PSItem."
                    continue
                }
            }

            ## Get the values we need from the current lease in the loop
            $Value -split "`r`n" | foreach {
                switch -Wildcard ($PSItem)
                {
                    "client-hostname*"
                    {
                        $Hostname = $PSItem.Split()[1] -replace '"', "" -replace ";", ""
                    }
                    "hardware ethernet*"
                    {
                        $MacAddress = $PSItem.Split()[2] -replace ";", ""
                    }
                    "lease*"
                    {
                        $IPAddress = $PSItem.Split()[1] -replace "{", ""
                    }
                    "starts*"
                    {
                        $Split = $PSItem.Split()
                        $Date = $Split[2]
                        $Time = $Split[3] -replace ";", ""
                        $LeaseStart = Get-Date "$Date/$Time"
                    }
                    "ends*"
                    {
                        $Split = $PSItem.Split()
                        $Date = $Split[2]
                        $Time = $Split[3] -replace ";", ""
                        $LeaseEnd = Get-Date "$Date/$Time"
                    }
                }
            }

            ## Filter out old leases if $AllowOldLeases is not set
            if( ($LeaseEnd -lt $CurrentDate) -and ($AllowOldLeases -eq $false) )
            {
                Write-Verbose "Skipped a lease because it was old: $LeaseEnd --- $CurrentDate"
                continue
            }

            ## Object for collecting all of the information from leases
            $LeaseObj = [PSCustomObject]@{
                IPAddress = $IPAddress
                LeaseStart = $LeaseStart
                LeaseEnd = $LeaseEnd
                MacAddress = $MacAddress
                Hostname = $Hostname
            }
            $ObjCollection += $LeaseObj
        }
        $ObjCollection
    }

    end
    {
        Remove-SSHSession -SSHSession $Session
    }
}

# Example:
# $lease = Get-DHCPLeases -Server 172.18.0.10 -Credentials (Get-Credential -Credential "ikt-fag\Petter") -Excludes "00:50:56:b4:63:5a" -Verbose
$lease = Get-DHCPLeases -ip 172.18.0.10 -cred (Get-Credential) -raw
$lease
