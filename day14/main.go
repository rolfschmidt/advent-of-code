package main

import (
    "fmt"
    "../helper"
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

func Run(Part2 bool) int {
    content := helper.ReadFileString("input.txt");
    parts := helper.Split(content, "\n\n")
    start := parts[0]

    replace := map[string]string{}
    for _, line := range helper.Split(parts[1], "\n") {
        lineParts := helper.Split(line, " -> ")

        replace[lineParts[0]] = lineParts[1]
    }

    rounds := 10
    if Part2 {
        rounds = 40
    }

    charCount := map[string]int{}
    replaceCount := map[string]int{}
    for i := 0; i + 1 < len(start); i += 1 {
        charCount[string(start[i])] += 1
        replaceCount[string(start[i]) + string(start[i+1])] += 1
    }
    charCount[string(start[len(start) - 1])] += 1

    for r := 0; r < rounds; r++ {
        oldReplaceCount := map[string]int{}
        for key, value := range replaceCount {
            oldReplaceCount[key] = value
        }

        replaceCount = map[string]int{}
        for key, count := range oldReplaceCount {
            charCount[replace[key]] += count
            replaceCount[string(key[0]) + string(replace[key])] += count
            replaceCount[string(replace[key]) + string(key[1])] += count
        }
    }

    max := -1
    min := -1
    for _, count := range charCount {
        if count > max || max == -1 {
            max = count
        }
        if count < min || min == -1 {
            min = count
        }
    }

    return max - min
}

