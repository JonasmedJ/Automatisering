# $domain = sko.butik

$winsrv01 = "10.101.59.66"
#$winsrv02 = "10.101.7.6"
$PW = Get-Credential
$When = ((Get-Date).AddDays(-30)).Date

Invoke-Command -ComputerName $winsrv01 -Credential $PW -ScriptBlock {
    Get-ADUser -Filter {WhenCreated -ge $Using:When} -Searchbase "CN=Users,dc=SKO,dc=BUTIK" -Properties whenCreated | 
    Sort-Object -Property GivenName | 
    Where-Object GivenName
}

#Get-ADUser -Filter * -Searchbase "CN=Users,dc=SKO,dc=BUTIK" | 

#Invoke-Command -ComputerName $winsrv01 -Credential $PW -ScriptBlock {
#     Get-Process -IncludeUserName | Select-Object -Unique -Property UserName
#}
