package main

import (
    "fmt"
    "strings"
    "github.com/rolfschmidt/advent-of-code-2021/helper"
)

var cache map[[4]int][]int = map[[4]int][]int{}

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

type Player struct {
    pos int
    score int
}

func (pp *Player) Move(vv int) {
    pp.pos = (pp.pos + vv - 1) % 10 + 1
    pp.score += pp.pos
}

type Die struct {
    idx int
    count int
}

func (dd *Die) Add() int {
    dd.idx = (dd.idx + 1) % 100
    dd.count += 1
    return dd.idx
}

func (dd *Die) Dice() (int, int, int) {
    return dd.Add(), dd.Add(), dd.Add()
}

type Game struct {
    player1 Player
    player2 Player
    die Die
    winner Player
    looser Player
    win int
}

func (gg *Game) Run() *Game {
    var player *Player
    GAME:
    for true {
        player = &gg.player1
        a, b, c := gg.die.Dice()
        player.Move(a + b + c)
        if player.score >= gg.win {
            gg.winner = gg.player1
            gg.looser = gg.player2
            break GAME
        }

        player = &gg.player2
        a, b, c = gg.die.Dice()
        player.Move(a + b + c)
        if player.score >= gg.win {
            gg.winner = gg.player2
            gg.looser = gg.player1
            break GAME
        }
    }

    return gg
}

func (gg Game) RunDeep() (int, int) {
    if gg.player1.score >= gg.win {
        return 1, 0
    }

    cacheKey := [4]int{ gg.player1.pos, gg.player2.pos, gg.player1.score, gg.player2.score }
    if cv, ok := cache[cacheKey]; ok {
        return cv[0], cv[1]
    }

    c1 := 0
    c2 := 0
    for _, r1 := range []int{1, 2, 3} {
        for _, r2 := range []int{1, 2, 3} {
            for _, r3 := range []int{1, 2, 3} {
                ng := Game{
                    win: gg.win,
                }
                ng.player1, ng.player2 = gg.player2, gg.player1

                ng.player1.Move(r1 + r2 + r3)
                cc2, cc1 := ng.RunDeep()

                c1 += cc1
                c2 += cc2
            }
        }
    }

    cache[cacheKey] = []int{c1, c2}
    return c1, c2
}

func (gg *Game) Part1() int {
    return gg.looser.score * gg.die.count
}

func Run(Part2 bool) int {
    players := []Player{}
    for _, line := range helper.ReadFile("input.txt") {
        lineSplit := strings.Split(line, ": ")
        players = append(players, Player{ pos: helper.String2Int(lineSplit[1]) })
    }

    if !Part2 {
        game := Game{
            player1: players[0],
            player2: players[1],
            die: Die{},
            win: 1000,
        }

        return game.Run().Part1()
    } else {
        game := Game{
            player1: players[1],
            player2: players[0],
            win: 21,
        }

        p1, p2 := game.RunDeep()
        return helper.IntMax(p1, p2)
    }

    return 0
}
