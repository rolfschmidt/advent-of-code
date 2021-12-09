package main

import (
    "./helper"
)

func Day3Part1() int {
    return Day3Run(false)
}

func Day3Part2() int {
    return Day3Run(true)
}

func Day3ValueStats(val_strings [][]string) ([]int, []int) {
    zeros := []int{0,0,0,0,0,0,0,0,0,0,0,0}
    ones := []int{0,0,0,0,0,0,0,0,0,0,0,0}
    for _, line := range val_strings {
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

func Day3Run(Part2 bool) int {
    val_strings := [][]string{}
    for _, line := range helper.ReadFile("day3.txt") {
        vals := helper.Split(line, "")
        val_strings = append(val_strings, vals)
    }

    zeros, ones := Day3ValueStats(val_strings)

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
        oxygen_vals := val_strings
        scrubber_vals := val_strings
        for i, _ := range zeros {
            oxygen_zeros, oxygen_ones := Day3ValueStats(oxygen_vals)
            scrubber_zeros, scrubber_ones := Day3ValueStats(scrubber_vals)

            oxygen_keep := ""
            if oxygen_zeros[i] == oxygen_ones[i] {
                oxygen_keep = "1"
            } else if oxygen_zeros[i] > oxygen_ones[i] {
                oxygen_keep = "0"
            } else {
                oxygen_keep = "1"
            }

            scrubber_keep := ""
            if scrubber_zeros[i] == scrubber_ones[i] {
                scrubber_keep = "0"
            } else if scrubber_zeros[i] < scrubber_ones[i] {
                scrubber_keep = "0"
            } else {
                scrubber_keep = "1"
            }

            var new_oxygen_vals [][]string
            var new_scrubber_vals [][]string
            for _, numbers := range oxygen_vals {
                if numbers[i] == oxygen_keep || len(oxygen_vals) == 1 {
                    new_oxygen_vals = append(new_oxygen_vals, numbers)
                }
            }
            for _, numbers := range scrubber_vals {
                if numbers[i] == scrubber_keep || len(scrubber_vals) == 1 {
                    new_scrubber_vals = append(new_scrubber_vals, numbers)
                }
            }

            oxygen_vals = new_oxygen_vals
            scrubber_vals = new_scrubber_vals
        }

        gamma   = helper.Join(oxygen_vals[0], "")
        epsilon = helper.Join(scrubber_vals[0], "")
    }

    return helper.Binary2Decimal(helper.String2Int(gamma)) * helper.Binary2Decimal(helper.String2Int(epsilon))
}