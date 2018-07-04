Function Get-VMStaleSnapshot {

    [CmdletBinding()]
    Param (

        [Parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True,ParameterSetName='DateTimeObject')]
        [Parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True,ParameterSetName='Days')]
        [Object[]]$VM,

        [Parameter(Mandatory=$True,ParameterSetName='DateTimeObject')]
        [DateTime]$Date,

        [Parameter(Mandatory=$True,ParameterSetName='Days')]
        [Int]$Days

    )

    Begin {

        $WarningPreference = "SilentlyContinue"

        Find-PowerCLI

        #Check for the module
        If (Find-PowerCLI -eq $True) {

        }
        Else {

            Write-Error "PowerCLI module not found!"
            Break

        }

        #Import the module checking for any errors
        Try {

            If ((Get-Module -Name VMware.VimAutomation.Core) -eq $Null) {

                Write-Verbose "Attempting to import the module"
                Import-Module -Name "VMware.VimAutomation.Core"

            }

        }
        Catch {

            Write-Verbose "Attempting to import the module"
            Write-Error "There was an error importing the VMware.VimAutomation.Core module"
            Break

        }
        
    }

    Process {

        #Attempt to get the virtual machines
        Try {

            If ($VM) {

                Write-Verbose "Getting a list of virtual machines from user input."
                $VirtualMachine = Get-VM -Name $VM

            }
            Else {

                Write-Verbose "Getting a list of all virtual machines."
                $VirtualMachine = Get-VM

            }
    
        }
        #If it fails because the session isn't connected to a server, present a specific error message
        Catch [VMware.VimAutomation.Sdk.Types.V1.ErrorHandling.VimException.ViServerConnectionException]{

            Write-Error "Not connected to a server! Use 'Connect-VIServer' to connect to a VMware host or vCenter installation."
            Break

        }
        #Present the error message in any other case
        Catch {

            Write-Error $_
            Break

        }

        #Get snapshots for each virtual machine
        Write-Verbose "Getting a list of snapshots from the list of VMs."
        $Snapshot = $VirtualMachine | Get-Snapshot | Select-Object VM, Name, Created, Description

        #Based on whether a date time object or a number of days is specified, get a list of snapshots and filter them
        Switch ($PSCmdlet.ParameterSetName) {

            'DateTimeObject' {

                Write-Verbose "Datetime object specified. Getting a list of snapshots and filtering them for snapshots taken before $Date"
                $Snapshot = $Snapshot | Where-Object { $_.Created -lt $Date }
                
            }

            'Days' {

                Write-Verbose "Number of days specified. Getting a list of snapshots and filtering them for snapshots taken more than $Days ago."
                $Snapshot = $Snapshot | Where-Object { $_.Created -lt (Get-Date).AddDays(-$Days) }

            }

        }

        #Output the snapshot objects to the screen
        Write-Output $Snapshot

    }

    End {

    }

}