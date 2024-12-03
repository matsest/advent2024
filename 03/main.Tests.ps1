BeforeAll {
    . "$psscriptroot/main.ps1"
}

Describe 'Part 1' {
    It 'matches expected output (161)' {
        Invoke-Part1 -Path "test.txt" | Should -Be 161
    }
}

Describe 'Part 2' {
    It 'matches expected output (4)' {
        Invoke-Part2 -Path "test2.txt" | Should -Be 48
    }
}