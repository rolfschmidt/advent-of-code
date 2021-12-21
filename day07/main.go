package main

import (
    "fmt"
    "sort"
    "math"
    "github.com/rolfschmidt/advent-of-code-2021/helper"
)

func main() {
    fmt.Println("Part 1", Part1())
    fmt.Println("Part 2", Part2())
}

func Part1() int {
    return Run(false)
}

func Part2() int {
    return Run(true)
}

func Run(Part2 bool) int {
    content := helper.StringArrayInt(helper.Split(helper.ReadFileString("input.txt"), ","))

    sort.Ints(content)

    middle := content[len(content)/2]

    if Part2 {
        result := math.MaxInt32
        for middle := 0; middle <= content[len(content) - 1]; middle++ {
            check := Fuel(middle, content, Part2)
            if check < result {
                result = check
            } else {
                break
            }
        }

        return result
    }

    return Fuel(middle, content, Part2)
}

func Fuel(middle int, content []int, Part2 bool) int {
    result := 0
    for _, number := range content {
        if number == middle {
            continue
        }

        if !Part2 {
            result += helper.IntMax(number, middle) - helper.IntMin(number, middle)
        } else {
            for i := 1; i <= (helper.IntMax(number, middle) - helper.IntMin(number, middle)); i++ {
                result += i
            }
        }
    }

    return result
}
