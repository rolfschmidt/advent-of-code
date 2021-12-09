package main

import (
    "./helper"
)

func Day6Part1() int {
    content := helper.StringArrayInt(helper.Split(helper.ReadFileString("day6.txt"), ","))

    new_fish := 0
    days := 80
    for i := 0; i < days; i++ {
        for fi, _ := range content {
            if content[fi] > 0 {
                content[fi] -= 1
            } else {
                content[fi] = 6
                if content[fi] == 6 {
                    new_fish += 1
                }
            }
        }

        for y := 0; y < new_fish; y++ {
            content = append(content, 8)
        }
        new_fish = 0
    }

    return len(content)
}

func Day6RemoveFish(slice [][]int, s int) [][]int {
    return append(slice[:s], slice[s+1:]...)
}

func Day6Part2() int {
    content_str := helper.StringArrayInt(helper.Split(helper.ReadFileString("day6.txt"), ","))

    var content [][]int
    for _, v := range content_str {
        content = append(content, []int{v, 1})
    }

    new_fish8 := 0
    new_fish6 := 0
    days := 256
    for i := 0; i < days; i++ {
        for fi := 0; fi < len(content); fi++ {
            if content[fi][0] > 0 {
                content[fi][0] -= 1
            } else {
                new_fish6 += content[fi][1]
                new_fish8 += content[fi][1]
                content = Day6RemoveFish(content, fi)
                fi -= 1
            }
        }

        if new_fish6 > 0 {
            content = append(content, []int{6, new_fish6})
            new_fish6 = 0
        }
        if new_fish8 > 0 {
            content = append(content, []int{8, new_fish8})
            new_fish8 = 0
        }
    }

    result := 0
    for _, fish := range content {
        result += fish[1]
    }

    return result
}
