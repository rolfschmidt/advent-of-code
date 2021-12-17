package main

import (
    "fmt"
    "strings"
    "github.com/rolfschmidt/advent-of-code-2021/helper"
)

var Matrix [][]string = [][]string{}
var Caves map[string]*Cave

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

type Cave struct {
    pos string
    dataRoutes []*Cave
}

func (ca Cave) IsBig() bool {
    return helper.IsUpper(ca.pos)
}

func (ca *Cave) Routes() []*Cave {
    if len(ca.dataRoutes) > 0 {
        return ca.dataRoutes
    }

    result := []*Cave{}
    for _, value := range Matrix {
        if value[0] == ca.pos {
            result = append(result, Caves[value[1]])
        }
        if value[1] == ca.pos {
            result = append(result, Caves[value[0]])
        }
    }

    ca.dataRoutes = result

    return result
}

func (ca *Cave) Single(checked string) bool {
    if checkedIsSingle(checked) {
        return false
    }

    for _, cave := range ca.Routes() {
        if (cave.IsBig()) {
            return true
        }
    }

    return false
}

func (ca *Cave) checkCount(checked string) int {
    return strings.Count(checked, "," + ca.pos + ",")
}

func (ca *Cave) setChecked(checked string) string {
    return checked + "," + ca.pos + ","
}

func checkedIsSingle(checked string) bool {
    return strings.Count(checked, ",SINGLE,") > 0
}

func checkedSetSingle(checked string) string {
    return checked + ",SINGLE,"
}

//     start
//     /   \
// c--A-----b--d
//     \   /
//      end

func (ca *Cave) Paths(target string, checked string, Part2 bool) int {
    checkCount := ca.checkCount(checked)
    if checkCount > 0 {
        if !Part2 {
            return 0
        } else {
            single := ca.Single(checked)
            if ca.pos == "start" || (single && checkCount == 2) || !single {
                return 0
            }
        }
    }

    result := 0
    if ca.pos == target {
        checked = ca.setChecked(checked)
        return 1
    }
    if !ca.IsBig() {
        checked = ca.setChecked(checked)
        if checkCount == 1 {
            checked = checkedSetSingle(checked)
        }
    }

    for _, cave := range ca.Routes() {
        result += cave.Paths(target, checked, Part2)
    }

    return result
}

func Run(Part2 bool) int {
    Matrix = [][]string{}
    Caves = map[string]*Cave{}
    for _, line := range helper.ReadFile("input.txt") {
        line := helper.Split(line, "-")
        Matrix = append(Matrix, []string{line[0], line[1]})
        Caves[line[0]] = &Cave{pos: line[0]}
        Caves[line[1]] = &Cave{pos: line[1]}
    }

    return Caves["start"].Paths("end", "", Part2)
}

