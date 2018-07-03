*Note: This project is currently under development*

# VMware-Stale-Snapshot-Finder
This is a module that can be used to find and optionally remove stale snapshots in VMware.

## Requirements
Note that this module relies on PowerCLI from VMware

## Installation
Manually:
1. Download a zip'd copy of the repo https://github.com/MaxAnderson95/VMware-Stale-Snapshot-Finder
2. Unzip the repo into one of your $env:psmodulepath directories

## Usage
First begin by connecting to a VMware host or vCenter installation
```Powershell
PS> Connect-VIServer -Server vcenter01 -Credential (Get-Credential)
```

Get a list of snapshots for all VMs on a connected server older than a specified date
```Powershell
PS> Get-VMStaleSnapshot -Date 6/21/2018

VM        Name                                   Created               Description
--        ----                                   -------               -----------
Server01  Snapshot before installing IIS         1/27/2018 11:23:18 AM
Server02  Snapshot before uninstalling .Net      6/20/2018 7:08:27 PM
DNS01     Before migrating scope to DNS02        5/28/2018 12:32:23 PM
```

Get a list of snapshots for specified VMs on a connected server older than a specified date
```Powershell
PS> Get-VMStaleSnapshot -VM "Server01","Server02" -Date 6/21/2018

VM        Name                                   Created               Description
--        ----                                   -------               -----------
Server01  Snapshot before installing IIS         1/27/2018 11:23:18 AM
Server02  Snapshot before uninstalling .Net      6/20/2018 7:08:27 PM
```

Get a list of snapshots for piped in VM objects on a connected server older than a specified date
```Powershell
PS> Get-VM -Name "Server*" | Get-VMStaleSnapshot -Date 6/21/2018

VM        Name                                   Created               Description
--        ----                                   -------               -----------
Server01  Snapshot before installing IIS         1/27/2018 11:23:18 AM
Server02  Snapshot before uninstalling .Net      6/20/2018 7:08:27 PM
```

Get a list of snapshots on a connected server older than a specified number of days
```Powershell
PS> Get-VMStaleSnapshot -Days 60

VM        Name                                   Created               Description
--        ----                                   -------               -----------
Server01  Snapshot before installing IIS         1/27/2018 11:23:18 AM
```