package main

import (
    "./helper"
)

func Day8Part1() int {
    return Day8Run(false)
}

func Day8Part2() int {
    return Day8Run(true)
}

func Day8DiffSeq(s1 string, s2 string) []string {
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

func Day8ContainsSeq(s1 string, s2 string) bool {
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

func Day8Day8ContainsSeqCount(s1 string, s2 string) int {
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

func Day8Run(Part2 bool) int {

    content := [][]string{}
    for _, line := range helper.ReadFile("day08.txt") {
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

            leftmiddle := helper.Join(Day8DiffSeq(four, one), "")
            leftbottom := helper.Join(Day8DiffSeq(helper.Join(Day8DiffSeq(eight, seven), ""), four), "")

            zero := helper.StringArraySelect(configs, func(value string) bool {
                return len(value) == 6 && Day8ContainsSeq(value, one) && !Day8ContainsSeq(value, leftmiddle) && !Day8ContainsSeq(value, leftmiddle)
            })
            six := helper.StringArraySelect(configs, func(value string) bool {
                return len(value) == 6 && !Day8ContainsSeq(value, one) && Day8ContainsSeq(value, leftmiddle) && Day8ContainsSeq(value, leftbottom)
            })
            nine := helper.StringArraySelect(configs, func(value string) bool {
                return len(value) == 6 && Day8ContainsSeq(value, one) && Day8ContainsSeq(value, leftmiddle) && !Day8ContainsSeq(value, leftbottom)
            })

            two := helper.StringArraySelect(configs, func(value string) bool {
                return len(value) == 5 && !Day8ContainsSeq(value, one) && Day8Day8ContainsSeqCount(value, four) == 2 && !Day8ContainsSeq(value, leftmiddle) && Day8ContainsSeq(value, leftbottom)
            })
            three := helper.StringArraySelect(configs, func(value string) bool {
                return len(value) == 5 && Day8ContainsSeq(value, one) && Day8Day8ContainsSeqCount(value, six) == 4 && !Day8ContainsSeq(value, leftmiddle) && !Day8ContainsSeq(value, leftbottom)
            })
            five := helper.StringArraySelect(configs, func(value string) bool {
                return len(value) == 5 && !Day8ContainsSeq(value, one) && Day8Day8ContainsSeqCount(value, four) == 3 && Day8Day8ContainsSeqCount(value, six) == 5 && Day8ContainsSeq(value, leftmiddle) && !Day8ContainsSeq(value, leftbottom)
            })

            numbers := []string{zero, one, two, three, four, five, six, seven, eight, nine}
            var line_number string
            TARGET:
            for _, target := range targets {
                for ni, seq := range numbers {
                    if target == seq {
                        line_number += helper.Int2String(ni)
                        continue TARGET
                    }
                }
            }

            result += helper.String2Int(line_number)
        }
    }

    return result
}

