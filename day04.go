package main

import (
    "./helper"
)

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
    for i, blockLine := range b.matrix {
        for y, blockNumber := range blockLine {
            if blockNumber.val != number {
                continue
            }

            b.matrix[i][y].found = true
        }
    }
}

func (b Day4Bingo) matchHorizontal() bool {
    LINE:
    for _, blockLine := range b.matrix {
        count := 0
        for _, blockNumber := range blockLine {
            if !blockNumber.found {
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

func (b Day4Bingo) matchVertical() bool {
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
    for _, blockLine := range b.matrix {
        for _, blockNumber := range blockLine {
            if blockNumber.found {
                continue
            }

            result += blockNumber.val
        }
    }

    return result
}

func Day4Run(Part2 bool) int {
    content := helper.ReadFileString("day04.txt")
    blockParts := helper.Split(content, "\n\n")
    numbers, blockParts := helper.StringArrayInt(helper.Split(blockParts[0], ",")), blockParts[1:]

    var blocks []Day4Bingo
    for _, block := range blockParts {

        var newBlock [][]Day4BingoNumber
        for _, blockLine := range helper.Split(block, "\n") {
            if blockLine == "" {
                continue
            }

            var newLine []Day4BingoNumber
            for _, blockNumber := range helper.Split(blockLine, " ") {
                if blockNumber == "" {
                    continue
                }

                newLine = append(newLine, Day4BingoNumber{ val: helper.String2Int(blockNumber) })
            }

            newBlock = append(newBlock, newLine)
        }

        blocks = append(blocks, Day4Bingo{ matrix: newBlock })
    }

    var checkNumbers []int
    var lastSum int
    var lastNumber int
    for _, number := range numbers {
        checkNumbers = append(checkNumbers, number)
        for bi, bingo := range blocks {
            if bingo.won {
                continue
            }

            bingo.find(number)
            if bingo.matchHorizontal() || bingo.matchVertical() {
                blocks[bi].won = true
                lastSum = bingo.sum()
                lastNumber = number
                if !Part2 {
                    return lastSum * number
                }
            }
        }
    }

    if Part2 {
        return lastSum * lastNumber
    }

    return 0
}