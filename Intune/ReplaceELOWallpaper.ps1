If (Test-Path -Path C:\EloTouchSolutions\Background\Elo_BlueScreen_Logo_3840x2160.jpg ) {
    curl https://contoso.org/images/example.jpg -o C:\EloTouchSolutions\Background\Elo_BlueScreen_Logo_3840x2160.jpg
    Write-Host "Wallpaper Updated"
}
Else {
    Write-Host "No Wallpaper Found"
}