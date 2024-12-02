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
    Write-Debug "$Report"
    
    # check if all increasing or all decreasing
    $increasing = $Report | Sort-Object
    $decreasing = $Report | Sort-Object -Descending
    if (($Report | Select-Object -Unique).Length -lt $Report.Length) {
        Write-Debug "Contains duplicates"
        return $false
    }

    if (!(Compare-Object -ReferenceObject $Report -DifferenceObject $increasing -PassThru -SyncWindow 0)) {
        Write-Debug "is increasing?"
        $isSafe = $true
    }
    elseif (!(Compare-Object -ReferenceObject $Report -DifferenceObject $decreasing -PassThru -SyncWindow 0)) {
        Write-Debug "is decreasing?"
        $isSafe = $true
    }
    
    else {
        return $false
    }

    # check diffs
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
        } else {
            # Check alternates
            for ($i = 0; $i -lt $report.Count; $i++) {
                $copy = [System.Collections.ArrayList]@()
                $copy.AddRange($report) | Out-Null
                $copy.RemoveAt($i) | Out-Null
                $isSafe = Test-Report $copy
                if($isSafe){
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