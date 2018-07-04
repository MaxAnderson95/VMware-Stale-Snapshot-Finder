Function Find-PowerCLI {

    <#

        .SYNOPSIS
        Returns wether PowerCLI is installed

        .OUTPUTS
        System.Boolean

    #>

    #Get the module
    Write-Verbose "Querying for the PowerCLI module to see if it is installed."
    $PowerCLI = Get-Module -Name VMware.PowerCLI -ListAvailable

    #If a module is found, return true, otherwise return false
    If ($PowerCLI -eq $Null) {
        
        Write-Verbose "PowerCLI module not installed on the system."
        Return $False

    }

    Else {

        Write-Verbose "PowerCLI module installed on the system."
        Return $True
        
    }

}