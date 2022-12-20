package main

import (
    "fmt"
    "github.com/rolfschmidt/advent-of-code-2021/helper"
)

func main() {
    fmt.Println("Part 1", Part1())
    fmt.Println("Part 2", Part2())
}

func Part1() int64 {
    return Run(false)
}

func Part2() int64 {
    return Run(true)
}

func Run(Part2 bool) int64 {
    distance := int64(0)
    depth := int64(0)
    aim := int64(0)
    for _, line := range helper.ReadFile("input.txt") {
        vals := helper.Split(line, " ")
        valType := vals[0]
        valVal := helper.String2Int64(vals[1])

        if valType == "forward" {
            distance += valVal
            if Part2 {
                depth += valVal * aim
            }
        } else if valType == "down" {
            if !Part2 {
                depth += valVal
            } else {
                aim += valVal
            }
        } else if valType == "up" {
            if !Part2 {
                depth -= valVal
            } else {
                aim -= valVal
            }
        }
    }

    return distance * depth
}