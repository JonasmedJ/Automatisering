$winsrv01 = "10.101.59.66"
$winsrv02 = "10.101.7.6"
$PW = Get-Credential

#Invoke-Command -Credential $PW -ComputerName $winsrv02 -ScriptBlock {
#    (Get-WmiObject -Class Win32_Service -Filter "name='bthserv'").StopService()
#}

$parameters = @{
  ComputerName	    = $winsrv01, $winsrv02
  Credential	    = $PW
  ScriptBlock	    = (Get-WmiObject -Class Win32_Service ).StopService()
}
Invoke-Command @parameters