package main

import (
    "sort"
    "./helper"
)

func Day7Part1() int {
    return Day7Run(false)
}

func Day7Part2() int {
    return Day7Run(true)
}

func Day7Run(Part2 bool) int {
    content := helper.StringArrayInt(helper.Split(helper.Trim(helper.ReadFileString("day7.txt")), ","))

    sort.Ints(content)

    middle := content[len(content)/2]

    if Part2 {
        result := (1 << 31) - 1
        for middle := 0; middle <= content[len(content) - 1]; middle++ {
            check := Day7Fuel(middle, content, Part2)
            if check < result {
                result = check
            } else {
                break
            }
        }

        return result
    }

    return Day7Fuel(middle, content, Part2)
}

func Day7Fuel(middle int, content []int, Part2 bool) int {
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
