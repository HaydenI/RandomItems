param($csv_file)

function APICall($csv) {
$username='{useremail}/token'
$token='{apikey}'
$combined="$($username):$($token)"
$bytes=[System.Text.Encoding]::ASCII.GetBytes($combined)
$base64=[System.Convert]::ToBase64String($bytes) 
$headers=@{}
$headers.Add("Content-Type", "application/json")
$headers.Add("Authorization", "Basic $base64")
$dirtybody = "{
    //phone_number//: {
        //ivr_id//: 41987187648841876
    }
}"
$cleanbody = $dirtybody -replace '//','"'
$response = Invoke-WebRequest -Uri "https://example.zendesk.com/api/v2/channels/voice/phone_numbers/$($csv.ID)" -Method PUT -Headers $headers -ContentType 'application/json' -Body $cleanbody
write-host $response
}

$date = Get-Date -format "yyyy-MM-dd_HHmm"
Start-Transcript -Path "UpdateUsers$date.txt"
Import-Csv $csv_file | ForEach-Object { APICall $_ }
Stop-Transcript
