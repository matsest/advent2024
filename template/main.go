package main

import (
	"fmt"
)

func p1(input string) int {
	return 1
}

func p2(input string) int {
	return 2
}

func main(){
	puzzle_input := "foobar"
	fmt.Println(p1(puzzle_input))
	fmt.Println(p2(puzzle_input))
}