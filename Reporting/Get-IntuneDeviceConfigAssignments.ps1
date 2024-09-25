function Get-IntuneDeviceConfigAssignments {
    <#
.SYNOPSIS
    Developed to provide easier reporting and visibility into Intune assignments where Entra ID device groups are being used
.DESCRIPTION
    Developed to provide easier reporting and visibility into Intune assignments where Entra ID device groups are being used
.PARAMETER Identity
    Entra ID Group ID
.EXAMPLE
    Get-IntuneDeviceConfigAssignments -Identity
.NOTES
    Author: jethro@regenit.cloud
    Version: WIP
    Mandatory Dependencies: Graph
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][String]$Identity
    )
    $deviceConfigProfilesUri = 'https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations?$select=id,displayName'
    $deviceConfigProfiles = Invoke-MgGraphRequest -Method GET -Uri $deviceConfigProfilesUri -StatusCodeVariable StatusCode
    Write-Verbose -Message "Getting device configurations"
    ForEach ($configurationProfile in $deviceConfigProfiles.value) {
        $configurationId = $configurationProfile.id
        $configurationAssignmentsGraphUri = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/$($configurationId)"+'/assignments?$select=target'
        $configurationAssignmentsTarget = Invoke-MgGraphRequest -Method GET -Uri $configurationAssignmentsGraphUri -StatusCodeVariable StatusCode
        If ($configurationAssignmentsTarget.value.target.groupId -match $Identity) {
            "$($configurationProfile.displayName)"
        }
    }
}
