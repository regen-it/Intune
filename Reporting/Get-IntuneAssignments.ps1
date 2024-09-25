<#
.SYNOPSIS
    Controller script for getting Intune assignments
.DESCRIPTION
    Developed to provide easier reporting and visibility into Intune assignments where Entra ID device groups are being used
.PARAMETER EntraGroupId
    Entra ID Group ID
.NOTES
    Author: jethro@regenit.cloud
    Version: WIP
    Mandatory Dependencies: Graph and required permission scopes
    Relies on three Intune Reporting functions
    Testing with output for Eraser.io
#>

$outputTitle = "ADD TITLE"

$graphScopes = @(
    "Group.Read.All"
    "DeviceManagementConfiguration.Read.All"
    "DeviceManagementApps.Read.All"
)

Connect-MgGraph -Scopes $graphScopes
$entraGroup = Get-MgGroup -GroupId 'ADD ENTRA GROUP ID'

Write-Host "Device Config Assignments" -ForegroundColor Green
$deviceConfigAssignments = Get-IntuneDeviceConfigAssignments -Identity $entraGroup.id
$deviceConfigAssignments

Write-Host "App Assignments" -ForegroundColor Green
$appAssignments = Get-IntuneManagedAppAssignments -Identity $entraGroup.id
$appAssignments

Write-Host "App ConfigAssignments" -ForegroundColor Green
$appConfigAssignments = Get-IntuneManagedAppConfigAssignments -Identity $entraGroup.id
$appConfigAssignments

#eraser Ouput for documentation
#device nodes and links
$deviceConfigNodes = @()
$deviceConfigLinks = @()
ForEach ($assignment in $deviceConfigAssignments) {
	 $deviceConfigNodes += "$assignment [shape: oval, color: green]`n"
     $deviceConfigLinks += "Device Configurations > $assignment`n"
	}
#app assignment node
$appAssignments = """$($appAssignments -join ", ")"""
#app config nodes and links
$appConfigNodes = @()
$appConfigLinks = @()
ForEach ($assignment in $appConfigAssignments) {
    $appConfigNodes += "$assignment [shape: oval, color: green]`n"
    $appConfigLinks += "App Configurations > $assignment`n"
}
#eraser.io Output
$output = "title $outputTitle
styleMode plain
direction down
typeface rough
colorMode pastel

//Intune
Intune [color: 4897e9, icon: azure-intune] {
  Device[color: 4897e9] {
    Device Configurations [color: 4897e9]
    $deviceConfigNodes
  }
  Apps[color: 4897e9] {
    App Assignments [color: 4897e9]
    $appAssignments [color: green]
    App Configurations [color: 4897e9]
    $appConfigNodes
  }
}

$($entraGroup.DisplayName) [icon: microsoft-entra, color: 53e0fb]
Intune [color: blue]

//Relationships
$($entraGroup.DisplayName) > Intune
$deviceConfigLinks
App Assignments > $appAssignments
$appConfigLinks"

$output > C:\temp\eraser.txt
