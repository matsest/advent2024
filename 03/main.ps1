[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    $Solve = $false
)

function Invoke-Part1 {
    param (
        [string]$Path
    )
    [string[]]$memories = Get-Content -Path $Path
    $sum = 0

    foreach ($memory in $memories) {
        $pattern = 'mul\(\d+,\d+\)'
        $sections = ($memory | Select-String -Pattern $pattern -AllMatches).Matches.Value

        foreach ($section in $sections) {
            [int[]]$nums = ($section | Select-String -Pattern '\d+' -AllMatches).Matches.Value
            $partsum = $nums[0] * $nums[1]
            #Write-Host "$section, $($nums[0]), $($nums[1])"
            $sum += $partsum
        }
    }
    $sum
}

function Invoke-Part2 {
    param (
        [string]$Path
    )
    [string[]]$memories = Get-Content -Path $Path
    $sum = 0

    $enabled = $true
    foreach ($memory in $memories) {
        $sectionPattern = 'mul\(\d+,\d+\)'
        [array]$sections = ($memory | Select-String -Pattern $sectionPattern -AllMatches).Matches
        $instPattern = 'do(n''t)?\(\)'
        [array]$instructions = ($memory | Select-String -Pattern $instPattern -AllMatches).Matches
        [array]$inst = $sections + $instructions | Select-Object Index, Value | Sort-Object -Property Index

        for ($i = 0; $i -lt $inst.Count; $i++) {
            #Write-Host "$enabled ($($inst[$i].Index)) $($inst[$i].Value)"
            if ($inst[$i].Value -eq "don't()") {
                $enabled = $false
                continue
            }
            elseif ($inst[$i].Value -eq "do()") {
                $enabled = $true
                continue
            }

            if ($enabled) {
                [int[]]$nums = ($inst[$i].Value | Select-String -Pattern '\d+' -AllMatches).Matches.Value
                $partsum = $nums[0] * $nums[1]
                $sum += $partsum
                #Write-Host "--> $($nums[0]), $($nums[1]). Sum: $sum"
            }
        }
    }
    $sum
}

if ($Solve) {
    Invoke-Part1 -Path "input.txt"
    Invoke-Part2 -Path "input.txt"
}