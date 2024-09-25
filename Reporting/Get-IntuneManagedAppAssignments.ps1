function Get-IntuneManagedAppAssignments {
    <#
.SYNOPSIS
    Developed to provide easier reporting and visibility into Intune assignments where Entra ID device groups are being used
.DESCRIPTION
    Developed to provide easier reporting and visibility into Intune assignments where Entra ID device groups are being used
.PARAMETER Identity
    Entra ID Group ID
.EXAMPLE
    Get-IntuneManagedAppAssignments -Identity
.NOTES
    Author: jethro@regenit.cloud
    Version: WIP
    Mandatory Dependencies: Graph
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][String]$Identity
    )
    $managedAppsUri = 'https://graph.microsoft.com/beta/deviceAppManagement/mobileApps?$filter=(microsoft.graph.managedApp/appAvailability eq null)&$select=displayName,publisher,id,isAssigned'
    $managedApps = Invoke-MgGraphRequest -Method GET -Uri $managedAppsUri -StatusCodeVariable StatusCode
    Write-Verbose -Message "Getting device configurations"
    ForEach ($app in $managedApps.value) {
        $appId = $app.id
        $appAssignmentsUri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$($appId)"+'/assignments?$select=target'
        $appAssignmentsTarget = Invoke-MgGraphRequest -Method GET -Uri $appAssignmentsUri -StatusCodeVariable StatusCode
        If ($appAssignmentsTarget.value.target.groupId -match $Identity) {
            "$($app.publisher) - $($app.displayName)"
        }
    }
}
