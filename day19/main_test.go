package main

import (
    "testing"
    "github.com/stretchr/testify/assert"
)

func TestPart1(t *testing.T) {
	result := Part1()
	t.Log(" Part 1:", result)
    if result != 3051 {
        t.Errorf("part 1 failing")
    }
}

func TestPart2(t *testing.T) {
	result := Part2()
	t.Log(" Part 2:", result)
    if result != 4812 {
        t.Errorf("part 2 failing")
    }
}
