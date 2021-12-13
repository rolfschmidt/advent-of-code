package main

import (
    "testing"
)

func TestDay13Part1(t *testing.T) {
	result := Day13Part1()
	t.Log("Day13 Part 1:", result)
    if result != 675 {
        t.Errorf("part 1 failing")
    }
}

func TestDay13Part2(t *testing.T) {
	result := Day13Part2()
	t.Log("Day13 Part 2:", result)
    if result != 98 {
        t.Errorf("part 2 failing")
    }
}
