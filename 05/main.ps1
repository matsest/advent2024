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
    $isOk = $true
    foreach ($rule in $rules.GetEnumerator()) {
        if ($rule.Key -in $Update) {
            foreach ($val in $rule.Value) {
                if ($val -in $Update) {
                    if ($Update.IndexOf($val) -lt $Update.IndexOf($rule.Key)) {
                        $isOk = $false
                    }
                }
            }
        }
    }
    if ($isOk) {
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
        $isValid = Test-Order -Update $parts -Rules $rules
        if ($isValid) {
            $middle = Get-MiddleElement -Array $parts
            $sum += $middle
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
        $isValid = Test-Order -Update $parts -Rules $rules
        if (!$isValid) {
            #Write-Host "Invalid order: $line"
            while (!$isValid) {
                for ($i = 0; $i -lt $parts.Length - 1; $i++) {
                    for ($j = $i + 1; $j -lt $parts.Length; $j++) {
                        if ($rules[$parts[$j]] -contains $parts[$i]) {
                            # generate new order and test if valid
                            $newOrder = $parts.Clone()
                            $newOrder[$i] = $parts[$j]
                            $newOrder[$j] = $parts[$i]
                            #Write-Host "New order: $newOrder"
                            $isValid = Test-Order -Update $newOrder -Rules $rules
                            if ($isValid) {
                                #Write-Host -ForegroundColor Green "IS VALID"
                                $middle = Get-MiddleElement -Array $newOrder
                                $sum += $middle
                                break
                            }
                            else {
                                $parts = $newOrder
                            }
                        }
                    }
                }
            }
        }
    }
    $sum
}

if ($Solve) {
    Invoke-Part1 -Path "input1.txt", "input2.txt"
    Invoke-Part2 -Path "input1.txt", "input2.txt"
}