package main

import (
    "testing"
)

func TestDay3Part1(t *testing.T) {
	result := Day3Part1()
	t.Log("Day 3 Part 1:", result)
    if result != 3985686 {
        t.Errorf("part 1 failing")
    }
}

func TestDay3Part2(t *testing.T) {
	result := Day3Part2()
	t.Log("Day 3 Part 2:", result)
    if result != 2555739 {
        t.Errorf("part 1 failing")
    }
}
