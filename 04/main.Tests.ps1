BeforeAll {
    . "$psscriptroot/main.ps1"
}

Describe 'Part 1' {
    It 'test full matches expected output (18)' {
        Invoke-Part1 -Path "test.txt" | Should -Be 18
    }
    It 'test partial matches expected output (18)' {
        Invoke-Part1 -Path "test2.txt" | Should -Be 18
    }
}

Describe 'Part 2' {
    It 'test full matches expected output (9)' {
        Invoke-Part2 -Path "test.txt" | Should -Be 9
    }
    It 'test partial matches expected output (9)' {
        Invoke-Part2 -Path "test3.txt" | Should -Be 9
    }
}