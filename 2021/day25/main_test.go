package main

import (
    "testing"
)

func TestPart1(t *testing.T) {
    result := Part1()
    t.Log(" Part 1:", result)
    if result != 380 {
        t.Errorf("part 1 failing")
    }
}
