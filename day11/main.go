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

type Point struct {
    value int
    x int
    y int
}

func PointExist(matrix [][]Point, x int , y int) bool {
    if x < 0 || y < 0 || y > len(matrix) - 1 || x > len(matrix[y]) - 1 {
        return false
    }

    return true
}

func Checked(checked map[string]bool, x int , y int) bool {
    if _, ok := checked[helper.Int2String(x) + "," + helper.Int2String(y)]; ok {
        return true
    }

    return false
}

func Flash(matrix [][]Point, px int, py int, checked map[string]bool) (int, map[string]bool) {
    if !PointExist(matrix, px, py) || Checked(checked, px,  py) {
        return 0, checked
    }

    result := 0
    matrix[py][px].value += 1
    if matrix[py][px].value > 9 {
        matrix[py][px].value = 0
        result += 1
        checked[helper.Int2String(px) + "," + helper.Int2String(py)] = true

        // right
        flash := 0
        flash, checked = Flash(matrix, px + 1, py, checked)
        result += flash

        // left
        flash = 0
        flash, checked = Flash(matrix, px - 1, py, checked)
        result += flash

        // up
        flash = 0
        flash, checked = Flash(matrix, px, py + 1, checked)
        result += flash

        // down
        flash = 0
        flash, checked = Flash(matrix, px, py - 1, checked)
        result += flash

        // right up
        flash = 0
        flash, checked = Flash(matrix, px + 1, py + 1, checked)
        result += flash

        // left up
        flash = 0
        flash, checked = Flash(matrix, px - 1, py + 1, checked)
        result += flash

        // right down
        flash = 0
        flash, checked = Flash(matrix, px + 1, py - 1, checked)
        result += flash

        // left down
        flash = 0
        flash, checked = Flash(matrix, px - 1, py - 1, checked)
        result += flash
    }

    return result, checked
}

func Run(Part2 bool) int {
    matrix := [][]Point{}
    for y, line := range helper.ReadFile("input.txt") {
        line := helper.Split(line, "")

        linePoints := []Point{}
        for x, v := range line {
            linePoints = append(linePoints, Point{ value: helper.String2Int(v), x: x, y: y })
        }
        matrix = append(matrix, linePoints)
    }

    result := 0
    max := 100
    if Part2 {
       max = (1 << 31) - 1
    }

    for i := 0; i < max; i++ {
        checked := map[string]bool{}

        for _, line := range matrix {
            for _, point := range line {
                flash := 0
                flash, checked = Flash(matrix, point.x, point.y, checked)
                result += flash
            }
        }

        if Part2 {
            zero := true
            MATRIX:
            for _, line := range matrix {
                for _, point := range line {
                    if point.value != 0 {
                        zero = false
                        break MATRIX
                    }
                }
            }

            if zero {
                return i+1
            }
        }
    }

    return result
}

