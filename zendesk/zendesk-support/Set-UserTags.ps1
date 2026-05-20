param($csv_file)

function APICall($csv) {
$username='{useremail}/token'
$token='{token}'
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