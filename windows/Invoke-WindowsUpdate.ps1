# Requires Administrator privileges to run. Designed for visible status output.

Write-Host "Starting forced Windows update process..." -ForegroundColor Cyan # Changed text

# Step 0: Ensure PSWindowsUpdate module is installed
Write-Host "Checking for PSWindowsUpdate module..." -ForegroundColor Yellow
if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Write-Host "PSWindowsUpdate module not found. Attempting to install..." -ForegroundColor Yellow
    try {
        Install-Module -Name PSWindowsUpdate -Force -Confirm:$false -ErrorAction Stop | Out-Null
        Write-Host "PSWindowsUpdate module installed successfully." -ForegroundColor Green
    }
    catch {
        Write-Host "Error installing PSWindowsUpdate module: $($_.Exception.Message). Please ensure PowerShell Gallery is accessible and you have internet access." -ForegroundColor Red
        exit 1
    }
}
else {
    Write-Host "PSWindowsUpdate module found." -ForegroundColor Green
}

# Import the module so its cmdlets are available
Import-Module PSWindowsUpdate -ErrorAction SilentlyContinue | Out-Null

# Step 1: Initial Check for pending updates and reboot status
Write-Host "`n--- Performing Initial System Update Status Check ---" -ForegroundColor Cyan

# Check for pending updates initially
Write-Host "Checking for any pending updates before proceeding..." -ForegroundColor Yellow
$initialPendingUpdates = $null
try {
    $initialPendingUpdates = Get-WUList -ErrorAction SilentlyContinue
    if ($initialPendingUpdates -and $initialPendingUpdates.Count -gt 0) {
        Write-Host "  > WARNING: There are $($initialPendingUpdates.Count) pending updates currently detected." -ForegroundColor DarkYellow
        $initialPendingUpdates | ForEach-Object {
            Write-Host "    - $($_.Title) ($($_.Status))" -ForegroundColor DarkYellow
        }
    } else {
        Write-Host "  > No pending Windows updates detected at this moment." -ForegroundColor Green
    }
}
catch {
    Write-Host "  > ERROR: Could not perform initial check for pending updates: $($_.Exception.Message)" -ForegroundColor Red
}

# Check for reboot status initially
Write-Host "Checking for pending reboot status before proceeding..." -ForegroundColor Yellow
$initialRebootNeeded = $false

# Method 1: PSWindowsUpdate's own check
try {
    $wuSettings = Get-WUSettings -ErrorAction SilentlyContinue
    if ($wuSettings.RebootRequired) {
        Write-Host "  > PSWindowsUpdate indicates a reboot is REQUIRED." -ForegroundColor DarkYellow
        $initialRebootNeeded = $true
    }
}
catch {
    Write-Host "  > ERROR: Could not check reboot status via PSWindowsUpdate: $($_.Exception.Message)" -ForegroundColor Red
}

# Method 2: Check for PendingFileRenameOperations registry key
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager"
$registryValue = "PendingFileRenameOperations"

if (Test-Path $registryKey) {
    try {
        $pendingFileOperations = Get-ItemProperty -Path $registryKey -Name $registryValue -ErrorAction SilentlyContinue
        if ($pendingFileOperations -and ($pendingFileOperations.$registryValue -ne $null)) {
            Write-Host "  > Registry indicates pending file rename operations (reboot likely needed)." -ForegroundColor DarkYellow
            $initialRebootNeeded = $true
        } else {
            Write-Host "  > No pending file rename operations found in registry." -ForegroundColor Green
        }
    }
    catch {
        Write-Host "  > ERROR: Could not read registry key for pending reboot: $($_.Exception.Message)" -ForegroundColor Red
    }
}
else {
    Write-Host "  > Session Manager registry path not found." -ForegroundColor Yellow
}

if ($initialRebootNeeded) {
    Write-Host "`nIMPORTANT: A system reboot is REQUIRED to complete pending operations/updates." -ForegroundColor Red
    Write-Host "Please REBOOT your system NOW and run this script again AFTER the reboot." -ForegroundColor Red
    Write-Host "Exiting script to prevent potential update corruption." -ForegroundColor Red
    exit 1 # Exit with an error code to indicate that action is needed
} else {
    Write-Host "Initial checks completed. No immediate reboot is required. Continuing with update process." -ForegroundColor Green
}

# Step 2: Stop the Windows Update Service
Write-Host "`nStopping Windows Update service (wuauserv)..." -ForegroundColor Yellow
try {
    Stop-Service -Name wuauserv -Force -ErrorAction Stop | Out-Null
    Write-Host "Windows Update service stopped successfully." -ForegroundColor Green
}
catch {
    Write-Host "Error stopping Windows Update service: $($_.Exception.Message). Please ensure you are running this script as Administrator." -ForegroundColor Red
    exit 1
}

# Step 3: Clear the SoftwareDistribution folder
Write-Host "Clearing the SoftwareDistribution folder..." -ForegroundColor Yellow
$softwareDistributionPath = "$env:SystemRoot\SoftwareDistribution"
if (Test-Path -Path $softwareDistributionPath) {
    try {
        Remove-Item -Path $softwareDistributionPath -Recurse -Force -ErrorAction Stop | Out-Null
        New-Item -Path $softwareDistributionPath -ItemType Directory -ErrorAction Stop | Out-Null
        Write-Host "SoftwareDistribution folder cleared and recreated successfully." -ForegroundColor Green
    }
    catch {
        Write-Host "Error clearing or recreating SoftwareDistribution folder: $($_.Exception.Message). Ensure no other processes are accessing this folder." -ForegroundColor Red
        exit 1
    }
}
else {
    Write-Host "SoftwareDistribution folder not found, creating it..." -ForegroundColor Yellow
    try {
        New-Item -Path $softwareDistributionPath -ItemType Directory -ErrorAction Stop | Out-Null
        Write-Host "SoftwareDistribution folder created." -ForegroundColor Green
    }
    catch {
        Write-Host "Error creating SoftwareDistribution folder: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

# Step 4: Restart the Windows Update Service
Write-Host "Starting Windows Update service (wuauserv)..." -ForegroundColor Yellow
try {
    Start-Service -Name wuauserv -ErrorAction Stop | Out-Null
    Write-Host "Windows Update service started successfully." -ForegroundColor Green
}
catch {
    Write-Host "Error starting Windows Update service: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Step 5: Search for, download, and install updates using PSWindowsUpdate
Write-Host "Searching for, downloading, and installing available updates..." -ForegroundColor Yellow
Write-Host "This process can take a significant amount of time depending on the number and size of updates." -ForegroundColor Yellow

try {
    # Find all available updates
    $updates = Get-WUList -ErrorAction Stop
    if ($updates) {
        Write-Host "$($updates.Count) updates found." -ForegroundColor Green
        
        Write-Host "Downloading updates..." -ForegroundColor Yellow
        $downloadResult = Get-WUInstall -DownloadOnly -AcceptAll -ErrorAction Stop
        if ($downloadResult.Count -gt 0) {
            Write-Host "$($downloadResult.Count) updates downloaded." -ForegroundColor Green
            Write-Host "Installing updates..." -ForegroundColor Yellow
            $installResult = Get-WUInstall -Install -AcceptAll -AutoReboot:$false -ErrorAction Stop
            
            if ($installResult.Count -gt 0) {
                Write-Host "$($installResult.Count) updates processed for installation." -ForegroundColor Green
            } else {
                Write-Host "No updates were installed or recognized as installed by PSWindowsUpdate." -ForegroundColor Red
                Write-Host "This might mean updates were already installed during download phase or there was an issue." -ForegroundColor Yellow
            }
        } else {
            Write-Host "No updates were downloaded." -ForegroundColor Yellow
        }
    } else {
        Write-Host "No pending updates found for download/install." -ForegroundColor Green
    }
}
catch {
    Write-Host "Error during update download/installation process: $($_.Exception.Message). Check internet connection and PSWindowsUpdate module status." -ForegroundColor Red
    # Do not exit here, allow the final status check to run
}

Write-Host "Forced Windows update process completed (initial attempt)." -ForegroundColor Cyan # Changed text

# Step 6: Final Check for pending updates and reboot status
Write-Host "`n--- Performing Final System Update Status Check ---" -ForegroundColor Cyan

# Check for pending updates again
Write-Host "Checking for any remaining pending updates..." -ForegroundColor Yellow
try {
    $finalPendingUpdates = Get-WUList -ErrorAction SilentlyContinue
    if ($finalPendingUpdates -and $finalPendingUpdates.Count -gt 0) {
        Write-Host "WARNING: There are $($finalPendingUpdates.Count) pending updates remaining." -ForegroundColor DarkYellow
        $finalPendingUpdates | ForEach-Object {
            Write-Host "    - $($_.Title) ($($_.Status))" -ForegroundColor DarkYellow
        }
    } else {
        Write-Host "No pending Windows updates found." -ForegroundColor Green
    }
}
catch {
    Write-Host "Could not check for pending updates: $($_.Exception.Message)" -ForegroundColor Red
}

# Check for reboot status
Write-Host "Checking for pending reboot status..." -ForegroundColor Yellow
$finalRebootNeeded = $false

# Method 1: PSWindowsUpdate's own check
try {
    $wuSettings = Get-WUSettings -ErrorAction SilentlyContinue
    if ($wuSettings.RebootRequired) {
        Write-Host "  > PSWindowsUpdate indicates a final reboot is REQUIRED." -ForegroundColor DarkYellow
        $finalRebootNeeded = $true
    }
}
catch {
    Write-Host "  > Could not check final reboot status via PSWindowsUpdate: $($_.Exception.Message)" -ForegroundColor Red
}

# Method 2: Check for PendingFileRenameOperations registry key
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager"
$registryValue = "PendingFileRenameOperations"

if (Test-Path $registryKey) {
    try {
        $pendingFileOperations = Get-ItemProperty -Path $registryKey -Name $registryValue -ErrorAction SilentlyContinue
        if ($pendingFileOperations -and ($pendingFileOperations.$registryValue -ne $null)) {
            Write-Host "  > Registry indicates pending file rename operations (final reboot likely needed)." -ForegroundColor DarkYellow
            $finalRebootNeeded = $true
        } else {
            Write-Host "  > No pending file rename operations found in registry." -ForegroundColor Green
        }
    }
    catch {
        Write-Host "  > Could not read registry key for final pending reboot: $($_.Exception.Message)" -ForegroundColor Red
    }
}
else {
    Write-Host "  > Session Manager registry path not found." -ForegroundColor Yellow
}


if ($finalRebootNeeded) {
    Write-Host "`nSUMMARY: A system reboot is REQUIRED to complete pending operations/updates!" -ForegroundColor Red
    Write-Host "Please reboot your system at your earliest convenience." -ForegroundColor Red
} else {
    Write-Host "`nSUMMARY: No system reboot appears to be required at this time." -ForegroundColor Green
    Write-Host "All pending operations/updates should be complete." -ForegroundColor Green
}

Write-Host "`nScript execution finished." -ForegroundColor Cyan