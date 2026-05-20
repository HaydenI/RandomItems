param($csv_file)

# Retrieve Zendesk credentials from environment variables
$username = $env:ZENDESK_EMAIL
$token = $env:ZENDESK_TOKEN

if (-not $username) {
    Write-Error "Error: Environment variable 'ZENDESK_EMAIL' is not set."
    Write-Error "Please set it before running this script (e.g., `$env:ZENDESK_EMAIL = 'user@example.com')."
    exit 1
}

if (-not $token) {
    Write-Error "Error: Environment variable 'ZENDESK_TOKEN' is not set."
    Write-Error "Please set it before running this script (e.g., `$env:ZENDESK_TOKEN = 'your_api_token')."
    exit 1
}

# Automatically append /token if the user provided just their email
if (-not $username.EndsWith('/token')) {
    $username = "$username/token"
}

function APICall($csv) {
$combined="$($username):$($token)"
$bytes=[System.Text.Encoding]::ASCII.GetBytes($combined)
$base64=[System.Convert]::ToBase64String($bytes) 
$headers=@{}
$headers.Add("Content-Type", "application/json")
$headers.Add("Authorization", "Basic $base64")
$dirtybody = "{
  //user//: {
    //tags//: [
        //tag_that_should_be_applied_to_user//
    ]
  }
}"
$cleanbody = $dirtybody -replace '//','"'
$response = Invoke-WebRequest -Uri "https://example.zendesk.com/api/v2/users/$($csv.ID)" -Method PUT -Headers $headers -ContentType 'application/json' -Body $cleanbody
write-host $response
}

$date = Get-Date -format "yyyy-MM-dd_HHmm"
Start-Transcript -Path "UpdateUsers$date.txt"
Import-Csv $csv_file | ForEach-Object { APICall $_ }
Stop-Transcript