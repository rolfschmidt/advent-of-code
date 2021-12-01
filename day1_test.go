package main

import (
    "testing"
)

func TestPart1(t *testing.T) {
    if Part1() != 1711 {
        t.Errorf("part 1 failed")
    }
}

func TestPart2(t *testing.T) {
    if Part2() != 1743 {
        t.Errorf("part 2 failed")
    }
}