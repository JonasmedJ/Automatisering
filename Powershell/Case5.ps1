$winsrv01 = "10.101.59.66"
#$winsrv02 = "10.101.7.6"
$PW = Get-Credential
$Logfile = "C:\Users\jox\Documents\logfile$((Get-Date).ToString("dd_MM_yyyy")).txt"
$CSV = "C:\Users\jox\Documents\users.csv"
$ADUsers = Import-csv $CSV -Delimiter ","

# Import-Module ActiveDirectory

Start-Transcript -path $Logfile

Invoke-Command -ComputerName $winsrv01 -Credential $PW -ScriptBlock {
    $Using:ADUsers | Format-Table
    foreach ($User in $ADUsers) {
        try {
            $UserParams = @{
                SamAccountName          = $User.SamAccountName
                GivenName               = $User.GivenName
                SurName                 = $User.Surname
                Path                    = $User.OU
                Department              = $User.Department
                EmailAddress            = $User.Email
                AccountPassword         = (ConvertTo-SecureString $User.TempPassword -AsPlainText -Force)
                ChangePasswordAtLogon   = $True
                Enabled                 = $True
            }

            if (Get-Aduser -Filter "SamAccountName -eq '$($User.SamAccountName)'") {
                Write-Host "A user with username $($User.SamAccountName) already exists"
            }
            else {
                New-ADUser @UserParams

                Write-Host "The User $($User.SamAccountName) is created"
                
                # find groups in CSV file
                if ($User.Groups) {
                    # Define how groups are set up in CSV
                    $Groups = $User.Groups -split ";"
                    # Loop in case mulitple groups are per user, keep running if more than 1 group
                    foreach ($Group in $Groups){
                        try {
                            # Add user to group, with $Group identity - Trim removes unused space
                            Add-ADGroupMember -Identity $Group.Trim() -Members $User.SamAccountName
                            # Display confirmation message
                            Write-Host " Added $($User.SamAccountName) to Group $Group"
                        }
                        # If add to group fails, display error message
                        catch {
                            Write-Host " Failed to add $($User.SamAccountName) to Group $Group"
                        }
                    }
                }
            }
        }
        catch {
            # If user fails to be created, display error message
            Write-Host "Failed to create user $($User.SamAccountName) - $_"
        }
    }
}

Stop-Transcript