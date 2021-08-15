Write-Output " ====================  Started Setup Known host on our remote server   ======================"
  
$inputText = ssh-keyscan $env:AWS_SERVER_HOSTNAME

Add-Content -Path "$env:userprofile\.ssh\known_hosts" -Value ("`r`n" + $inputText) -Force

Write-Output " ====================  End Setup Known host on our remote server   ======================"
 