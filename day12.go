package main

import (
    "strings"
    "./helper"
)

var Day12Matrix [][]string = [][]string{}
var Day12Caves map[string]*Day12Cave

func Day12Part1() int {
    return Day12Run(false)
}

func Day12Part2() int {
    return Day12Run(true)
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

func (ca *Day12Cave) Single(checked string) bool {
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

func (ca *Day12Cave) checkCount(checked string) int {
    return strings.Count(checked, "," + ca.pos + ",")
}

func (ca *Day12Cave) setChecked(checked string) string {
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

func (ca *Day12Cave) Paths(target string, checked string, Part2 bool) int {
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

func Day12Run(Part2 bool) int {
    Day12Matrix = [][]string{}
    Day12Caves = map[string]*Day12Cave{}
    for _, line := range helper.ReadFile("day12.txt") {
        line := helper.Split(line, "-")
        Day12Matrix = append(Day12Matrix, []string{line[0], line[1]})
        Day12Caves[line[0]] = &Day12Cave{pos: line[0]}
        Day12Caves[line[1]] = &Day12Cave{pos: line[1]}
    }

    return Day12Caves["start"].Paths("end", "", Part2)
}

