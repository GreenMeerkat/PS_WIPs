# Defining General Variables
$working = $true

# Looping, in case of future enhancement
while ($working -eq $true)
{
    # Defining Session variables
    $file = $null
    $F2S = $null
    $FileExist = $null
    $TargetExist = $null
    $Target = $null
    $VaildTargets = New-Object System.Collections.ArrayList

    # Getting the file path and checking it's vaild
    while ($FileExist -ne $true)
    {
        $File = Read-Host "Drag a file here"
        if ($File -match "([A-Z]:\\.*)`"")
        {
            $F2S = $Matches[1]

            if (Test-Path -Path $f2S)
            {
                Write-Host "File Loaded" -ForegroundColor Green
                $FileExist = $true
                pause
            }
            else
            {
                Write-Host "Could not find the specified file's location" -ForegroundColor Red
                pause
            }
        }
        else
        {
            Write-Host "File was not dragged, please try again" -ForegroundColor Red
            pause
            cls
        }
    }
    # Getting a destination and check if it's available
    while ($TargetExist -ne $true)
    {
        try {
            $Target = Read-Host "Enter the Target's IP Address(es)"
            $Compters = $Target -split ","
            foreach ($Address in $Compters)
            {
                Test-Connection -ComputerName $Address -Count 1 -ErrorAction Stop
                Write-Host "`n$Address is up`n"  -ForegroundColor Green
                $VaildTargets.Add($Address)
            }
            $TargetExist = $true
        } catch {
            Write-Host "Could not connect to $Address" -ForegroundColor Red
        }
    }

    #Testing connection through UNC path to C drive and copying the file to there
    Write-Host "Testing connection to the target's C drive"
    foreach ($i in $VaildTargets)
    {
        if (Test-Path -Path \\$i\C$)
        {
            try {
                Copy-Item -Path $F2S -Destination \\$i\C$ -ErrorAction Stop
                Write-Host "`nConnection Successful, file was sent to $i" -ForegroundColor Green
            } catch {
                Write-Host "`nCould not send file to $i" -ForegroundColor Red
            }
        }
        else
        {
            Write-Host "$i's C drive is unreachable" -ForegroundColor Red
        }
    }

}