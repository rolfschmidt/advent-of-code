package main

import (
    "testing"
)

func TestDay4Part1(t *testing.T) {
	result := Day4Part1()
	t.Log("Day4 Part 1:", result)
    if result != 12796 {
        t.Errorf("part 1 failing")
    }
}

func TestDay4Part2(t *testing.T) {
	result := Day4Part2()
	t.Log("Day4 Part 2:", result)
    if result != 18063 {
        t.Errorf("part 2 failing")
    }
}
