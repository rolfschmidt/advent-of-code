package main

import (
    "fmt"
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
    matrix := map[int]map[int]int{}
    content := helper.ReadFile("input.txt")

    for _, line := range content {
        numbers := []int{}
        parts := helper.Split(line, " ")
        for _, part := range parts {
            if part == "->" {
                continue
            }

            lineNumbers := helper.Split(part, ",")
            for _, lineNumber := range lineNumbers {
                numbers = append(numbers, helper.String2Int(lineNumber))
            }
        }

        maxX := helper.IntMax(numbers[0], numbers[2])
        minX := helper.IntMin(numbers[0], numbers[2])
        maxY := helper.IntMax(numbers[1], numbers[3])
        minY := helper.IntMin(numbers[1], numbers[3])

        if numbers[1] == numbers[3] {
            for i := minX; i <= maxX; i++ {
                if _, ok := matrix[i]; !ok {
                    matrix[i] = map[int]int{}
                }
                matrix[i][numbers[1]] += 1
            }
        } else if numbers[0] == numbers[2] {
            for i := minY; i <= maxY; i++ {
                if _, ok := matrix[numbers[0]]; !ok {
                    matrix[numbers[0]] = map[int]int{}
                }
                matrix[numbers[0]][i] += 1
            }
        }

        if Part2 && ( maxX - minX ) == ( maxY - minY ) {
            checkX := numbers[0]
            checkY := numbers[1]

            for true {
                if _, ok := matrix[checkX]; !ok {
                    matrix[checkX] = map[int]int{}
                }
                matrix[checkX][checkY] += 1

                if checkX == numbers[2] && checkY == numbers[3] {
                    break
                }

                if numbers[0] <= numbers[2] {
                    checkX += 1
                } else {
                    checkX -= 1
                }
                if numbers[1] <= numbers[3] {
                    checkY += 1
                } else {
                    checkY -= 1
                }
            }
        }
    }

    var result int
    for x := range matrix {
        for y := range matrix[x] {
            if matrix[x][y] > 1 {
                result += 1
            }
        }
    }

    return result
}