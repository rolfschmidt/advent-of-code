package main

import (
    "testing"
)

func TestDay11Part1(t *testing.T) {
	result := Day11Part1()
	t.Log("Day11 Part 1:", result)
    if result != 1683 {
        t.Errorf("part 1 failing")
    }
}

func TestDay11Part2(t *testing.T) {
	result := Day11Part2()
	t.Log("Day11 Part 2:", result)
    if result != 788 {
        t.Errorf("part 2 failing")
    }
}
