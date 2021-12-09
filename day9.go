package main

import (
    "sort"
    "./helper"
)

func Day9Part1() int {
    return Day9Run(false)
}

func Day9Part2() int {
    return Day9Run(true)
}

func Day9PointExist(matrix [][]Day9Point, x int , y int) bool {
    if x < 0 || y < 0 || y > len(matrix) - 1 || x > len(matrix[y]) - 1 {
        return false
    }

    return true
}

func Day9Checked(checked map[string]bool, x int , y int) bool {
    if _, ok := checked[helper.Int2String(x) + "," + helper.Int2String(y)]; ok {
        return true
    }

    return false
}

type Day9Point struct {
    value int
    x int
    y int
}

func (p Day9Point) low(matrix [][]Day9Point) bool {
    for y := -1; y < 2; y++ {
        cx := p.x
        cy := p.y + y

        if (cx == p.x && cy == p.y) || !Day9PointExist(matrix, cx, cy) {
            continue
        }

        if matrix[cy][cx].value <= p.value {
            return false
        }
    }

    for x := -1; x < 2; x++ {
        cx := p.x + x
        cy := p.y

        if (cx == p.x && cy == p.y) || !Day9PointExist(matrix, cx, cy) {
            continue
        }

        if matrix[cy][cx].value <= p.value {
            return false
        }
    }

    return true
}

func Day9Basin(matrix [][]Day9Point, px int, py int, checked map[string]bool) (int, map[string]bool) {
    if !Day9PointExist(matrix, px, py) || Day9Checked(checked, px,  py) || matrix[py][px].value == 9 {
        checked[helper.Int2String(px) + "," + helper.Int2String(py)] = true
        return 0, checked
    }

    result := 1
    checked[helper.Int2String(px) + "," + helper.Int2String(py)] = true

    // right
    basin := 0
    basin, checked = Day9Basin(matrix, px + 1, py, checked)
    result += basin

    // left
    basin = 0
    basin, checked = Day9Basin(matrix, px - 1, py, checked)
    result += basin

    // up
    basin = 0
    basin, checked = Day9Basin(matrix, px, py + 1, checked)
    result += basin

    // down
    basin = 0
    basin, checked = Day9Basin(matrix, px, py - 1, checked)
    result += basin

    return result, checked
}

func (p Day9Point) risk() int {
    return p.value + 1
}

func Day9Run(Part2 bool) int {
    matrix := [][]Day9Point{}
    for y, line := range helper.ReadFile("day9.txt") {
        line := helper.Split(line, "")

        line_points := []Day9Point{}
        for x, v := range line {
            line_points = append(line_points, Day9Point{ value: helper.String2Int(v), x: x, y: y })
        }
        matrix = append(matrix, line_points)
    }

    result := 0
    if !Part2 {
        for _, line := range matrix {
            for _, point := range line {
                if point.low(matrix) {
                    result += point.risk()
                }
            }
        }
    } else {

        basins := []int{}
        for _, line := range matrix {
            for _, point := range line {
                if point.low(matrix) {
                    basin, _ := Day9Basin(matrix, point.x, point.y, map[string]bool{})
                    basins = append(basins, basin)
                }
            }
        }

        sort.Ints(basins)
        return basins[len(basins) - 1] * basins[len(basins) - 2] * basins[len(basins) - 3]
    }

    return result
}

