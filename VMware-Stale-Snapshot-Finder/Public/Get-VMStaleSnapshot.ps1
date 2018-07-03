Function Get-VMStaleSnapshot {

    [CmdletBinding()]
    Param (

        [Parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
        $VM

    )

    Begin {

        $WarningPreference = "SilentlyContinue"

        #Check for the module
        If (Find-PowerCLI -eq $True) {

            Write-Verbose "PowerCLI module found"

        }
        Else {

            Write-Error "PowerCLI module not found!"
            Break

        }

        #Import the module checking for any errors
        Try {

            Import-Module -Name "VMware.VimAutomation.Core"

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

            Write-Error "Not connected to a server!"
            Break

        }
        #Present the error message in any other case
        Catch {

            Write-Error $_
            Break

        }

        #Get snapshots for each virtual machine that are older than the specified number of days
        $VirtualMachine | Get-Snapshot | Select-Object VM, Name, Created, Description

    }

    End {

    }

}