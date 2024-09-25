function Get-IntuneManagedAppConfigAssignments {
    <#
.SYNOPSIS
    Developed to provide easier reporting and visibility into Intune assignments where Entra ID device groups are being used
.DESCRIPTION
    Developed to provide easier reporting and visibility into Intune assignments where Entra ID device groups are being used
.PARAMETER Identity
    Entra ID Group ID
.EXAMPLE
    Get-IntuneManagedAppConfigAssignments -Identity
.NOTES
    Author: jethro@regenit.cloud
    Version: 1.0
    Mandatory Dependencies: Graph
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][String]$Identity
    )
    $managedAppConfigsUri = 'https://graph.microsoft.com/beta/deviceAppManagement/mobileAppConfigurations?$select=displayName,id,targetedMobileApps'
    $appConfigs = Invoke-MgGraphRequest -Method GET -Uri $managedAppConfigsUri -StatusCodeVariable StatusCode
    Write-Verbose -Message "Getting device configurations"
    ForEach ($appConfig in $appConfigs.value) {
        $appConfigId = $appConfig.id
        $appConfigAssignmentsUri = "https://graph.microsoft.com/v1.0/deviceAppManagement/mobileAppConfigurations/$($appConfigId)"+'/assignments?$select=target'
        $appConfigAssignmentsTarget = Invoke-MgGraphRequest -Method GET -Uri $appConfigAssignmentsUri
        If ($appConfigAssignmentsTarget.value.target.groupId -match $Identity) {
            $appConfig.displayName
        }
    }
}
