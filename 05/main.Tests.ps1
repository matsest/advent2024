BeforeAll {
    . "$psscriptroot/main.ps1"
}

Describe 'Test-Update' {
    $rules = @() # TODO

    It 'Is in correct order' {
        Test-Update -Update @(75, 47, 61, 53, 29) -Rules $rules | Should -Be $True
        Test-Update -Update @(97, 61, 53, 29, 13) -Rules $rules | Should -Be $True
        Test-Update -Update @(75, 29, 13) -Rules $rules | Should -Be $True

    }
    It 'Is not in correct order' {
        Test-Update -Update @(75, 97, 47, 61, 53) -Rules $rules | Should -Be $False
        Test-Update -Update @(61, 13, 29) -Rules $rules | Should -Be $False
        Test-Update -Update @(97, 13, 75, 29, 47) -Rules $rules | Should -Be $False
    }
}

Describe 'Part 1' {
    It 'test full matches expected output (143)' {
        Invoke-Part1 -Path "test.txt" | Should -Be 143
    }
}

#Describe 'Part 2' {
#    It 'test full matches expected output (9)' {
#        Invoke-Part2 -Path "test.txt" | Should -Be 9
#    }
#}