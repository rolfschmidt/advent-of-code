package main

import (
    "fmt"
    "github.com/rolfschmidt/advent-of-code-2021/helper"
)

var maxX int
var maxY int
var matrix map[int]map[int]Cucumber = map[int]map[int]Cucumber{}
var newMatrix map[int]map[int]Cucumber = map[int]map[int]Cucumber{}

func main() {
    fmt.Println("Part 1", Part1())
}

func Part1() int {
    return Run(false)
}

func Pos(x int, y int) (int, int) {
    if x > maxX {
        x = 0
    }
    if x < 0 {
        x = maxX
    }
    if y > maxY {
        y = 0
    }
    return x, y
}

func Print() {
    for y := 0; y <= maxY; y++ {
        for x := 0; x <= maxX; x++ {
            if _, ok := matrix[y]; ok {
                if matrix[y][x].name != "" {
                    fmt.Print(matrix[y][x].name)
                    continue
                }
            }

            fmt.Print(".")
        }
        fmt.Println()
    }
}

type Cucumber struct {
    name string
    x int
    y int
    dx int
    dy int
}

func (cu Cucumber) Add(x int, y int) {
    if _, ok := newMatrix[y]; !ok {
        newMatrix[y] = map[int]Cucumber{}
    }

    cu.x = x
    cu.y = y

    newMatrix[y][x] = cu
}

func (cu Cucumber) Move(allowedName string) bool {
    if cu.name != allowedName {
        cu.Add(cu.x, cu.y)
        return false
    }

    newX, newY := Pos(cu.x + cu.dx, cu.y + cu.dy)
    if matrix[newY][newX].name != "" {
        cu.Add(cu.x, cu.y)
        return false
    }

    cu.Add(newX, newY)

    return true
}

func Run(Part2 bool) int {
    for y, line := range helper.ReadFile("input.txt") {
        for x, value := range helper.Split(line, "") {
            if value == "." {
                continue
            }

            dx := 0
            dy := 0
            if value == ">" {
                dx = 1
            } else if value == "v" {
                dy = 1
            }

            if _, ok := matrix[y]; !ok {
                matrix[y] = map[int]Cucumber{}
            }

            matrix[y][x] = Cucumber{ value, x, y, dx, dy }
            maxX = helper.IntMax(maxX, x)
            maxY = helper.IntMax(maxY, y)
        }
    }

    moved := true
    counter := 0
    for moved {
        moved = false

        for _, allowedName := range []string{">", "v"} {
            newMatrix = map[int]map[int]Cucumber{}

            for y := range matrix {
                for x := range matrix[y] {
                    cucumberMoved := matrix[y][x].Move(allowedName)
                    if cucumberMoved {
                        moved = true
                    }
                }
            }

            matrix = newMatrix
        }

        counter++
    }

    return counter
}
