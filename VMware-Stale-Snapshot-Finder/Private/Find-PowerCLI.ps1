Function Find-PowerCLI {

    <#

        .SYNOPSIS
        Returns wether PowerCLI is installed

        .OUTPUTS
        System.Boolean

    #>

    [CmdletBinding()]

    #Get the module
    $PowerCLI = Get-Module -Name VMware.PowerCLI

    #If a module is found, return true, otherwise return false
    If ($PowerCLI -eq $Null) {
        
        Return $False

    }

    Else {

        Return $True
        
    }

}