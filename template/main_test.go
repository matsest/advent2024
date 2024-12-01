package main

import "testing"

func Test_p1(t *testing.T) {
	tests := []struct {
		name      string
		args      string
		want int
	}{
		{"default", "args", 1},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if gotCount := p1(tt.args); gotCount != tt.want {
				t.Errorf("p1(%v) = %v, want %v", tt.args, gotCount, tt.want)
			}
		})
	}
}

func Test_p2(t *testing.T) {
	tests := []struct {
		name      string
		args      string
		want int
	}{
		{"default", "args", 2},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if gotCount := p2(tt.args); gotCount != tt.want {
				t.Errorf("p2(%v) = %v, want %v", tt.args, gotCount, tt.want)
			}
		})
	}
}