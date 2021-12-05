package main

import (
    "fmt"
    "strings"
    "./helper"
)

func main() {
    fmt.Println("Part: 1", Day5Part1())
    fmt.Println("Part: 2", Day5Part2())
}

func Day5Part1() int {
    return Day5Run(false)
}

func Day5Part2() int {
    return Day5Run(true)
}

func Day5Run(Part2 bool) int {
    matrix := map[int]map[int]int{}
    content := helper.ReadFile("day5.txt")

    for _, line := range content {
        numbers := []int{}
        parts := strings.Split(line, " ")
        for _, part := range parts {
            if part == "->" {
                continue
            }

            line_numbers := strings.Split(part, ",")
            for _, line_number := range line_numbers {
                numbers = append(numbers, helper.String2Int(line_number))
            }
        }

        max_x := helper.IntMax(numbers[0], numbers[2])
        min_x := helper.IntMin(numbers[0], numbers[2])
        max_y := helper.IntMax(numbers[1], numbers[3])
        min_y := helper.IntMin(numbers[1], numbers[3])

        if numbers[1] == numbers[3] {
            for i := min_x; i <= max_x; i++ {
                if _, ok := matrix[i]; !ok {
                    matrix[i] = map[int]int{}
                }
                matrix[i][numbers[1]] += 1
            }
        } else if numbers[0] == numbers[2] {
            for i := min_y; i <= max_y; i++ {
                if _, ok := matrix[numbers[0]]; !ok {
                    matrix[numbers[0]] = map[int]int{}
                }
                matrix[numbers[0]][i] += 1
            }
        }

        if Part2 && ( max_x - min_x ) == ( max_y - min_y ) {
            check_x := numbers[0]
            check_y := numbers[1]

            for true {
                if _, ok := matrix[check_x]; !ok {
                    matrix[check_x] = map[int]int{}
                }
                matrix[check_x][check_y] += 1

                if check_x == numbers[2] && check_y == numbers[3] {
                    break
                }

                if numbers[0] <= numbers[2] {
                    check_x += 1
                } else {
                    check_x -= 1
                }
                if numbers[1] <= numbers[3] {
                    check_y += 1
                } else {
                    check_y -= 1
                }
            }
        }
    }

    var result int
    for x, _ := range matrix {
        for y, _ := range matrix[x] {
            if matrix[x][y] > 1 {
                result += 1
            }
        }
    }

    return result
}