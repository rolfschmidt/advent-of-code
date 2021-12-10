package main

import (
    "testing"
)

func TestDay10Part1(t *testing.T) {
	result := Day10Part1()
	t.Log("Day10 Part 1:", result)
    if result != 240123 {
        t.Errorf("part 1 failing")
    }
}

func TestDay10Part2(t *testing.T) {
	result := Day10Part2()
	t.Log("Day10 Part 2:", result)
    if result != 3260812321 {
        t.Errorf("part 2 failing")
    }
}
