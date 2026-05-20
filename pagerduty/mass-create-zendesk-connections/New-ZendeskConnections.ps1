param($csv_file)

# Retrieve PagerDuty Bearer Token and Zendesk Extension ID from environment variables
$bearer = $env:PAGERDUTY_BEARER_TOKEN
$extensionId = $env:ZENDESK_EXTENSION_ID

if (-not $bearer) {
    Write-Error "Error: Environment variable 'PAGERDUTY_BEARER_TOKEN' is not set."
    Write-Error "Please set it before running this script (e.g., `$env:PAGERDUTY_BEARER_TOKEN = 'your_bearer_token')."
    exit 1
}

if (-not $extensionId) {
    Write-Error "Error: Environment variable 'ZENDESK_EXTENSION_ID' is not set."
    Write-Error "Please set it before running this script (e.g., `$env:ZENDESK_EXTENSION_ID = 'your_extension_id')."
    exit 1
}

function PagerDutyAPICall($csv) {
$headers=@{}
$headers.Add("Content-Type", "application/json")
$headers.Add("Accept", "application/vnd.pagerduty+json;version=2")
$headers.Add("Authorization", "Bearer $bearer")
$dirtybody = "{
    //connected_service//: {
        //config//: {
            //pagerduty_to_zendesk//: {
                //autocreate_ticket//: {
                    //enabled//: true,
                    //incident_priority_threshold//: ////,
                    //zendesk_ticket_type//: //problem//
                },
                //status_mapping//: {
                    //acknowledged//: //open//,
                    //resolved//: //solved//,
                    //triggered//: //new//
                }
            },
            //priority_mapping//: {
                //high//: [],
                //low//: [],
                //normal//: [],
                //urgent//: []
            },
            //sync_notes//: true,
            //zendesk_to_pagerduty//: {
                //status_mapping//: {
                    //closed//: //resolved//,
                    //hold//: //acknowledged//,
                    //new//: //triggered//,
                    //open//: //acknowledged//,
                    //pending//: //acknowledged//,
                    //solved//: //resolved//
                }
            }
        },
        //owned_by//: {},
        //service//: {
            //id//: //$($csv.id)//,
            //summary//: //$($csv.name)//,
            //type//: //service_reference//
        }
    }
}"
$cleanbody = $dirtybody -replace '//','"'
$response = Invoke-WebRequest -Uri "https://zendesk-apps.pagerduty.com/api/connected_services?accounts_mapping_id=$extensionId" -Method POST -Headers $headers -ContentType 'application/json' -Body $cleanbody
write-host $response
}

$date = Get-Date -format "yyyyMMdd"
Import-Csv $csv_file | ForEach-Object { PagerDutyAPICall $_ }