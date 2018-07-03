Function Get-VMStaleSnapshot {

    [CmdletBinding()]
    Param (

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

        }
        
    }

    Process {

    }

    End {

    }

}