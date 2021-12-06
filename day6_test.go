package main

import (
    "testing"
)

func TestDay6Part1(t *testing.T) {
	result := Day6Part1()
	t.Log("Day 6 Part 1:", result)
    if result != 380758 {
        t.Errorf("part 1 failing")
    }
}

func TestDay6Part2(t *testing.T) {
	result := Day6Part2()
	t.Log("Day 6 Part 2:", result)
    if result != 1710623015163 {
        t.Errorf("part 2 failing")
    }
}
