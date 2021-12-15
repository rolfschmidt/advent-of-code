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

    for i, row := range matrix {
        for j := range row {
            graph.AddVertex(i*len(row) + j)
        }
    }

    for i, row := range matrix {
        for j, value := range row {
            index := i*len(row) + j
            if PointExist(matrix, i-1, j) {
                graph.AddArc((i-1)*len(row)+j, index, int64(value))
            }
            if PointExist(matrix, i+1, j) {
                graph.AddArc((i+1)*len(row)+j, index, int64(value))
            }
            if PointExist(matrix, i, j-1) {
                graph.AddArc((i)*len(row)+j-1, index, int64(value))
            }
            if PointExist(matrix, i, j+1) {
                graph.AddArc((i)*len(row)+j+1, index, int64(value))
            }
        }
    }

    best, err := graph.Shortest(0, len(matrix)*len(matrix[0])-1)
    if err != nil {
        fmt.Println(err)
    }

    return int(best.Distance)
}
