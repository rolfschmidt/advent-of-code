package main

import (
    "fmt"
    "strings"
    "./helper"
)

func main() {
    fmt.Println("Part: 1", Day4Part1())
    fmt.Println("Part: 2", Day4Part2())
}

func Day4Part1() int {
    return Day4Run(false)
}

func Day4Part2() int {
    return Day4Run(true)
}

type Day4BingoNumber struct {
    val int
    found bool
}

type Day4Bingo struct {
    matrix [][]Day4BingoNumber
    won bool
}

func (b Day4Bingo) find(number int) {
    for i, block_line := range b.matrix {
        for y, block_number := range block_line {
            if block_number.val != number {
                continue
            }

            b.matrix[i][y].found = true
        }
    }
}

func (b Day4Bingo) match_horizontal() bool {
    LINE:
    for _, block_line := range b.matrix {
        count := 0
        for _, block_number := range block_line {
            if !block_number.found {
                continue LINE
            }

            count += 1

            if count == 5 {
                return true
            }
        }
    }
    return false
}

func (b Day4Bingo) match_vertical() bool {
    LINE:
    for i := range b.matrix {
        count := 0
        for y := range b.matrix[i] {
            if !b.matrix[y][i].found {
                continue LINE
            }

            count += 1

            if count == 5 {
                return true
            }
        }
    }
    return false
}

func (b Day4Bingo) sum() int {
    result := 0
    for _, block_line := range b.matrix {
        for _, block_number := range block_line {
            if block_number.found {
                continue
            }

            result += block_number.val
        }
    }

    return result
}

func Day4Run(Part2 bool) int {
    content := helper.ReadFileString("day4.txt")
    block_parts := strings.Split(content, "\n\n")
    numbers, block_parts := helper.StringArrayInt(strings.Split(block_parts[0], ",")), block_parts[1:]

    var blocks []Day4Bingo
    for _, block := range block_parts {

        var new_block [][]Day4BingoNumber
        for _, block_line := range strings.Split(block, "\n") {
            if block_line == "" {
                continue
            }

            var new_line []Day4BingoNumber
            for _, block_number := range strings.Split(strings.TrimSpace(block_line), " ") {
                if block_number == "" {
                    continue
                }

                new_line = append(new_line, Day4BingoNumber{ val: helper.String2Int(block_number) })
            }

            new_block = append(new_block, new_line)
        }

        blocks = append(blocks, Day4Bingo{ matrix: new_block })
    }

    var check_numbers []int
    var last_sum int
    var last_number int
    for _, number := range numbers {
        check_numbers = append(check_numbers, number)
        for bi, bingo := range blocks {
            if bingo.won {
                continue
            }

            bingo.find(number)
            if bingo.match_horizontal() || bingo.match_vertical() {
                blocks[bi].won = true
                last_sum = bingo.sum()
                last_number = number
                if !Part2 {
                    return last_sum * number
                }
            }
        }
    }

    if Part2 {
        return last_sum * last_number
    }

    return 0
}