[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    $Solve = $false
)

function Find-AllDirections {
    param(
        [string[]]$Content
    )

    $rows = $content

    $columns = [System.Collections.ArrayList]@()
    for ($i = 0; $i -lt $content.Length; $i++) {
        $line = ''
        for ($j = 0; $j -lt $content[$i].Length; $j++) {
            $line += $content[$j][$i]
        }
        $columns.Add($line) | Out-Null
    }

    $diag1 = [System.Collections.ArrayList]@()
    for ($i = 0; $i -lt $content[0].Length + $content.Length - 1; $i++) {
        $line = ""
        for ($j = 0; $j -lt $content[0].Length; $j++) {
            $col = $i - $j
            if ($col -ge 0 -and $col -lt $content[0].Length) {
                $line += $content[$j][$col]
            }
        }
        if ($line) {
            $diag1 += $line
        }
    }

    $diag2 = [System.Collections.ArrayList]@()
    for ($i = 0; $i -lt $content[0].Length + $content.Length - 1; $i++) {
        $line = ""
        for ($j = 0; $j -lt $content.Length; $j++) {
            $col = $content.Length - 1 - ($i - $j)
            if ($col -ge 0 -and $col -lt $content[0].Length) {
                $line += $content[$j][$col]
            }
        }
        if ($line) {
            $diag2 += $line
        }
    }

    return @(
        [PSCustomObject]@{Name = 'rows'; Arr = $rows }
        [PSCustomObject]@{Name = 'cols'; Arr = $columns }
        [PSCustomObject]@{Name = 'diag1'; Arr = $diag1 }
        [PSCustomObject]@{Name = 'diag2'; Arr = $diag2 }
    )
}

function Invoke-Part1 {
    param (
        [string]$Path
    )
    [string[]]$content = Get-Content -Path $Path
    $directions = Find-AllDirections $content

    $sum = 0
    $patterns = $('XMAS', 'SAMX')
    foreach ($pattern in $patterns) {
        foreach ($dir in $directions) {
            $match = $dir.Arr | Select-String -Pattern $pattern -CaseSensitive -AllMatches
            $sum += $match.Matches.Length
        }
    }
    $sum
}

function Invoke-Part2 {
    param (
        [string]$Path
    )
    [string[]]$content = Get-Content -Path $Path

    # loop through each inner element and check corners for the 4 valid configurations of a MAS cross
    for ($i = 1; $i -lt $content.Length - 1; $i++) {
        for ($j = 1; $j -lt $content[0].Length - 1; $j++) {
            if ($content[$i][$j] -eq 'A') {
                #option 1
                # M S
                # M S
                if ($content[$i - 1][$j - 1] -eq 'M' -and $content[$i + 1][$j - 1] -eq 'M' -and $content[$i - 1][$j + 1] -eq 'S' -and $content[$i + 1][$j + 1] -eq 'S') {
                    $sum += 1
                }
                #option 2
                # M M
                # S S
                elseif ($content[$i - 1][$j - 1] -eq 'M' -and $content[$i + 1][$j - 1] -eq 'S' -and $content[$i - 1][$j + 1] -eq 'M' -and $content[$i + 1][$j + 1] -eq 'S') {
                    $sum += 1
                }
                #option 3
                # S S
                # M M
                elseif ($content[$i - 1][$j - 1] -eq 'S' -and $content[$i + 1][$j - 1] -eq 'M' -and $content[$i - 1][$j + 1] -eq 'S' -and $content[$i + 1][$j + 1] -eq 'M') {
                    $sum += 1
                }
                #option 4
                # S M
                # S M
                elseif ($content[$i - 1][$j - 1] -eq 'S' -and $content[$i + 1][$j - 1] -eq 'S' -and $content[$i - 1][$j + 1] -eq 'M' -and $content[$i + 1][$j + 1] -eq 'M') {
                    $sum += 1
                }
            }
        }
    }
    $sum
}

if ($Solve) {
    Invoke-Part1 -Path "input.txt"
    Invoke-Part2 -Path "input.txt"
}