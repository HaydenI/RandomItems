$results = (net localgroup administrators) -like 'AzureAD\*'


try {
    if (($results -ne $null)) {
        Write-Host "Azure AD account(s) Found In Administrators"
        exit 1
    }
    else {
        Write-Host "Azure AD account(s) not found in Administrators"
        exit 0
    }
}
catch{
    $errMsg = $_.Exception.Message
    Write-Error $errMsg
    exit 1
}