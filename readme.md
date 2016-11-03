# ISC-DHCP-Manager

This is very much a work in progress, but the end-goal is to be able to manage an ISC-DHCP-Server completely via PowerShell.

## Currently Working
* Get-DHCPLeases
* Get-DHCPScope
* Connect-DHCPServer
* Disconnect-DHCPServer

## Currently Working On
* Dedicated parser
* New-DHCPScope

## Planned
* Remove-DHCPScope
* Add-DHCPScopeOptions
* Remove-DHCPScopeOptions
* Restart-DHCPServer
* Stop-DHCPServer
* Start-DHCPServer
* ...

## Tested On/With
* Ubuntu Server 16.04.1 LTS
* isc-dhcp-server 4.3.3-5ubuntu12.3
* Windows 10 Enterprise

## Requirements
* [Posh-SSH](https://github.com/darkoperator/Posh-SSH)
* Ubuntu Server + isc-dhcp-server
* PowerShell version 5.0
