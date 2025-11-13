$winsrv01 = "10.101.59.66"
#$winsrv02 = "10.101.7.6"
$PW = Get-Credential

$FileSpecs="{$_.Free/1GB}, {$_.Used/1GB}, Root, PSComputerName, Name, Description"

$StorageFile="C:\Windows\checkdrive_remote_$((Get-Date).ToString("dd_MM_yyyy")).csv"

Invoke-Command -ComputerName $winsrv01 -Credential $PW -ScriptBlock {
    Get-PSDrive | 
    Select-Object $FileSpecs |
    Export-Csv -path $StorageFile -Encoding utf8 -NoTypeInformation
}