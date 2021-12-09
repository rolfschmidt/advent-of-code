package main

import (
    "testing"
)

func TestDay8Part1(t *testing.T) {
	result := Day8Part1()
	t.Log("Day8 Part 1:", result)
    if result != 355 {
        t.Errorf("part 1 failing")
    }
}

func TestDay8Part2(t *testing.T) {
	result := Day8Part2()
	t.Log("Day8 Part 2:", result)
    if result != 983030 {
        t.Errorf("part 2 failing")
    }
}
