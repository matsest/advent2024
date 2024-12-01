[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    $Solve = $false
)

function Get-Numbers {
    param (
        [string]$Path,
        [switch]$Sort = $false
    )

    $nums1 = [System.Collections.ArrayList]@()
    $nums2 = [System.Collections.ArrayList]@()

    $lines = Get-Content -Path $Path
    foreach ($line in $lines) {
        $parts = $line -split "\s+"
        #Write-Host "$($parts[0]), $($parts[1])"
        $nums1.Add([int]$parts[0]) | Out-Null
        $nums2.Add([int]$parts[1]) | Out-Null
    }
    if ($Sort) {
        $nums1.Sort()
        $nums2.Sort()
    }

    $nums1, $nums2
}

function Invoke-Part1 {
    param (
        [string]$Path
    )
    $nums1, $nums2 = Get-Numbers -Path $Path -Sort
    #Write-Host "nums1: $($nums1 -join ",")"
    #Write-Host "nums2: $($nums2 -join ",")"
    $distance = 0
    for ($i = 0; $i -lt $nums1.Count; $i++) {
        $distance += [Math]::Abs($nums1[$i] - $nums2[$i])
    }

    $distance
}

function Invoke-Part2 {
    param (
        [string]$Path
    )
    $nums1, $nums2 = Get-Numbers -Path $Path
    #Write-Host "nums1: $($nums1 -join ",")"
    #Write-Host "nums2: $($nums2 -join ",")"
    [int]$similarities = 0
    $ht = @{}
    $nums2 | Group-Object | ForEach-Object { $ht.Add([int]$_.Name, [int]$_.Count)}
    for ($i = 0; $i -lt $nums1.Count; $i++) {
        [int]$a = $ht[$nums1[$i]] ?? 0
        $similarities += $($nums1[$i]) * $a
    }

    $similarities
}

if ($Solve) {
    Invoke-Part1 -Path "input.txt"
    Invoke-Part2 -Path "input.txt"
}