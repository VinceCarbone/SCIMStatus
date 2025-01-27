This script will quickly identify any Enterprise Apps configured for SCIM Provisioning that are in an error state. Microsoft does send an email alert regarding this, but it's easy to overlook and end up with an app that hasn't synced in days, weeks, or longer. You can also have this run as a scheduled task and output a CSV or whatever works best for your environment.

A few requirements
1. An App Registration granted the Microsoft Graph "Directory.Read.All" API permission (application, not delegated)
2. You'll also need a certificate uploaded to the app registration, and that same certificate installed under the user profile of whoever is going to run the script
3. The Microsoft.Graph.Applications PowerShell module needs to be installed https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.applications/?view=graph-powershell-1.0

You'd run this by simply calling the script like so, obviously subsituting your own information

.\SCIMStatus.ps1 -TenantID "whatever.onmicrosoft.com" -ClientID "12345678-1234-5678-1234-123456789012" -CertificateThumbprint "ABCDEFGHIJ1234567890ABCDEFGHIJ"

The results will print to the screen, however you can easily have the $SCIMErrors variable output to a CSV or whatever works best for you
