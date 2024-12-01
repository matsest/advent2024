package main

import "testing"
import "github.com/matsest/advent2024/utils"

func Test_p1(t *testing.T) {
	tests := []struct {
		name  string
		input string
		want  int
	}{
		{"default", "./test.txt", 11},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			puzzle_input, _ := utils.ReadLines(tt.input)
			if gotCount := p1(puzzle_input); gotCount != tt.want {
				t.Errorf("p1(%v) = %v, want %v", tt.input, gotCount, tt.want)
			}
		})
	}
}

func Test_p2(t *testing.T) {
	tests := []struct {
		name  string
		input string
		want  int
	}{
		{"default", "./test.txt", 31},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			puzzle_input, _ := utils.ReadLines(tt.input)
			if gotCount := p2(puzzle_input); gotCount != tt.want {
				t.Errorf("p2(%v) = %v, want %v", tt.input, gotCount, tt.want)
			}
		})
	}
}
