$winsrv02 = "10.101.7.6"
$PW = Get-Credential

Invoke-Command -Credential $PW -ComputerName $winsrv02 -ScriptBlock {
    (Get-WmiObject -Class Win32_Service -Filter "name='bthserv").StartService()
}



