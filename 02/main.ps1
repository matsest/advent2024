[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    $Solve = $false
)

function Convert-Input {
    param (
        [string]$Path
    )
    $lines = Get-Content -Path $Path
    $reports = [System.Collections.ArrayList]@()
    foreach ($line in $lines) {
        $r = [System.Collections.ArrayList]@()
        $levels = $line.Split(" ")
        foreach ($level in $levels) {
            $r.Add([int]$level) | Out-Null
        }
        $reports.Add($r) | Out-Null
    }
    $reports
}

function Test-Report {
    param (
        [int[]]$Report,
        [int]$MinDiff = 1,
        [int]$MaxDiff = 3
    )
    Write-Debug "`n$Report"

    # check if report does not have duplicate levels
    if (($Report | Select-Object -Unique).Length -lt $Report.Length) {
        Write-Debug "Contains duplicates"
        return $false
    }

    # check if all levels are increasing or decreasing
    [string]$increasing = ($Report | Sort-Object) -join " "
    [string]$decreasing = ($Report | Sort-Object -Descending) -join " "
    [string]$reportAsString = $Report -join " "

    if ($reportAsString -eq $increasing) {
        Write-Debug "is increasing?"
        $isSafe = $true
    }
    elseif ($reportAsString -eq $decreasing) {
        Write-Debug "is decreasing?"
        $isSafe = $true
    }
    else {
        return $false
    }

    # check if diffs are within bounds
    for ($i = 0; $i -lt $Report.Count - 1; $i++) {
        $diff = [Math]::Abs($Report[$i + 1] - $Report[$i])
        Write-Debug "diff: $diff"
        if ($diff -lt $MinDiff -or $diff -gt $MaxDiff) {
            Write-Debug "Outside max/min diff"
            return $False
        }
        Write-Debug "Within max/min diff"
    }
    $isSafe
}

function Invoke-Part1 {
    param (
        [string]$Path
    )
    $reports = Convert-Input -Path $Path
    $safeReports = 0
    foreach ($report in $reports) {
        $isSafe = Test-Report $Report
        if ($isSafe) {
            $safeReports += 1
        }
    }

    $safeReports
}

function Invoke-Part2 {
    param (
        [string]$Path
    )
    $reports = Convert-Input -Path $Path
    $safeReports = 0
    foreach ($report in $reports) {
        $isSafe = Test-Report $Report
        if ($isSafe) {
            $safeReports += 1
        }
        else {
            # Check alternates
            for ($i = 0; $i -lt $report.Count - 1; $i++) {
                $copy = if ($i -eq 0) {
                    [int[]]$report[1..($Report.Count - 1)]
                }
                else {
                    [int[]]$report[0..($i - 1)] + [int[]]$report[($i + 1)..($report.Count - 1)]
                }
                $isSafe = Test-Report $copy
                if ($isSafe) {
                    $safeReports += 1
                    break
                }
            }
        }
    }

    $safeReports
}

if ($Solve) {
    Invoke-Part1 -Path "input.txt"
    Invoke-Part2 -Path "input.txt"
}