package main

import (
	"fmt"
	"math"
	"slices"
	"strconv"
	"strings"

	"github.com/matsest/advent2024/utils"
)

func getNumbers(input []string) (nums1, nums2 []int) {
	for _, v := range input {
		fields := strings.Fields(v)
		n1, err := strconv.Atoi(string(fields[0]))
		if err == nil {
			nums1 = append(nums1, n1)
		}
		n2, err := strconv.Atoi(string(fields[1]))
		if err == nil {
			nums2 = append(nums2, n2)
		}
	}
	return nums1, nums2
}

func findInSlice(n int, nums []int) (appears int) {
	for _, v := range nums {
		if v == n {
			appears += 1
		}
	}
	return appears
}

func p1(input []string) int {
	distance := 0
	nums1, nums2 := getNumbers(input)
	slices.Sort(nums1)
	slices.Sort(nums2)

	for i := range nums1 {
		d := int(math.Abs(float64(nums1[i] - nums2[i])))
		distance += d
	}
	return distance
}

func p2(input []string) int {
	similarities := 0
	nums1, nums2 := getNumbers(input)
	appears := make(map[int]int) // map to save appearances

	for _, v := range nums1 {
		a, err := appears[v] // check map first
		if !err {
			a = findInSlice(v, nums2)
			appears[v] = a
		}
		similarities += v * a
	}
	return similarities
}

func main() {
	puzzle_input, _ := utils.ReadLines("./input.txt")
	fmt.Println(p1(puzzle_input))
	fmt.Println(p2(puzzle_input))
}
