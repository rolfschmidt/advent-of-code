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

func ValueStats(valStrings [][]string) ([]int, []int) {
    zeros := []int{0,0,0,0,0,0,0,0,0,0,0,0}
    ones := []int{0,0,0,0,0,0,0,0,0,0,0,0}
    for _, line := range valStrings {
        for i, number := range line {
            if number == "0" {
                zeros[i] += 1
            } else {
                ones[i] += 1
            }
        }
    }

    return zeros, ones
}

func Run(Part2 bool) int {
    valStrings := [][]string{}
    for _, line := range helper.ReadFile("input.txt") {
        vals := helper.Split(line, "")
        valStrings = append(valStrings, vals)
    }

    zeros, ones := ValueStats(valStrings)

    gamma := ""
    epsilon := ""
    for i, _ := range zeros {
        if zeros[i] > ones[i] {
            gamma = gamma + "0"
        } else {
            gamma = gamma + "1"
        }

        if zeros[i] < ones[i] {
            epsilon = epsilon + "0"
        } else {
            epsilon = epsilon + "1"
        }
    }

    if Part2 {
        oxygenVals := valStrings
        scrubberVals := valStrings
        for i, _ := range zeros {
            oxygenZeros, oxygenOnes := ValueStats(oxygenVals)
            scrubberZeros, scrubberOnes := ValueStats(scrubberVals)

            oxygenKeep := ""
            if oxygenZeros[i] == oxygenOnes[i] {
                oxygenKeep = "1"
            } else if oxygenZeros[i] > oxygenOnes[i] {
                oxygenKeep = "0"
            } else {
                oxygenKeep = "1"
            }

            scrubberKeep := ""
            if scrubberZeros[i] == scrubberOnes[i] {
                scrubberKeep = "0"
            } else if scrubberZeros[i] < scrubberOnes[i] {
                scrubberKeep = "0"
            } else {
                scrubberKeep = "1"
            }

            var newOxygenVals [][]string
            var newScrubberVals [][]string
            for _, numbers := range oxygenVals {
                if numbers[i] == oxygenKeep || len(oxygenVals) == 1 {
                    newOxygenVals = append(newOxygenVals, numbers)
                }
            }
            for _, numbers := range scrubberVals {
                if numbers[i] == scrubberKeep || len(scrubberVals) == 1 {
                    newScrubberVals = append(newScrubberVals, numbers)
                }
            }

            oxygenVals = newOxygenVals
            scrubberVals = newScrubberVals
        }

        gamma   = helper.Join(oxygenVals[0], "")
        epsilon = helper.Join(scrubberVals[0], "")
    }

    return helper.Binary2Decimal(helper.String2Int(gamma)) * helper.Binary2Decimal(helper.String2Int(epsilon))
}