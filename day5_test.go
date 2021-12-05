package main

import (
    "testing"
)

func TestDay5Part1(t *testing.T) {
	result := Day5Part1()
	t.Log("Day 5 Part 1:", result)
    if result != 5147 {
        t.Errorf("part 1 failing")
    }
}

func TestDay5Part2(t *testing.T) {
	result := Day5Part2()
	t.Log("Day 5 Part 2:", result)
    if result != 16925 {
        t.Errorf("part 2 failing")
    }
}
