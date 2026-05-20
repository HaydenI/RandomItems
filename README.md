# Antigravity Automation & IT Operations Hub

Welcome to the central repository for custom scripts, API templates, and automation workflows. This hub is designed to streamline administrative operations, automate recurring tasks, manage system presence, and facilitate proactive system administration across several enterprise tools.

---

## 📂 Repository Directory Map

Below is a structured map of the standardized folders and tools available in this repository.

| Platform / Area | Directory Path | Description | Key Assets |
| :--- | :--- | :--- | :--- |
| **DutchiePOS** | [`dutchiepos-leaflogix`](dutchiepos-leaflogix) | Postman-ready API payload templates for printer and register management. | [`fetch-lab-data.json`](dutchiepos-leaflogix/payload-templates/fetch-lab-data.json) |
| **Entra ID** | [`entra-id`](entra-id) | PowerShell scripts utilizing Microsoft Graph SDK for license SKU transitions. | [`Transition-MicrosoftE3ToE3NoTeams.ps1`](entra-id/Transition-MicrosoftE3ToE3NoTeams.ps1) |
| **Flipper Zero** | [`flipper-zero`](flipper-zero) | DuckyScript and Arduino/C++ source code payloads for OOBE system enrollment. | [`enroll-windows-11-oobe.md`](flipper-zero/enroll-windows-11-oobe.md) |
| **Intune** | [`intune`](intune) | Proactive Remediations (Detect/Remediate pairs) and branding management. | [`Replace-EloWallpaper.ps1`](intune/Replace-EloWallpaper.ps1) |
| **Microsoft Teams** | [`microsoft-teams`](microsoft-teams) | Power Automate flow and parsing schemas to automatically set Out-of-Office presence. | [`Set Team Status README`](microsoft-teams/team-status-power-automate/README.md) |
| **PagerDuty** | [`pagerduty`](pagerduty) | PowerShell scripts and workflows to batch-create service integrations via GET/POST. | [`New-ZendeskConnections.ps1`](pagerduty/mass-create-zendesk-connections/New-ZendeskConnections.ps1) |
| **Paychex** | [`paychex`](paychex) | Postman configurations and CSV schemas for batch-requesting corporate client access codes. | [`company-codes-examples.csv`](paychex/company-code-requests/company-codes-examples.csv) |
| **PrintNode** | [`printnode`](printnode) | Python-based interactive command-line interface to configure cups/printnode credentials. | [`printnode_cli_linux.py`](printnode/printnode_cli_linux.py) |
| **UKG Ready** | [`ukg-ready`](ukg-ready) | Custom REST SCIM alternative flow to automatically sync onboarding users into Entra ID. | [`ukg-ready README`](ukg-ready/README.md) |
| **Windows** | [`windows`](windows) | Heavy-duty system administration scripts for OS checks and forced updates. | [`Invoke-WindowsUpdate.ps1`](windows/Invoke-WindowsUpdate.ps1) |
| **Zendesk** | [`zendesk`](zendesk) | Help Center customization JS scripts, skipped ticket flows, and rating triggers. | [`block-form-based-on-user-tags.js`](zendesk/zendesk-guide/block-form-based-on-user-tags.js) |

---

## 📏 Naming Conventions Standard

To keep this repository clean, standardized, and command-line friendly, the following naming conventions are applied strictly across all folders and scripts:

*   📁 **Directories**: Always formatted in lowercase `kebab-case` (e.g., `entra-id`, `flipper-zero`, `zendesk-chat`). Spaces and parentheses are strictly avoided to ensure path-completion friendliness in POSIX shells.
*   ⚡ **PowerShell Scripts**: Formatted in `PascalCase` and strictly follow the Microsoft Cmdlet **`Verb-Noun`** standard (e.g., `Invoke-WindowsUpdate.ps1`, `Transition-MicrosoftE3ToE3NoTeams.ps1`, `Replace-EloWallpaper.ps1`).
*   🐍 **Python Scripts**: Formatted in `snake_case` in accordance with PEP 8 standards (e.g., `printnode_cli_linux.py`).
*   ☕ **JavaScript Files**: Formatted in lowercase `kebab-case` for simple module importing and compatibility (e.g., `block-form-based-on-user-tags.js`).
*   📝 **Markdown Documentation**: Always named in lowercase `kebab-case` (e.g., `enroll-windows-10-oobe.md`) to maintain SEO-friendly URLs on Git platforms.
*   📊 **CSV & JSON Configuration**: Lowercase `kebab-case` (e.g., `company-codes-examples.csv`, `parse-teams-status.json`).

---

## 🔒 Security & Credential Management

To prevent sensitive credentials and API tokens from being stored in plain text or accidentally committed to version control, all automation scripts retrieve secrets dynamically from environment variables. 

### 1. Standard Environment Variables

Configure the following variables on your machine or deployment pipeline depending on which scripts you are executing:

| Service | Environment Variable | Purpose | Used In |
| :--- | :--- | :--- | :--- |
| **PagerDuty** | `PAGERDUTY_TOKEN` | PagerDuty REST API Token | [`Update-EscalationPolicy.ps1`](pagerduty/Update-EscalationPolicy.ps1) |
| **PagerDuty** | `PAGERDUTY_BEARER_TOKEN` | OAuth Bearer Token | [`New-ZendeskConnections.ps1`](pagerduty/mass-create-zendesk-connections/New-ZendeskConnections.ps1) |
| **PagerDuty** | `ZENDESK_EXTENSION_ID` | Zendesk App Extension ID | [`New-ZendeskConnections.ps1`](pagerduty/mass-create-zendesk-connections/New-ZendeskConnections.ps1) |
| **Zendesk** | `ZENDESK_EMAIL` | Admin account email | [`Set-UserTags.ps1`](zendesk/zendesk-support/Set-UserTags.ps1), [`Update-IvrSelection.ps1`](zendesk/zendesk-talk/Update-IvrSelection.ps1) |
| **Zendesk** | `ZENDESK_TOKEN` | Zendesk API Token | [`Set-UserTags.ps1`](zendesk/zendesk-support/Set-UserTags.ps1), [`Update-IvrSelection.ps1`](zendesk/zendesk-talk/Update-IvrSelection.ps1) |
| **PrintNode** | `PRINTNODE_EMAIL` | Account email username | [`printnode_cli_linux.py`](printnode/printnode_cli_linux.py) |
| **PrintNode** | `PRINTNODE_PASSWORD` | Account password | [`printnode_cli_linux.py`](printnode/printnode_cli_linux.py) |
| **PrintNode** | `PRINTNODE_COMPUTER_NAME` | (Optional) Computer name | [`printnode_cli_linux.py`](printnode/printnode_cli_linux.py) |

> [!WARNING]
> **Git Safety:** Always ensure your `.env` file is never tracked by git. A `.gitignore` has been pre-configured to block `.env` file commits.

---

### 2. How to Set Environment Variables

#### ⚡ PowerShell (Windows & macOS/Linux)
Set variables for the **current terminal session**:
```powershell
$env:PAGERDUTY_TOKEN = "your-api-token"
$env:ZENDESK_EMAIL = "admin@example.com"
$env:ZENDESK_TOKEN = "your-zendesk-api-token"
```

To set variables **permanently on Windows** (User Level):
```powershell
[System.Environment]::SetEnvironmentVariable("PAGERDUTY_TOKEN", "your-api-token", "User")
```

#### 🐚 Linux / Bash
Set variables for the **current session**:
```bash
export PRINTNODE_EMAIL="admin@example.com"
export PRINTNODE_PASSWORD="your-secure-password"
```

To set variables **permanently on Linux**, add the export commands to your shell profile (e.g., `~/.bashrc`, `~/.zshrc`).

---

### 3. Local Development with `.env` (Git-Ignored)

For convenient local development, you can create a `.env` file in the root of this repository. 

**Example `.env` file:**
```ini
# PagerDuty Credentials
PAGERDUTY_TOKEN=pd_api_key_abc123
PAGERDUTY_BEARER_TOKEN=bearer_abc123
ZENDESK_EXTENSION_ID=extension_xyz789

# Zendesk Credentials
ZENDESK_EMAIL=admin@example.com
ZENDESK_TOKEN=zd_token_xyz987

# PrintNode Credentials
PRINTNODE_EMAIL=printer-admin@example.com
PRINTNODE_PASSWORD=super-secret-password
PRINTNODE_COMPUTER_NAME=WarehousePrinterOffice
```

#### Loading `.env` in PowerShell
Before executing scripts, load the `.env` file into your current session by running:
```powershell
if (Test-Path .env) {
    Get-Content .env | ForEach-Object {
        $line = $_.Trim()
        if ($line -and !$line.StartsWith('#') -and $line.Contains('=')) {
            $key, $value = $line -split '=', 2
            [System.Environment]::SetEnvironmentVariable($key.Trim(), $value.Trim(), 'Process')
        }
    }
    Write-Host "Local .env file loaded successfully." -ForegroundColor Green
}
```

---

## 🛠️ Getting Started & Prerequisites

### 1. PowerShell Core & Microsoft Graph SDK
Several enterprise scripts require administrative privileges and Microsoft Graph authentication.
To prepare your administrator workstation, run the following:
```powershell
# Install the necessary Microsoft Graph Modules
Install-Module Microsoft.Graph.Authentication -Scope CurrentUser
Install-Module Microsoft.Graph.Users -Scope CurrentUser

# Install Windows Update Modules (For Windows update scripts)
Install-Module PSWindowsUpdate -Scope CurrentUser
```

### 2. Python CLI Requirements
The `PrintNode` utility requires a Python 3 environment. To configure dependencies:
```bash
pip install click colorama configupdater psutil PyInquirer
```

### 3. API Integrations (Postman & Power Automate)
For Postman and Power Automate templates:
1.  Variable placeholders are wrapped in standard brackets `{PLACEHOLDER}` or Postman double curly brackets `{{VARIABLE}}`.
2.  Consult the respective subfolder's `README.md` file for step-by-step API cookie extraction guides.
