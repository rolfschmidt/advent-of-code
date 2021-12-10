package main

import (
    "fmt"
    "sort"
    "./helper"
)

func main() {
    fmt.Println("p1", Day10Part1())
    fmt.Println("p2", Day10Part2())
}

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
    p1_points := map[string]int{
        ")": 3,
        "]": 57,
        "}": 1197,
        ">": 25137,
    }

    p2_points := map[string]int{
        "(": 1,
        "[": 2,
        "{": 3,
        "<": 4,
    }

    p1_result := 0
    p2_result := []int{}
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
                        p1_result += p1_points[char]
                    }
                    corrupted = true
                    break
                }

                last, blocks = blocks[len(blocks) - 1], blocks[:len(blocks) - 1]
                if pairs[last] != char {
                    if !Part2 {
                        p1_result += p1_points[char]
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
                count += p2_points[char]
            }

            p2_result = append(p2_result, count)
        }
    }

    if Part2 {
        sort.Ints(p2_result)
        return p2_result[len(p2_result)/2]
    }

    return p1_result
}

