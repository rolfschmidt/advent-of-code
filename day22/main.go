package main

import (
    "fmt"
    "errors"
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

func IntBetween(value int, from int, to int) bool {
    if value < from || value > to {
        return false
    }
    return true
}

type CubeRange struct {
    turOn bool
    x1 int
    x2 int
    y1 int
    y2 int
    z1 int
    z2 int
}

func (cu CubeRange) Volume() int {
    vx := ((cu.x2 + 1) - cu.x1)
    vy := ((cu.y2 + 1) - cu.y1)
    vz := ((cu.z2 + 1) - cu.z1)
    return vx * vy * vz
}

func (cu CubeRange) Overlap(cu2 CubeRange) (CubeRange, error) {
    x1 := helper.IntMax(cu.x1, cu2.x1)
    x2 := helper.IntMin(cu.x2, cu2.x2)
    y1 := helper.IntMax(cu.y1, cu2.y1)
    y2 := helper.IntMin(cu.y2, cu2.y2)
    z1 := helper.IntMax(cu.z1, cu2.z1)
    z2 := helper.IntMin(cu.z2, cu2.z2)
    if x1 <= x2 && y1 <= y2 && z1 <= z2 {
        cube := CubeRange{false, x1, x2, y1, y2, z1, z2}
        if cu.turOn && cu2.turOn {
            return cube, nil
        } else if cu.turOn && !cu2.turOn {
            return cube, nil
        } else if !cu.turOn && cu2.turOn {
            cube.turOn = true
            return cube, nil
        } else if !cu.turOn && !cu2.turOn {
            cube.turOn = true
            return cube, nil
        }
    }

    return CubeRange{}, errors.New("failed")
}

func Run(Part2 bool) int {
    var cubeRanges []CubeRange = []CubeRange{}
    for _, line := range helper.ReadFile("input.txt") {
        cubeRange := CubeRange{}
        for _, part := range strings.Split(line, ",") {
            values := strings.Split(part, "=")
            varName := string(values[0][len(values[0]) - 1])
            rangeValue := helper.StringArrayInt(strings.Split(values[1], ".."))

            if varName == "x" {
                cubeRange.x1 = helper.IntMin(rangeValue[0], rangeValue[1])
                cubeRange.x2 = helper.IntMax(rangeValue[0], rangeValue[1])
            } else if varName == "y" {
                cubeRange.y1 = helper.IntMin(rangeValue[0], rangeValue[1])
                cubeRange.y2 = helper.IntMax(rangeValue[0], rangeValue[1])
            } else if varName == "z" {
                cubeRange.z1 = helper.IntMin(rangeValue[0], rangeValue[1])
                cubeRange.z2 = helper.IntMax(rangeValue[0], rangeValue[1])
            }
        }

        if !Part2 && (!IntBetween(cubeRange.x1, -50, 50) || !IntBetween(cubeRange.x2, -50, 50) || !IntBetween(cubeRange.y1, -50, 50) || !IntBetween(cubeRange.y2, -50, 50) || !IntBetween(cubeRange.z1, -50, 50) || !IntBetween(cubeRange.z2, -50, 50)) {
            continue
        }

        if strings.Count(line, "on") > 0 {
            cubeRange.turOn = true
        }
        cubeRanges = append(cubeRanges, cubeRange)
    }

    countNeg := 0
    countPos := 0
    onCubes := []CubeRange{}
    for _, currCube := range cubeRanges {
        mergedCubes := []CubeRange{}
        for _, onCube := range onCubes {
            oCube, err := onCube.Overlap(currCube)
            if err == nil {
                mergedCubes = append(mergedCubes, oCube)
            }
        }
        if currCube.turOn {
            onCubes = append(onCubes, currCube)
        }
        for _, merCube := range mergedCubes {
            onCubes = append(onCubes, merCube)
        }
    }

    for _, onCube := range onCubes {
        if onCube.turOn {
            countPos += onCube.Volume()
        } else {
            countNeg += onCube.Volume()
        }
    }

    return countPos - countNeg
}
