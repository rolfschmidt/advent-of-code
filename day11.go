package main

import (
    "./helper"
)

func Day11Part1() int {
    return Day11Run(false)
}

func Day11Part2() int {
    return Day11Run(true)
}

type Day11Point struct {
    value int
    x int
    y int
}

func Day11PointExist(matrix [][]Day11Point, x int , y int) bool {
    if x < 0 || y < 0 || y > len(matrix) - 1 || x > len(matrix[y]) - 1 {
        return false
    }

    return true
}

func Day11Checked(checked map[string]bool, x int , y int) bool {
    if _, ok := checked[helper.Int2String(x) + "," + helper.Int2String(y)]; ok {
        return true
    }

    return false
}

func Day11Flash(matrix [][]Day11Point, px int, py int, checked map[string]bool) (int, map[string]bool) {
    if !Day11PointExist(matrix, px, py) || Day11Checked(checked, px,  py) {
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
        flash, checked = Day11Flash(matrix, px + 1, py, checked)
        result += flash

        // left
        flash = 0
        flash, checked = Day11Flash(matrix, px - 1, py, checked)
        result += flash

        // up
        flash = 0
        flash, checked = Day11Flash(matrix, px, py + 1, checked)
        result += flash

        // down
        flash = 0
        flash, checked = Day11Flash(matrix, px, py - 1, checked)
        result += flash

        // right up
        flash = 0
        flash, checked = Day11Flash(matrix, px + 1, py + 1, checked)
        result += flash

        // left up
        flash = 0
        flash, checked = Day11Flash(matrix, px - 1, py + 1, checked)
        result += flash

        // right down
        flash = 0
        flash, checked = Day11Flash(matrix, px + 1, py - 1, checked)
        result += flash

        // left down
        flash = 0
        flash, checked = Day11Flash(matrix, px - 1, py - 1, checked)
        result += flash
    }

    return result, checked
}

func Day11Run(Part2 bool) int {
    matrix := [][]Day11Point{}
    for y, line := range helper.ReadFile("day11.txt") {
        line := helper.Split(line, "")

        line_points := []Day11Point{}
        for x, v := range line {
            line_points = append(line_points, Day11Point{ value: helper.String2Int(v), x: x, y: y })
        }
        matrix = append(matrix, line_points)
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
                flash, checked = Day11Flash(matrix, point.x, point.y, checked)
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

