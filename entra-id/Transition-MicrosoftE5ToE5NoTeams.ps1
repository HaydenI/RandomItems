param (
    [Parameter(Mandatory = $true)]
    [string]$CsvPath
)

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.Read.All", "Directory.ReadWrite.All"

# Define the license SKUs
$E5Sku = "06ebc4ee-1bb5-47dd-8120-11324bc54e06"
$E5NoTeamsSku = "18a4bd3f-0b5b-4887-b04f-61dd0ee15f5e"
$TeamsEnterpriseSku = "7e31c0d9-9551-471d-836f-32ee72be4a01"

# Import users from CSV
$users = Import-Csv -Path $CsvPath

foreach ($user in $users) {
    $upn = $user.UPN

    try {
        # Add new licenses
        Set-MgUserLicense -UserId $upn `
            -AddLicenses @(@{SkuId = $E5NoTeamsSku}, @{SkuId = $TeamsEnterpriseSku}) `
            -RemoveLicenses @()

        # Remove old license
        Set-MgUserLicense -UserId $upn `
            -AddLicenses @() `
            -RemoveLicenses @($E5Sku)

        Write-Host "Updated licenses for $upn"
    }
    catch {
        Write-Warning "Failed to update $upn"
    }
}
