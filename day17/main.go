package main

import (
    "fmt"
    "strings"
    "../helper"
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
    input := helper.ReadFileString("input.txt")

    xs := helper.String2Int(input[strings.IndexByte(input, '=')+1:strings.IndexByte(input, '.')])
    input = input[strings.IndexByte(input, '.')+2:]

    xe := helper.String2Int(input[:strings.IndexByte(input, ',')])
    input = input[strings.IndexByte(input, ',')+4:]

    ys := helper.String2Int(input[:strings.IndexByte(input, '.')])
    input = input[strings.IndexByte(input, '.')+2:]

    ye := helper.String2Int(input)

    matrix := map[int]map[int]int{}
    for y := ys; y <= ye; y++ {
        for x := xs; x <= xe; x++ {
            if _, ok := matrix[y]; !ok {
                matrix[y] = map[int]int{}
            }

            matrix[y][x] = 1
        }
    }

    result := 0
    for vx := 0; vx < 1000; vx += 1 {
        for vy := -1000; vy < 1000; vy += 1 {
            px := 0
            py := 0
            rx := vx
            ry := vy
            hp := 0
            for px < xe && py > ys {
                px += rx
                py += ry
                hp = helper.IntMax(hp, py)

                if _, ok := matrix[py]; !ok {
                    matrix[py] = map[int]int{}
                }

                if matrix[py][px] == 1 {
                    if !Part2 {
                        result = helper.IntMax(hp, result)
                    } else {
                        result += 1
                    }
                    break
                }

                if rx > 0 {
                    rx -= 1
                }
                ry -= 1
            }
        }
    }

    return result
}
