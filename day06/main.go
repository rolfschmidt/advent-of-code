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
    content := helper.StringArrayInt(helper.Split(helper.ReadFileString("input.txt"), ","))

    newFish := 0
    days := 80
    for i := 0; i < days; i++ {
        for fi, _ := range content {
            if content[fi] > 0 {
                content[fi] -= 1
            } else {
                content[fi] = 6
                if content[fi] == 6 {
                    newFish += 1
                }
            }
        }

        for y := 0; y < newFish; y++ {
            content = append(content, 8)
        }
        newFish = 0
    }

    return len(content)
}

func RemoveFish(slice [][]int, s int) [][]int {
    return append(slice[:s], slice[s+1:]...)
}

func Part2() int {
    contentStr := helper.StringArrayInt(helper.Split(helper.ReadFileString("input.txt"), ","))

    var content [][]int
    for _, v := range contentStr {
        content = append(content, []int{v, 1})
    }

    newFish8 := 0
    newFish6 := 0
    days := 256
    for i := 0; i < days; i++ {
        for fi := 0; fi < len(content); fi++ {
            if content[fi][0] > 0 {
                content[fi][0] -= 1
            } else {
                newFish6 += content[fi][1]
                newFish8 += content[fi][1]
                content = RemoveFish(content, fi)
                fi -= 1
            }
        }

        if newFish6 > 0 {
            content = append(content, []int{6, newFish6})
            newFish6 = 0
        }
        if newFish8 > 0 {
            content = append(content, []int{8, newFish8})
            newFish8 = 0
        }
    }

    result := 0
    for _, fish := range content {
        result += fish[1]
    }

    return result
}
