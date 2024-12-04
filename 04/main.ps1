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

function Test-Corners {
    param(
        [string[]]$Content,
        [int]$Row,
        [int]$Col,
        [string]$TopLeft,
        [string]$BottomLeft,
        [string]$TopRight,
        [string]$BottomRight
    )
    $i = $Row
    $j = $Col
    if ($content[$i - 1][$j - 1] -eq $TopLeft -and $content[$i + 1][$j - 1] -eq $BottomLeft -and $content[$i - 1][$j + 1] -eq $TopRight -and $content[$i + 1][$j + 1] -eq $BottomRight) {
        $true
    }
    $false
}

function Invoke-Part2 {
    param (
        [string]$Path
    )
    [string[]]$content = Get-Content -Path $Path

    $configurationsToTest = @(
        #option 1
        # M S
        #  A
        # M S
        'MMSS',
        #option 2
        # M M
        #  A
        # S S
        'MSMS'
        #option 3
        # S S
        #  A
        # M M
        'SMSM'
        #option 4
        # S M
        #  A
        # S M
        'SSMM'
    )

    # loop through each inner element and check corners for the 4 valid configurations of a cross-MAS
    for ($i = 1; $i -lt $content.Length - 1; $i++) {
        for ($j = 1; $j -lt $content[0].Length - 1; $j++) {
            if ($content[$i][$j] -eq 'A') {
                foreach ($c in $configurationsToTest) {
                    if (Test-Corners -Content $content -Row $i -Col $j -TopLeft $c[0] -BottomLeft $c[1] -TopRight $c[2] -BottomRight $c[3] ) {
                        $sum += 1
                    }
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