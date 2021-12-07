package main

import (
    "testing"
)

func TestDay7Part1(t *testing.T) {
	result := Day7Part1()
	t.Log("Day 7 Part 1:", result)
    if result != 337833 {
        t.Errorf("part 1 failing")
    }
}

func TestDay7Part2(t *testing.T) {
	result := Day7Part2()
	t.Log("Day 7 Part 2:", result)
    if result != 96678050 {
        t.Errorf("part 2 failing")
    }
}
