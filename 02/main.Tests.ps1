BeforeAll {
    . "$psscriptroot/main.ps1"
}

Describe 'Test-Report' {
    It 'decreasing by two is safe' {
        Test-Report @(7, 6, 4, 2, 1) | Should -Be $True
    }
    It 'increasing by 1,2,3 is safe' {
        Test-Report @(1, 3, 6, 7, 9) | Should -Be $True
    }
    It 'increasing by five is unsafe' {
        Test-Report @(9, 7, 6, 2, 1) | Should -Be $False
    }
    It 'mixed increasing/decreasing is unsafe' {
        Test-Report @(1, 3, 2, 4, 5) | Should -Be $False
    }
    It 'no increase/decrease is unsafe' {
        Test-Report @(8, 6, 4, 4, 1) | Should -Be $False
    }
}

Describe 'Part 1' {
    It 'matches expected output (2)' {
        Invoke-Part1 -Path "test.txt" | Should -Be 2
    }
}

Describe 'Part 2' {
    It 'matches expected output (4)' {
        Invoke-Part2 -Path "test.txt" | Should -Be 4
    }
}