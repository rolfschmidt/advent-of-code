package main

import (
    "testing"
)

func TestDay2Part1(t *testing.T) {
	result := Day2Part1()
	t.Log("Day 2 Part 1:", result)
    if result != int64(1451208) {
        t.Errorf("part 1 failing")
    }
}

func TestDay2Part2(t *testing.T) {
	result := Day2Part2()
	t.Log("Day 2 Part 2:", result)
    if result != int64(1620141160) {
        t.Errorf("part 1 failing")
    }
}
