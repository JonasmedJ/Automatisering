$winsrv01 = "10.101.59.66"
#$winsrv02 = "10.101.7.6"
$PW = Get-Credential
$StorageFile = "C:\Users\jox\Documents\checkdrive1_remote_$((Get-Date).ToString("dd_MM_yyyy")).csv"

Invoke-Command -ComputerName $winsrv01 -Credential $PW -ScriptBlock {
    # Define which system needs to be retrieved (network, system etc.)
    Get-CimInstance -ClassName Win32_ComputerSystem
} |

ForEach-Object {
    # Define object as $_ ($_ is the current object in the pipeline)
    $obj = $_
    # Create hashtable called properties (Ordered and empty)
    $properties = [ordered]@{}
    # Gets all properties of the Win32_computersystem class
    $obj.PSObject.properties |
    # Properties are defined so no value properties are removed by Where-Object
    Where-Object {
        $null -ne $_.Value -and $_.Value -ne ""
    } |
    # Sort the CSV file by Name
    Sort-Object -Property Name |
    # Sort through the CSV by name
    ForEach-Object {
        $properties[$_.Name] = $_.Value
    }
    # Convert the hashtable into a PowerShell object for usage
    [PSCustomObject]$properties
}|

Export-Csv -Path $StorageFile -Encoding utf8 -NoTypeInformation