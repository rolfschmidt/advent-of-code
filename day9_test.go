package main

import (
    "testing"
)

func TestDay9Part1(t *testing.T) {
	result := Day9Part1()
	t.Log("Day9 Part 1:", result)
    if result != 439 {
        t.Errorf("part 1 failing")
    }
}

func TestDay9Part2(t *testing.T) {
	result := Day9Part2()
	t.Log("Day 9 Part 2:", result)
    if result != 900900 {
        t.Errorf("part 2 failing")
    }
}
