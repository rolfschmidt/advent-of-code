package main

import (
    "fmt"
    "./helper"
)

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

func Day12MatrixDup(matrix map[string]int) map[string]int {
    result := map[string]int{}
    for key, value := range matrix {
        result[key] = value
    }
    return result
}

type Day12Cave struct {
    pos string
    matrix [][]string
}

func (ca Day12Cave) isBig() bool {
    return helper.IsUpper(ca.pos)
}

func (ca Day12Cave) routes() [][]string {
    result := [][]string{}
    for _, value := range ca.matrix {
        if value[0] == ca.pos {
            result = append(result, []string{ca.pos, value[1]})
        }
        if value[1] == ca.pos {
            result = append(result, []string{ca.pos, value[0]})
        }
    }

    return result
}

func (ca Day12Cave) single(checked map[string]int) bool {
    if checked["SINGLE"] > 0 {
        return false
    }

    routes := ca.routes()
    for _, route := range routes {
        if (Day12Cave{pos: route[1], matrix: ca.matrix}.isBig()) {
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

func (ca Day12Cave) paths(target string, checked map[string]int, Part2 bool) int {
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
        result += Day12Cave{pos: route[1], matrix: ca.matrix}.paths(target, Day12MatrixDup(checked), Part2)
    }

    return result
}

func Day12Run(Part2 bool) int {
    matrix := [][]string{}
    for _, line := range helper.ReadFile("day12.txt") {
        line := helper.Split(line, "-")
        matrix = append(matrix, []string{line[0], line[1]})
    }

    return Day12Cave{pos: "start", matrix: matrix}.paths("end", map[string]int{}, Part2)
}

