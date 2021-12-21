package main

import (
    "fmt"
    "strings"
    "math"
    "github.com/rolfschmidt/advent-of-code-2021/helper"
)

var lights string;
var matrix map[int]map[int]string;
var flip = false

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

func MatrixGet(x int, y int) string {
    if _, ok := matrix[y]; !ok {
        if flip {
            return "1"
        } else {
            return "0"
        }
    }
    if _, ok := matrix[y][x]; !ok {
        if flip {
            return "1"
        } else {
            return "0"
        }
    }
    return matrix[y][x]
}

func MatrixRange() (int, int, int, int) {
    minY := math.MaxInt32 - 1
    maxY := -1
    minX := math.MaxInt32 - 1
    maxX := -1

    for y := range matrix {
        minY = helper.IntMin(minY, y)
        maxY = helper.IntMax(maxY, y)
        for x := range matrix[y] {
            minX = helper.IntMin(minX, x)
            maxX = helper.IntMax(maxX, x)
        }
    }

    return minY, maxY, minX, maxX
}

func MatrixPrint() {
    minY, maxY, minX, maxX := MatrixRange()

    for y := minY; y <= maxY; y++ {
        for x := minX; x <= maxX; x++ {
            vv := MatrixGet(x, y)
            if vv == "1" {
                fmt.Print("#")
            } else {
                fmt.Print(".")
            }
        }
        fmt.Println()
    }
}

func MatrixValueMap(check string) string {
    return string(lights[helper.Binary2Int(check)])
}

func MatrixRun() map[int]map[int]string {
    minY, maxY, minX, maxX := MatrixRange()

    newMatrix := map[int]map[int]string{}
    for y := minY - 3; y <= maxY + 3; y++ {
        for x := minX - 3; x <= maxX + 3; x++ {
            check := ""
            for dy := -1; dy < 2; dy += 1 {
                for dx := -1; dx < 2; dx += 1 {
                    check += MatrixGet(x + dx, y + dy)
                }
            }

            if _, ok := newMatrix[y]; !ok {
                newMatrix[y] = map[int]string{}
            }

            newMatrix[y][x] = MatrixValueMap(check)
        }
    }

    return newMatrix
}

func MatrixLit() int {
    minY, maxY, minX, maxX := MatrixRange()

    count := 0
    for y := minY; y <= maxY; y++ {
        for x := minX; x <= maxX; x++ {
            if MatrixGet(x, y) == "1" {
                count += 1
            }
        }
    }

    return count
}

func Run(Part2 bool) int {
    content := strings.Replace(strings.Replace(helper.ReadFileString("input.txt"), ".", "0", -1), "#", "1", -1)
    parts := helper.Split(content, "\n\n")

    lights = parts[0]
    matrix = map[int]map[int]string{}

    for li, line := range helper.Split(parts[1], "\n") {
        row := map[int]string{}
        for ic, char := range helper.Split(line, "") {
            row[ic] = char
        }

        matrix[li] = row
    }

    rounds := 2
    if Part2 {
        rounds = 50
    }

    for r := 0; r < rounds; r += 1 {
        matrix = MatrixRun()
        if MatrixValueMap("0") == "1" {
            flip = !flip
        }
    }

    return MatrixLit()
}
