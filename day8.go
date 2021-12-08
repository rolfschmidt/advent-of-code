package main

import (
    "fmt"
    "strings"
    "strconv"
    "sort"
    "./helper"
)

func main() {
    fmt.Println("Part: 1", Day7Part1())
    fmt.Println("Part: 2", Day7Part2())
}

func Day7Part1() int {
    return Run(false)
}

func Day7Part2() int {
    return Run(true)
}

func StringSort(word string) string {
    s := []rune(word)
    sort.Slice(s, func(i int, j int) bool { return s[i] < s[j] })
    return string(s)
}

func StringArraySelect(arr []string, filter func(string) bool) string {
    for _, value := range arr {
        if filter(value) {
            return value
        }
    }
    return ""
}

func DiffSeq(s1 string, s2 string) []string {
    seq1 := strings.Split(s1, "")
    seq2 := strings.Split(s2, "")
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
    seq1 := strings.Split(s1, "")
    seq2 := strings.Split(s2, "")

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
    seq1 := strings.Split(s1, "")
    seq2 := strings.Split(s2, "")

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
    for _, line := range helper.ReadFile("day8.txt") {
        line := strings.Split(strings.TrimSpace(line), " ")
        content = append(content, line)
    }

    result := 0
    for _, line := range content {
        configs := []string{}
        for _, seq := range line {
            if seq == "|" {
                break
            }

            configs = append(configs, StringSort(seq))
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

            targets = append(targets, StringSort(seq))
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
            one := StringArraySelect(configs, func(value string) bool {
                return len(value) == 2
            })
            four := StringArraySelect(configs, func(value string) bool {
                return len(value) == 4
            })
            seven := StringArraySelect(configs, func(value string) bool {
                return len(value) == 3
            })
            eight := StringArraySelect(configs, func(value string) bool {
                return len(value) == 7
            })

            leftmiddle := strings.Join(DiffSeq(four, one)[:], "")
            leftbottom := strings.Join(DiffSeq(strings.Join(DiffSeq(eight, seven)[:], ""), four)[:], "")

            zero := StringArraySelect(configs, func(value string) bool {
                return len(value) == 6 && ContainsSeq(value, one) && !ContainsSeq(value, leftmiddle) && ContainsSeq(value, leftbottom)
            })
            six := StringArraySelect(configs, func(value string) bool {
                return len(value) == 6 && !ContainsSeq(value, one) && ContainsSeq(value, leftmiddle) && ContainsSeq(value, leftbottom)
            })
            nine := StringArraySelect(configs, func(value string) bool {
                return len(value) == 6 && ContainsSeq(value, one) && ContainsSeq(value, leftmiddle) && !ContainsSeq(value, leftbottom)
            })

            two := StringArraySelect(configs, func(value string) bool {
                return len(value) == 5 && !ContainsSeq(value, one) && ContainsSeqCount(value, four) == 2 && !ContainsSeq(value, leftmiddle) && ContainsSeq(value, leftbottom)
            })
            three := StringArraySelect(configs, func(value string) bool {
                return len(value) == 5 && ContainsSeq(value, one) && ContainsSeqCount(value, six) == 4 && !ContainsSeq(value, leftmiddle) && !ContainsSeq(value, leftbottom)
            })
            five := StringArraySelect(configs, func(value string) bool {
                return len(value) == 5 && !ContainsSeq(value, one) && ContainsSeqCount(value, four) == 3 && ContainsSeqCount(value, six) == 5 && ContainsSeq(value, leftmiddle) && !ContainsSeq(value, leftbottom)
            })

            numbers := []string{one, two, three, four, five, six, seven, eight, nine}
            var line_number string
            TARGET:
            for _, target := range targets {
                for ni, seq := range numbers {
                    //fmt.Println("check seq", target, seq)

                    if target == seq {
                        fmt.Println("match", ni+1, "'" + target + "'", "'" + seq + "'")
                        line_number += strconv.Itoa(ni+1)
                        continue TARGET
                    }
                }
            }

            if line_number == "5" {
                fmt.Println("configs", configs)
                fmt.Println("targets", targets)
                fmt.Println("numbers", numbers)
                fmt.Println("zero", zero, StringSort("cagedb"))
                fmt.Println("one", one, StringSort("ab"))
                fmt.Println("two", two, StringSort("gcdfa"))
                fmt.Println("three", three, StringSort("fbcad"))
                fmt.Println("four", four, StringSort("eafb"))
                fmt.Println("five", five, StringSort("cdfbe"))
                fmt.Println("six", six, StringSort("cdfgeb"))
                fmt.Println("seven", seven, StringSort("dab"))
                fmt.Println("eight", eight, StringSort("acedgfb"))
                fmt.Println("nine", nine, StringSort("cefabd"))
                fmt.Println("leftmiddle", leftmiddle)
                fmt.Println("leftbottom", leftbottom)
                fmt.Println("")
                fmt.Println("line_number", helper.String2Int(line_number))

                return 0
            }
            fmt.Println("line_number", helper.String2Int(line_number))

            result += helper.String2Int(line_number)
        }
    }

    return result // 726404
}

