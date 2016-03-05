################################################################
# SCRIPT: Install-ADDSOnGuest.ps1
# AUTHOR: Josh Ellis - Josh@JoshEllis.NZ
# Website: JoshEllis.NZ
# VERSION: 1.0
# DATE: 05/03/2016
# DESCRIPTION: Installs Active Directory and creates a new Domain on a Hyper-V Guest. Used for quickly deploying lab environments.
# Requirements: Windows 10 or above, Server 2016 TP4 or above
################################################################


[CmdletBinding()]
Param(
[Parameter(Mandatory=$True,Position=1)]
[string]$Name
     )

$VMCredentials = Get-Credential -Message "Enter Credentials for Virtual Machine:"

$ScriptBlockContent = {

# Variables
$DomainName = "Lab.JoshEllis.NZ"
$NetBIOSName = $DomainName.Split(".") | Select -First 1
$ForestMode = "Win2012R2"
$DomainMode = "Win2012R2"
$DatabasePath = "C:\ADDS\NTDS"
$SYSVOLPath = "C:\ADDS\SYSVOL"
$LogPath = "C:\ADDS\Logs"
$ADRestorePassword = ConvertTo-SecureString -String "P@ssw0rd" -AsPlainText -Force

Install-WindowsFeature AD-Domain-Services -IncludeManagementTools


Install-ADDSForest -DomainName $DomainName `
                   -DomainNetbiosName $NetBIOSName `
                   -ForestMode $ForestMode `
                   -DomainMode $DomainMode `
                   -DatabasePath $DatabasePath `
                   -SYSVOLPath $SYSVOLPath `
                   -LogPath $LogPath `
                   -SafeModeAdministratorPassword $ADRestorePassword `
                   -NoRebootonCompletion:$false `
                   -Force
                   


} #End of Script Block Content

Invoke-Command -VMName $Name -ScriptBlock $ScriptBlockContent -Credential $VMCredentials