# Defines the Tenant, App, and cert
param (    
    [Parameter(Mandatory=$true)][string]$tenantid,
    [Parameter(Mandatory=$true)][string]$clientid,
    [Parameter(Mandatory=$true)][string]$CertificateThumbprint
)

# Checks to see if the certificate specified is valid
If(-not(Test-Path -Path "Cert:\CurrentUser\My\$CertificateThumbprint")){
    Write-Host "Unable to find a certificate with the following thumbprint: $CertificateThumbprint" -ForegroundColor Red
    exit
}

# Connects to Microsoft Graph
Connect-MgGraph -TenantId $tenantid -ClientId $clientid -CertificateThumbprint (Get-Item -Path "Cert:\CurrentUser\My\$CertificateThumbprint").Thumbprint -NoWelcome

# Finds all Enterprise Apps
$EnterpriseApps = Get-MgServicePrincipal -All

# Checks Enterprise Apps for SCIM and its status
$Results = @()
ForEach($EnterpriseApp in $EnterpriseApps){
    $SCIM = Get-MgServicePrincipalSynchronizationJob -ServicePrincipalID $EnterpriseApp.ID
    If($SCIM){
        $Results +=@(
            [PSCustomObject]@{
                DisplayName = $EnterpriseApp.DisplayName
                ObjectID = $EnterpriseApp.ID
                SCIMTemplateID = $SCIM.TemplateID
                SCIMStatus = $SCIM.Status.Code
            }
        )
    }
}

# Narrows down output to only show results with errors
$SCIMerrors = @($Results | Where-Object SCIMStatus -ne "Active")

# Writes output to screen
$SCIMerrors | Format-Table -AutoSize