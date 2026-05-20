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
