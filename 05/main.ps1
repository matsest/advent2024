[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    $Solve = $false
)

function New-Ruleset {
    param (
        [string[]]$Content
    )
    $rules = @{}
    $Content | ForEach-Object {
        $rule = $_.Split('|')
        $rules[[int]$rule[0]] += , [int]($rule[1])
    }
    $rules
}

function Test-Order {
    param (
        [int[]]$Update,
        [hashtable]$Rules
    )
    for ($i = 0; $i -lt $parts.Length; $i++) {
        if ($rules.ContainsKey($parts[$i])) {
            $isValid = $true
            # check forwards
            if ($i -lt $parts.Length - 1) {
                foreach ($part in $parts[($i + 1)..$parts.Length]) {
                    if ($rules[$parts[$i]] -notcontains $part) {
                        $isValid = $false
                        #Write-Host -ForegroundColor Red "FWD NOT VALID. [$part]: Does not contain rule $($rules[$parts[$i]] -join ',')"
                        break
                    }
                }
            }
            # check backwards
            if ($i -gt 0 -and $isValid) {
                foreach ($part in $parts[($i - 1)..0]) {
                    if ($rules[$parts[$i]] -contains $part) {
                        $isValid = $false
                        #Write-Host -ForegroundColor Red "BWD NOT VALID. [$part]: Does not contain rule $($rules[$parts[$i]] -join ',')"
                        break
                    }
                }
            }
            if (!$isValid) {
                break
            }
        }
    }
    if ($isValid) {
        return $true
    }
    $false
}

function Get-MiddleElement {
    param (
        [int[]]$Array
    )
    $Array[($Array.Length - 1) / 2]
}

function Invoke-Part1 {
    param (
        [string[]]$Path
    )
    $sum = 0

    [string[]]$ruleInput = Get-Content -Path $Path[0]
    $rules = New-Ruleset -Content $ruleInput
    [string[]]$updates = Get-Content -Path $Path[1]

    foreach ($line in $updates) {
        [int[]]$parts = $line.Split(',')
        #Write-Host -Foregroundcolor Green "`n >>> Checking $($parts -join ',')"
        $isValid = Test-Order -Update $parts -Rules $rules
        if ($isValid) {
            $middle = Get-MiddleElement -Array $parts
            $sum += $middle
            #Write-Host "Is VALID! Middle: $middle for $($parts -join ','). Sum: $sum"
        }
    }
    $sum
}


function Invoke-Part2 {
    param (
        [string[]]$Path
    )
    $sum = 0

    [string[]]$ruleInput = Get-Content -Path $Path[0]
    $rules = New-Ruleset -Content $ruleInput
    [string[]]$updates = Get-Content -Path $Path[1]

    foreach ($line in $updates) {
        [int[]]$parts = $line.Split(',')
        #Write-Host -Foregroundcolor Green "`n >>> Checking $($parts -join ',')"
        $isValid = Test-Order -Update $parts -Rules $rules
        if (!$isValid) {
            Write-Host -Foregroundcolor Green "`n >>> Incorrect $($parts -join ',')"
            # todo find corrected parts
            #$partsCorrected = @() # TODO
            #$middle = Get-MiddleElement -Array $partsCorrected
            #$sum += $middle
            #Write-Host "Is VALID! Middle: $middle for $($parts -join ','). Sum: $sum"
        }
    }
    $sum

}


if ($Solve) {
    Invoke-Part1 -Path "input1.txt", "input2.txt"
    #Invoke-Part2 -Path "test1.txt", "test2.txt"
}