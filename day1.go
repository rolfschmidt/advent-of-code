package main

import (
    "fmt"
    "./helper"
)

func main() {
    fmt.Println("part 1: ", Part1())
    fmt.Println("part 2: ", Part2())
}

func Part1() int64 {
    last := int64(0)
    result := int64(0)
    var numbers []int64
    for _, line := range helper.ReadFile("day1.txt") {
        val := helper.String2Int64(line)
        numbers = append(numbers, val)
        if val > last && last != 0 {
            result += 1
        }
        last = val
    }

    return result
}

func Part2() int64 {
    numbers := helper.StringArray2Int64Array(helper.ReadFile("day1.txt"))
    result := int64(0)
    for i, _ := range numbers {
        val1 := int64(0)
        val2 := int64(0)
        for y := i; y < len(numbers) && y < i + 3; y++ {
            val1 += numbers[y]
        }
        for y := i + 1; y < len(numbers) && y < i + 4; y++ {
            val2 += numbers[y]
        }

        if val2 > val1 {
            result += 1
        }
    }
    return result
}