param($csv_file)

function PagerDutyAPICall($csv) { 
$headers=@{}
$headers.Add("Content-Type", "application/json")
$headers.Add("Accept", "application/vnd.pagerduty+json;version=2")
$headers.Add("Authorization", "Token token={token}")
$dirtybody = "{
    //service//: {
      //escalation_policy//: {
        //id//: //{escalationID}//,
        //type//: //escalation_policy_reference//
      }
    }
  }"
$cleanbody = $dirtybody -replace '//','"'
$response = Invoke-WebRequest -Uri "https://api.pagerduty.com/services/$($csv.PagerDutyServiceID)" -Method PUT -Headers $headers -ContentType 'application/json' -Body $cleanbody
write-host $response
}

$date = Get-Date -format "yyyy-MM-dd_HHmm"
Start-Transcript -Path "UpdateUsers$date.txt"
Import-Csv $csv_file | ForEach-Object { PagerDutyAPICall $_ }
Stop-Transcript