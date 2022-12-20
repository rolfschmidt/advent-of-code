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

type BingoNumber struct {
    val int
    found bool
}

type Bingo struct {
    matrix [][]BingoNumber
    won bool
}

func (b Bingo) find(number int) {
    for i, blockLine := range b.matrix {
        for y, blockNumber := range blockLine {
            if blockNumber.val != number {
                continue
            }

            b.matrix[i][y].found = true
        }
    }
}

func (b Bingo) matchHorizontal() bool {
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

func (b Bingo) matchVertical() bool {
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

func (b Bingo) sum() int {
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

func Run(Part2 bool) int {
    content := helper.ReadFileString("input.txt")
    blockParts := helper.Split(content, "\n\n")
    numbers, blockParts := helper.StringArrayInt(helper.Split(blockParts[0], ",")), blockParts[1:]

    var blocks []Bingo
    for _, block := range blockParts {

        var newBlock [][]BingoNumber
        for _, blockLine := range helper.Split(block, "\n") {
            if blockLine == "" {
                continue
            }

            var newLine []BingoNumber
            for _, blockNumber := range helper.Split(blockLine, " ") {
                if blockNumber == "" {
                    continue
                }

                newLine = append(newLine, BingoNumber{ val: helper.String2Int(blockNumber) })
            }

            newBlock = append(newBlock, newLine)
        }

        blocks = append(blocks, Bingo{ matrix: newBlock })
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