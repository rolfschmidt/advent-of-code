package main

import (
    "testing"
)

func TestPart1(t *testing.T) {
	result := Part1()
	t.Log(" Part 1:", result)
    if result != 12796 {
        t.Errorf("part 1 failing")
    }
}

func TestPart2(t *testing.T) {
	result := Part2()
	t.Log(" Part 2:", result)
    if result != 18063 {
        t.Errorf("part 2 failing")
    }
}
