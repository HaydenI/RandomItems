# --- Configuration ---
# Official Microsoft download page for Windows 11
$DownloadPageUrl = "https://www.microsoft.com/en-us/software-download/windows11"
# Direct download link (This might change, script attempts to scrape it, otherwise uses a known pattern)
# For robustness, it's better to get this from the page or have a reliable known URL.
# As of the last check, the direct link often follows a pattern, but scraping is more future-proof.
# However, for simplicity and reliability if the page structure changes, we might use a more direct (but potentially less stable) link if scraping fails.

$InstallerName = "Windows11InstallationAssistant.exe"
$DownloadPath = Join-Path -Path $env:TEMP -ChildPath $InstallerName

# --- Main Script ---

Write-Host "Starting the Windows 11 Installation Assistant download and execution process..."

# Step 1: Attempt to find the direct download link from the Microsoft page
Write-Host "Attempting to retrieve the direct download link for '$InstallerName'..."
try {
    $WebResponse = Invoke-WebRequest -Uri $DownloadPageUrl -UseBasicParsing
    # This selector might change if Microsoft updates their website.
    # Look for an 'a' tag with 'href' ending in 'Windows11InstallationAssistant.exe'
    $DirectLinkNode = $WebResponse.Links | Where-Object {$_.href -like "*$InstallerName"} | Select-Object -First 1

    if ($DirectLinkNode -and $DirectLinkNode.href) {
        $ActualDownloadUrl = $DirectLinkNode.href
        # Ensure the URL is absolute
        if (-not ($ActualDownloadUrl -match "^https?://")) {
             $Uri = [System.Uri]$DownloadPageUrl
             $ActualDownloadUrl = [System.Uri.AbsoluteUri](New-Object System.Uri($Uri, $ActualDownloadUrl))
        }
        Write-Host "Successfully found direct download link: $ActualDownloadUrl"
    } else {
        # Fallback URL if scraping fails (this URL pattern might become outdated)
        $ActualDownloadUrl = "https://go.microsoft.com/fwlink/?linkid=2171764" # Known good link as of some point
        Write-Warning "Could not dynamically find the download link. Using a fallback URL: $ActualDownloadUrl"
        Write-Warning "If the download fails, please verify the fallback URL is still valid or update the script."
    }
} catch {
    Write-Error "Failed to access the download page: $($_.Exception.Message)"
    # Fallback URL if web request to page fails
    $ActualDownloadUrl = "https://go.microsoft.com/fwlink/?linkid=2171764" # Known good link as of some point
    Write-Warning "Using a fallback URL due to error: $ActualDownloadUrl"
    Write-Warning "If the download fails, please verify the fallback URL is still valid or update the script."
}


# Step 2: Download the Windows 11 Installation Assistant
Write-Host "Downloading '$InstallerName' from '$ActualDownloadUrl' to '$DownloadPath'..."
try {
    Invoke-WebRequest -Uri $ActualDownloadUrl -OutFile $DownloadPath -UseBasicParsing
    Write-Host "'$InstallerName' downloaded successfully."
} catch {
    Write-Error "Failed to download '$InstallerName'. Error: $($_.Exception.Message)"
    Write-Error "Please check your internet connection and the download URL."
    # Optional: Exit if download fails, or attempt to proceed if the file might already exist.
    # For this script, we'll exit as the intention is to download and run.
    exit 1
}

# Step 3: Verify the download
if (-not (Test-Path $DownloadPath)) {
    Write-Error "Downloaded file not found at '$DownloadPath'. Exiting."
    exit 1
}

# Step 4: Execute the Windows 11 Installation Assistant with specified parameters
Write-Host "Executing '$InstallerName' with specified parameters..."
$Arguments = "/QuietInstall /SkipEULA /Auto Upgrade /NoRestartUI"
Write-Host "Command: $DownloadPath $Arguments"

try {
    # Using Start-Process to run the executable
    # -Wait can be added if you want the script to wait for the assistant to complete,
    # but the assistant itself might spawn other processes and exit,
    # and /NoRestartUI implies it might run in the background for a while.
    Start-Process -FilePath $DownloadPath -ArgumentList $Arguments -Verb RunAs # -Wait (optional)
    Write-Host "'$InstallerName' has been launched."
    Write-Host "The upgrade process will continue in the background as per the assistant's design."
} catch {
    Write-Error "Failed to start '$InstallerName'. Error: $($_.Exception.Message)"
    Write-Error "Ensure you are running the script with Administrator privileges if UAC is enabled."
    exit 1
}

Write-Host "Script finished. The Windows 11 Installation Assistant should be running."