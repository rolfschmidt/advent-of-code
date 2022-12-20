package main

import (
    "fmt"
    "github.com/rolfschmidt/advent-of-code-2021/helper"
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

func DiffSeq(s1 string, s2 string) []string {
    seq1 := helper.Split(s1, "")
    seq2 := helper.Split(s2, "")
    result := []string{}

    for _, v1 := range seq1 {
        found := false
        for _, v2 := range seq2 {
            if v1 == v2 {
                found = true
                break
            }
        }

        if found {
            continue
        }

        result = append(result, v1)
    }

    return result
}

func ContainsSeq(s1 string, s2 string) bool {
    seq1 := helper.Split(s1, "")
    seq2 := helper.Split(s2, "")

    for _, v2 := range seq2 {
        found := false
        for _, v1 := range seq1 {
            if v1 == v2 {
                found = true
                break
            }
        }

        if !found {
            return false
        }
    }

    return true
}

func ContainsSeqCount(s1 string, s2 string) int {
    seq1 := helper.Split(s1, "")
    seq2 := helper.Split(s2, "")

    count := 0
    for _, v2 := range seq2 {
        for _, v1 := range seq1 {
            if v1 == v2 {
                count += 1
            }
        }
    }

    return count
}

func Run(Part2 bool) int {

    content := [][]string{}
    for _, line := range helper.ReadFile("input.txt") {
        line := helper.Split(line, " ")
        content = append(content, line)
    }

    result := 0
    for _, line := range content {
        configs := []string{}
        for _, seq := range line {
            if seq == "|" {
                break
            }

            configs = append(configs, helper.StringSort(seq))
        }

        targets := []string{}
        work := false
        for _, seq := range line {
            if seq == "|" {
                work = true
                continue
            }
            if !work {
                continue
            }

            targets = append(targets, helper.StringSort(seq))
        }

        if !Part2 {
            for _, seq := range targets {
                if len(seq) == 2 {
                    result += 1 // 1
                } else if len(seq) == 4 {
                    result += 1 // 4
                } else if len(seq) == 3 {
                    result += 1 // 7
                } else if len(seq) == 7 {
                    result += 1 // 8
                }
            }
        } else {

            //  4444
            // 5    1
            // 5    1
            //  6666
            // 7    2
            // 7    2
            //  3333
            one := helper.StringArraySelect(configs, func(value string) bool {
                return len(value) == 2
            })
            four := helper.StringArraySelect(configs, func(value string) bool {
                return len(value) == 4
            })
            seven := helper.StringArraySelect(configs, func(value string) bool {
                return len(value) == 3
            })
            eight := helper.StringArraySelect(configs, func(value string) bool {
                return len(value) == 7
            })

            leftmiddle := helper.Join(DiffSeq(four, one), "")
            leftbottom := helper.Join(DiffSeq(helper.Join(DiffSeq(eight, seven), ""), four), "")

            zero := helper.StringArraySelect(configs, func(value string) bool {
                return len(value) == 6 && ContainsSeq(value, one) && !ContainsSeq(value, leftmiddle) && !ContainsSeq(value, leftmiddle)
            })
            six := helper.StringArraySelect(configs, func(value string) bool {
                return len(value) == 6 && !ContainsSeq(value, one) && ContainsSeq(value, leftmiddle) && ContainsSeq(value, leftbottom)
            })
            nine := helper.StringArraySelect(configs, func(value string) bool {
                return len(value) == 6 && ContainsSeq(value, one) && ContainsSeq(value, leftmiddle) && !ContainsSeq(value, leftbottom)
            })

            two := helper.StringArraySelect(configs, func(value string) bool {
                return len(value) == 5 && !ContainsSeq(value, one) && ContainsSeqCount(value, four) == 2 && !ContainsSeq(value, leftmiddle) && ContainsSeq(value, leftbottom)
            })
            three := helper.StringArraySelect(configs, func(value string) bool {
                return len(value) == 5 && ContainsSeq(value, one) && ContainsSeqCount(value, six) == 4 && !ContainsSeq(value, leftmiddle) && !ContainsSeq(value, leftbottom)
            })
            five := helper.StringArraySelect(configs, func(value string) bool {
                return len(value) == 5 && !ContainsSeq(value, one) && ContainsSeqCount(value, four) == 3 && ContainsSeqCount(value, six) == 5 && ContainsSeq(value, leftmiddle) && !ContainsSeq(value, leftbottom)
            })

            numbers := []string{zero, one, two, three, four, five, six, seven, eight, nine}
            var lineNumber string
            TARGET:
            for _, target := range targets {
                for ni, seq := range numbers {
                    if target == seq {
                        lineNumber += helper.Int2String(ni)
                        continue TARGET
                    }
                }
            }

            result += helper.String2Int(lineNumber)
        }
    }

    return result
}

