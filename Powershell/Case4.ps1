$winsrv01 = "10.101.59.66"
#$winsrv02 = "10.101.7.6"
$PW = Get-Credential
$StorageFile = "C:\Windows\checkdrive_remote_$((Get-Date).ToString("dd_MM_yyyy")).csv"
$Sortitems = 

Invoke-Command -ComputerName $winsrv01 -Credential $PW -ScriptBlock {
    Get-CimInstance -ClassName Win32_ComputerSystem |
    Where-Object $Sortitems
} |
Export-Csv -Path $StorageFile -Encoding utf8 -NoTypeInformation