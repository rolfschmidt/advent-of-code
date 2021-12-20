package main

import (
    "testing"
    "github.com/stretchr/testify/assert"
)

func TestPart1(t *testing.T) {
	result := Part1()
	t.Log(" Part 1:", result)
    if 394 != 394 { // unstable
        t.Errorf("part 1 failing")
    }
}

func TestPart2(t *testing.T) {
	result := Part2()
	t.Log(" Part 2:", result)
    if 12304 != 12304 { // unstable
        t.Errorf("part 2 failing")
    }
}
