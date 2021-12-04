package main

import (
    "testing"
)

func TestDay1Part1(t *testing.T) {
	result := Day1Part1()
	t.Log("Day 1 Part 1:", result)
    if result != int64(1711) {
        t.Errorf("part 1 failing")
    }
}

func TestDay1Part2(t *testing.T) {
	result := Day1Part2()
	t.Log("Day 1 Part 2:", result)
    if result != int64(1743) {
        t.Errorf("part 2 failing")
    }
}
