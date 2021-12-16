package main

import (
    "fmt"
    "../dijkstra"
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

func PointExist(matrix [][]int, x, y int) bool {
    if x < 0 || y < 0 || x > len(matrix) - 1 || y > len(matrix[x]) - 1 {
        return false
    }

    return true
}

func Run(Part2 bool) int {
    matrix := [][]int{}

    if Part2 {

        for y := 0; y < 5; y++ {
            for _, line := range helper.ReadFile("input.txt") {
                line := helper.Split(line, "")

                linePoints := []int{}
                for x := 0; x < 5; x++ {
                    for _, v := range line {
                        lp := helper.String2Int(v) + x + y
                        if lp > 9 {
                            lp = lp - 9
                        }

                        linePoints = append(linePoints, lp)
                    }
                }
                matrix = append(matrix, linePoints)
            }
        }
    } else {

        for _, line := range helper.ReadFile("input.txt") {
            line := helper.Split(line, "")

            linePoints := []int{}
            for _, v := range line {
                linePoints = append(linePoints, helper.String2Int(v))
            }
            matrix = append(matrix, linePoints)
        }
    }

    graph := dijkstra.NewGraph()

    for y := range matrix {
        for x := range matrix[y] {
            graph.AddVertex(y * len(matrix[y]) + x)
        }
    }

    for y := range matrix {
        for x := range matrix[y] {
            index := y * len(matrix[y]) + x
            if PointExist(matrix, y - 1, x) {
                graph.AddArc((y - 1) * len(matrix[y]) + x, index, int64(matrix[y][x]))
            }
            if PointExist(matrix, y + 1, x) {
                graph.AddArc((y + 1) * len(matrix[y]) + x, index, int64(matrix[y][x]))
            }
            if PointExist(matrix, y, x - 1) {
                graph.AddArc(y * len(matrix[y]) + x - 1, index, int64(matrix[y][x]))
            }
            if PointExist(matrix, y, x + 1) {
                graph.AddArc(y * len(matrix[y]) + x + 1, index, int64(matrix[y][x]))
            }
        }
    }

    best, err := graph.Shortest(0, len(matrix)*len(matrix[0])-1)
    if err != nil {
        fmt.Println(err)
    }

    return int(best.Distance)
}
