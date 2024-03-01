$user = "Administrator"
try {
  if ((Get-LocalUser -Name $user).Enabled) {
    Write-Host "$user is not Enabled"
    exit 1
  } 
  else {
    Write-Host "$user is already Enabled" 
    exit 0
  }
}
catch {
  $errMsg = $_.Exception.Message
  Write-Error $errMsg
  exit 1
}