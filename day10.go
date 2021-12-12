package main

import (
    "sort"
    "./helper"
)

func Day10Part1() int {
    return Day10Run(false)
}

func Day10Part2() int {
    return Day10Run(true)
}

func Day10Run(Part2 bool) int {
    pairs := map[string]string{
        "[": "]",
        "(": ")",
        "<": ">",
        "{": "}",
    }
    p1Points := map[string]int{
        ")": 3,
        "]": 57,
        "}": 1197,
        ">": 25137,
    }

    p2Points := map[string]int{
        "(": 1,
        "[": 2,
        "{": 3,
        "<": 4,
    }

    p1Result := 0
    p2Result := []int{}
    last := ""
    for _, line := range helper.ReadFile("day10.txt") {
        blocks := []string{}
        corrupted := false
        for i := 0; i < len(line); i++ {
            char := string(line[i])

            if _, ok := pairs[char]; ok {
                blocks = append(blocks, char)
            } else {
                if len(blocks) < 0 {
                    if !Part2 {
                        p1Result += p1Points[char]
                    }
                    corrupted = true
                    break
                }

                last, blocks = helper.StringArrayPop(blocks)
                if pairs[last] != char {
                    if !Part2 {
                        p1Result += p1Points[char]
                    }
                    corrupted = true
                    break
                }
            }
        }

        if corrupted {
            continue
        }

        if Part2 {
            count := 0
            for i := len(blocks) - 1; i >= 0; i-- {
                char := blocks[i]

                count *= 5
                count += p2Points[char]
            }

            p2Result = append(p2Result, count)
        }
    }

    if Part2 {
        sort.Ints(p2Result)
        return p2Result[len(p2Result)/2]
    }

    return p1Result
}

