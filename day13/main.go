package main

import (
    "fmt"
    "strings"
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

func AddPoint(matrix map[int]map[int]bool, x int, y int) map[int]map[int]bool {
    if _, ok := matrix[x]; !ok {
        matrix[x] = map[int]bool{}
    }

    matrix[x][y] = true

    return matrix
}

func MatrixMax(matrix map[int]map[int]bool) (int, int) {
    maxX := 0
    maxY := 0
    for x := range matrix {
        for y := range matrix[x] {
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

func FoldUp(oldMatrix map[int]map[int]bool, fY int) map[int]map[int]bool {
    matrix := map[int]map[int]bool{}
    for x := range oldMatrix {
        for y := range oldMatrix[x] {
            if y <= fY {
                matrix = AddPoint(matrix, x, y)
            } else {
                matrix = AddPoint(matrix, x, fY - (y - fY))
            }
        }
    }

    return matrix
}

func FoldLeft(oldMatrix map[int]map[int]bool, fX int) map[int]map[int]bool {
    matrix := map[int]map[int]bool{}
    for x := range oldMatrix {
        for y := range oldMatrix[x] {
            if x <= fX {
                matrix = AddPoint(matrix, x, y)
            } else {
                matrix = AddPoint(matrix, fX - (x - fX), y)
            }
        }
    }

    return matrix
}

func Run(Part2 bool) int {
    matrix := map[int]map[int]bool{}
    folds := [][]int{}
    content := helper.ReadFileString("input.txt");
    parts := helper.Split(content, "\n\n")
    for _, line := range helper.Split(parts[0], "\n") {
        lineParts := helper.Split(line, ",")

        lx := helper.String2Int(lineParts[0])
        ly := helper.String2Int(lineParts[1])

        matrix = AddPoint(matrix, lx, ly)
    }

    for _, line := range helper.Split(parts[1], "\n") {
        if strings.Count(line, "fold along y=") > 0 {
            y := helper.String2Int(strings.Replace(line, "fold along y=", "", -1))
            folds = append(folds, []int{0, y})
        } else if strings.Count(line, "fold along x=") > 0 {
            x := helper.String2Int(strings.Replace(line, "fold along x=", "", -1))
            folds = append(folds, []int{1, x})
        }
    }

    maxX, maxY := MatrixMax(matrix)
    count := 0
    print := false
    for _, fold := range folds {
        count = 0
        if fold[0] == 0 {
            matrix = FoldUp(matrix, fold[1])
            maxY = fold[1] - 1
        } else if fold[0] == 1 {
            matrix = FoldLeft(matrix, fold[1])
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

