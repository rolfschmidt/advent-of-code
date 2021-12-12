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
    data_routes [][]string
}

func (ca Day12Cave) isBig() bool {
    return helper.IsUpper(ca.pos)
}

func (ca *Day12Cave) routes() [][]string {
    if len(ca.data_routes) > 0 {
        return ca.data_routes
    }

    result := [][]string{}
    for _, value := range Day12Matrix {
        if value[0] == ca.pos {
            result = append(result, []string{ca.pos, value[1]})
        }
        if value[1] == ca.pos {
            result = append(result, []string{ca.pos, value[0]})
        }
    }

    ca.data_routes = result

    return result
}

func (ca *Day12Cave) single(checked map[string]int) bool {
    if checked["SINGLE"] > 0 {
        return false
    }

    for _, route := range ca.routes() {
        if (Day12Cave{pos: route[1]}.isBig()) {
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

func (ca *Day12Cave) paths(target string, checked map[string]int, Part2 bool) int {
    if checked[ca.pos] > 0 {
        if !Part2 {
            return 0
        } else {
            single := ca.single(checked)
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
    if !ca.isBig() {
        checked[ca.pos] += 1
        if checked[ca.pos] == 2 {
            checked["SINGLE"] = 1
        }
    }

    for _, route := range ca.routes() {
        result += Day12Caves[route[1]].paths(target, Day12CheckedDup(checked), Part2)
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

    return Day12Caves["start"].paths("end", map[string]int{}, Part2)
}

