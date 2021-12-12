package main

import (
    "testing"
)

func TestDay12Part1(t *testing.T) {
	result := Day12Part1()
	t.Log("Day12 Part 1:", result)
    if result != 5252 {
        t.Errorf("part 1 failing")
    }
}

func TestDay12Part2(t *testing.T) {
	result := Day12Part2()
	t.Log("Day12 Part 2:", result)
    if result != 147784 {
        t.Errorf("part 2 failing")
    }
}
