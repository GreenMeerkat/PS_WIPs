# Define Variables
$choice = $null



# Script Start
Write-Host "
***** Welcome to Computer lookup *****
1. Start a new checkup
2. Load old checkup
3. Exit"
$choice = Read-Host "What would you like to do"

switch ($choice)
{
    1 {
        # Define Checkup variables
        $ToCheck = New-Object System.Collections.ArrayList
        $ComputersToCheck = New-Object System.Collections.ArrayList
        $Checklist = New-Object PSObject
        $AddressesNotEmpty = $false


        # Start Code
        cls
        Write-Host "STAGE 1: SET PARAMETERS"
        $OS = Read-Host "Check operating system"
        $Archi = Read-Host "Check architecture"
        $CName = Read-Host "Check computer name"
        $Logging = Read-Host "Would you like to log The information"

        # Check if choices above and adds the chosen to an array
        if ($OS -like "*y*") { $ToCheck.Add("name") >null }
        if ($Archi -like "*y*") { $ToCheck.Add("OSArchitecture") >null}
        if ($CName -like "*y*") { $ToCheck.Add("CSName") > null}
        if ($Logging -like "*y*") { $Logging = $true}

        # Get Targets and check if they're up
        while ($AddressesNotEmpty -ne $true)
        {
            $Address = Read-Host "`nEnter Computer Addresses"
            if ( $Address -eq "?")
            {
                Write-Host "You can insert more than one address"
            }
            else
            {
                $Addresses = $Address -split ","
                foreach ($i in $Addresses)
                {
                    if (Test-Connection -ComputerName "$i" -Count 1)
                    {
                        $ComputersToCheck.Add($i) > null
                        $AddressesNotEmpty = $true
                    }
                    else
                    {
                        Write-Host "$i is down" -ForegroundColor Red
                    }
                }
            }
        }

        # Preform the check itself
        cls
        Write-Host "STEP 2: GATHERRING INFORMATION"
        foreach ($comp in $ComputersToCheck)
        {
            $OSWMI = Get-WmiObject Win32_OperatingSystem -ComputerName $comp 

            if ($ToCheck -contains "CSName") { $Checklist | Add-Member -MemberType Noteproperty -Name "Computer name" -Value $OSWMI.CSName -ErrorAction SilentlyContinue }
            $Checklist | Add-Member -MemberType Noteproperty -Name "IP" -Value $comp -ErrorAction SilentlyContinue
            if ($ToCheck -contains "name") { $Checklist | Add-Member -MemberType Noteproperty -Name "OS" -Value $OSWMI.Name -ErrorAction SilentlyContinue }
            if ($ToCheck -contains "OSArchitecture"){ $Checklist | Add-Member -MemberType Noteproperty -Name "Architecture" -Value $OSWMI.OSArchitecture -ErrorAction SilentlyContinue }
            $Checklist | fl
            if ($Logging -eq $true) { New-Item -ItemType file -path C:\ComputerCheck_log.txt -Value $($Checklist | fl) }
        }
    }
    2 {
        $path = read-host "Insert Path"

        if (Test-Path -Path $path)
        {
            Get-Content -Path $path
        }
    }
    3 {
        exit
    }
}
