BeforeAll {
    . "$psscriptroot/main.ps1"
}

Describe 'Part 1' {
    It 'matches expected output (11)' {
        Invoke-Part1 -Path "test.txt" | Should -Be 11
    }
}

Describe 'Part 2' {
    It 'matches expected output (31)' {
        Invoke-Part2 -Path "test.txt" | Should -Be 31
    }
}