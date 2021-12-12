package main

import (
    "fmt"
    "./helper"
)

var Day12Matrix [][]string = [][]string{}
var Day12Caves map[string]*Day12Cave

func main() {
    fmt.Println("p1", Day12Part1())
    fmt.Println("p2", Day12Part2())
}

func Day12Part1() int {
    return Day12Run(false)
}

func Day12Part2() int {
    return Day12Run(true)
}

func Day12CheckedDup(checked map[string]int) map[string]int {
    result := map[string]int{}
    for key, value := range checked {
        result[key] = value
    }
    return result
}

type Day12Cave struct {
    pos string
    dataRoutes []*Day12Cave
}

func (ca Day12Cave) IsBig() bool {
    return helper.IsUpper(ca.pos)
}

func (ca *Day12Cave) Routes() []*Day12Cave {
    if len(ca.dataRoutes) > 0 {
        return ca.dataRoutes
    }

    result := []*Day12Cave{}
    for _, value := range Day12Matrix {
        if value[0] == ca.pos {
            result = append(result, Day12Caves[value[1]])
        }
        if value[1] == ca.pos {
            result = append(result, Day12Caves[value[0]])
        }
    }

    ca.dataRoutes = result

    return result
}

func (ca *Day12Cave) Single(checked map[string]int) bool {
    if checked["SINGLE"] > 0 {
        return false
    }

    for _, cave := range ca.Routes() {
        if (cave.IsBig()) {
            return true
        }
    }

    return false
}

//     start
//     /   \
// c--A-----b--d
//     \   /
//      end

func (ca *Day12Cave) Paths(target string, checked map[string]int, Part2 bool) int {
    if checked[ca.pos] > 0 {
        if !Part2 {
            return 0
        } else {
            single := ca.Single(checked)
            if ca.pos == "start" || (single && checked[ca.pos] == 2) || !single {
                return 0
            }
        }
    }

    result := 0
    if ca.pos == target {
        checked[ca.pos] += 1
        return 1
    }
    if !ca.IsBig() {
        checked[ca.pos] += 1
        if checked[ca.pos] == 2 {
            checked["SINGLE"] = 1
        }
    }

    for _, cave := range ca.Routes() {
        result += cave.Paths(target, Day12CheckedDup(checked), Part2)
    }

    return result
}

func Day12Run(Part2 bool) int {
    Day12Matrix = [][]string{}
    Day12Caves = map[string]*Day12Cave{}
    for _, line := range helper.ReadFile("day12.txt") {
        line := helper.Split(line, "-")
        Day12Matrix = append(Day12Matrix, []string{line[0], line[1]})
        Day12Caves[line[0]] = &Day12Cave{pos: line[0]}
        Day12Caves[line[1]] = &Day12Cave{pos: line[1]}
    }

    return Day12Caves["start"].Paths("end", map[string]int{}, Part2)
}

