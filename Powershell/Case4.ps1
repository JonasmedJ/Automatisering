$winsrv01 = "10.101.59.66"
#$winsrv02 = "10.101.7.6"
$PW = Get-Credential
$StorageFile = "C:\Users\jox\Documents\checkdrive1_remote_$((Get-Date).ToString("dd_MM_yyyy")).csv"

Invoke-Command -ComputerName $winsrv01 -Credential $PW -ScriptBlock {
    Get-CimInstance -ClassName Win32_ComputerSystem
} |

ForEach-Object {
    $obj = $_
    $properties = [ordered]@{}

    $obj.PSObject.properties |

    Where-Object {
        $null -ne $_.Value -and $_.Value -ne ""
    } |

    Sort-Object -Property Name |

    ForEach-Object {
        $properties[$_.Name] = $_.Value
    }
    
    [PSCustomObject]$properties
}|

Export-Csv -Path $StorageFile -Encoding utf8 -NoTypeInformation