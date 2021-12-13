package main

import (
    "fmt"
    "strings"
    "./helper"
)

func main() {
    fmt.Println("p1", Day13Part1())
    fmt.Println("p2", Day13Part2())
}

func Day13Part1() int {
    return Day13Run(false)
}

func Day13Part2() int {
    return Day13Run(true)
}

func Day13AddPoint(matrix map[int]map[int]bool, x int, y int) map[int]map[int]bool {
    if _, ok := matrix[x]; !ok {
        matrix[x] = map[int]bool{}
    }

    matrix[x][y] = true

    return matrix
}

func Day13MatrixMax(matrix map[int]map[int]bool) (int, int) {
    maxX := 0
    maxY := 0
    for x, _ := range matrix {
        for y, _ := range matrix[x] {
            if x > maxX {
                maxX = x
            }
            if y > maxY {
                maxY = y
            }
        }
    }

    return maxX, maxY
}

func Day13FoldUp(old_matrix map[int]map[int]bool, fY int, maxX int, maxY int) map[int]map[int]bool {
    matrix := map[int]map[int]bool{}
    for y := 0; y <= maxY; y++ {

        for x := 0; x <= maxX; x++ {
            if _, ok := old_matrix[x][y]; ok {
                if y <= fY {
                    matrix = Day13AddPoint(matrix, x, y)
                } else {
                    matrix = Day13AddPoint(matrix, x, fY - (y - fY))
                }
            }
        }
    }

    return matrix
}

func Day13FoldLeft(old_matrix map[int]map[int]bool, fX int, maxX int, maxY int) map[int]map[int]bool {
    matrix := map[int]map[int]bool{}
    for y := 0; y <= maxY; y++ {

        for x := 0; x <= maxX; x++ {
            if _, ok := old_matrix[x][y]; ok {
                if x <= fX {
                    matrix = Day13AddPoint(matrix, x, y)
                } else {
                    matrix = Day13AddPoint(matrix, fX - (x - fX), y)
                }
            }
        }
    }

    return matrix
}

func Day13Run(Part2 bool) int {
    matrix := map[int]map[int]bool{}
    folds := [][]int{}
    content := helper.ReadFileString("day13.txt");
    parts := helper.Split(content, "\n\n")
    for _, line := range helper.Split(parts[0], "\n") {
        line_parts := helper.Split(line, ",")

        lx := helper.String2Int(line_parts[0])
        ly := helper.String2Int(line_parts[1])

        matrix = Day13AddPoint(matrix, lx, ly)
    }

    for _, line := range helper.Split(parts[1], "\n") {
        if strings.Count(line, "fold along y=") > 0 {
            y := helper.String2Int(strings.Replace(line, "fold along y=", "", -1))
            folds = append(folds, []int{0, y})
        }
        if strings.Count(line, "fold along x=") > 0 {
            x := helper.String2Int(strings.Replace(line, "fold along x=", "", -1))
            folds = append(folds, []int{1, x})
        }
    }

    maxX, maxY := Day13MatrixMax(matrix)
    count := 0
    print := false
    for _, fold := range folds {
        count = 0
        if fold[0] == 0 {
            matrix = Day13FoldUp(matrix, fold[1], maxX, maxY)
            maxY = fold[1] - 1
        } else if fold[0] == 1 {
            matrix = Day13FoldLeft(matrix, fold[1], maxX, maxY)
            maxX = fold[1] - 1
        }

        for y := 0; y <= maxY; y++ {
            for x := 0; x <= maxX; x++ {
                if fold[0] == 0 && fold[1] == y {
                    if print {
                        fmt.Print("-")
                    }
                } else if fold[0] == 1 && fold[1] == x {
                    if print {
                        fmt.Print("|")
                    }
                } else if _, ok := matrix[x][y]; ok {
                    if print {
                        fmt.Print("#")
                    }
                    count += 1
                } else {
                    if print {
                        fmt.Print(".")
                    }
                }
            }
            if print {
                fmt.Println()
            }
        }

        if print {
            fmt.Println()
        }

        if !Part2 {
            return count
        }
    }

    return count
}

