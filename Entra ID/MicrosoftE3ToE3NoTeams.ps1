param (
    [Parameter(Mandatory = $true)]
    [string]$CsvPath
)

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.Read.All", "Directory.ReadWrite.All"

# Define the license SKUs
$E3Sku = "05e9a617-0261-4cee-bb44-138d3ef5d965"
$E3NoTeamsSku = "dcf0408c-aaec-446c-afd4-43e3683943ea"
$TeamsEnterpriseSku = "7e31c0d9-9551-471d-836f-32ee72be4a01"

# Import users from CSV
$users = Import-Csv -Path $CsvPath

foreach ($user in $users) {
    $upn = $user.UPN

    try {
        # Add new licenses
        Set-MgUserLicense -UserId $upn `
            -AddLicenses @(@{SkuId = $E3NoTeamsSku}, @{SkuId = $TeamsEnterpriseSku}) `
            -RemoveLicenses @()

        # Remove old license
        Set-MgUserLicense -UserId $upn `
            -AddLicenses @() `
            -RemoveLicenses @($E3Sku)

        Write-Host "Updated licenses for $upn"
    }
    catch {
        Write-Warning "Failed to update $upn"
    }
}
