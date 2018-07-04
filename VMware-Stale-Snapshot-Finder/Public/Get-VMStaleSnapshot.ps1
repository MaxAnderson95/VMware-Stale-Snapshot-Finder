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

        #Check for the module
        If (Find-PowerCLI -eq $False) {

            Write-Error "PowerCLI module not found!"
            Break

        }

        #Import the module checking for any errors
        Try {

            If ((Get-Module -Name VMware.VimAutomation.Core) -eq $Null) {
            
                Import-Module -Name "VMware.VimAutomation.Core"

            }

        }
        Catch {

            Write-Error "There was an error importing the VMware.VimAutomation.Core module"
            Break

        }
        
    }

    Process {

        #Attempt to get the virtual machines
        Try {

            If ($VM) {

                $VirtualMachine = Get-VM -Name $VM

            }
            Else {

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
        $Snapshot = $VirtualMachine | Get-Snapshot | Select-Object VM, Name, Created, Description

        #Based on whether a date time object or a number of days is specified, get a list of snapshots and filter them
        Switch ($PSCmdlet.ParameterSetName) {

            'DateTimeObject' {

                $Snapshot = $Snapshot | Where-Object { $_.Created -lt $Date }
                
            }

            'Days' {

                $Snapshot = $Snapshot | Where-Object { $_.Created -lt (Get-Date).AddDays(-$Days) }

            }

        }

        #Output the snapshot objects to the screen
        Write-Output $Snapshot

    }

    End {

    }

}