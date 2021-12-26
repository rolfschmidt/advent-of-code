package main

import (
    "fmt"
    "os"
    "math"
    "strings"
    "strconv"
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

func RunCommand(iniList [][]string, z int, input int) map[string]int {
    vars := map[string]int{"z": z}
    for _, lineSplit := range iniList {
        if lineSplit[0] == "inp" {
           vars[ lineSplit[1] ] = input
        } else {
            var2 := 0
            if vi, err := strconv.Atoi(lineSplit[2]); err == nil {
                var2 = vi
            } else {
                var2 = vars[lineSplit[2]]
            }

            if lineSplit[0] == "mul" {
                vars[ lineSplit[1] ] *= var2
            } else if lineSplit[0] == "add" {
                vars[ lineSplit[1] ] += var2
            } else if lineSplit[0] == "mod" {
                vars[ lineSplit[1] ] %= var2
            } else if lineSplit[0] == "div" {
                vars[ lineSplit[1] ] /= var2
            } else if lineSplit[0] == "eql" {
                if vars[ lineSplit[1] ] == var2 {
                    vars[ lineSplit[1] ] = 1
                } else {
                    vars[ lineSplit[1] ] = 0
                }
            }
        }
    }

    return vars
}

func IniSave(ini int, zList []int) {
    f, _ := os.Create("cache_ini_" + helper.Int2String(ini) + ".txt")
    defer f.Close()

    writeStr := helper.Join(helper.IntArrayString(zList), ",")
    f.WriteString(writeStr)
}

func IniLoad(ini int) []int {
    result := []int{}
    for _, value := range strings.Split(helper.ReadFileString("cache_ini_" + helper.Int2String(ini) + ".txt"), ",") {
        result = append(result, helper.String2Int(value))
    }

    return result
}

func Run(Part2 bool) int {
    lines := helper.ReadFile("input.txt")
    instructions := [][][]string{}

    row := [][]string{}
    for _, line := range lines {
        command := strings.Split(line, " ")
        if command[0] == "inp" && len(row) > 0 {
            instructions = append(instructions, row)
            row = [][]string{}
        }

        row = append(row, command)
    }
    instructions = append(instructions, row)

    zList := map[int][]int{}
    zList[len(instructions) - 1] = []int{0}
    for ini := len(instructions) - 1; ini > 0; ini-- {
        zList[ini - 1] = IniLoad(ini - 1)
        if len(zList[ini - 1]) > 0 {
            continue
        }

        if len(zList[ini]) < 1 {
            break
        }

        for w := 1; w < 10; w++ {
            fmt.Println(w, "...")
            for z := 1; z < 10_000_000; z++ {
                vars := RunCommand(instructions[ini], z, w)
                if helper.IntArrayContains(zList[ini], vars["z"]) {
                    zList[ini - 1] = append(zList[ini - 1], z)
                }
            }
        }

        IniSave(ini - 1, zList[ini - 1])
    }

    minV := math.MaxInt
    maxV := 0
    vars := map[string]int{}
    for i1 := 9; i1 > 0; i1-- {
        vars := RunCommand(instructions[0], vars["z"], i1)
        if !helper.IntArrayContains(zList[0], vars["z"]) {
            continue
        }
    for i2 := 9; i2 > 0; i2-- {
        vars := RunCommand(instructions[1], vars["z"], i2)
        if !helper.IntArrayContains(zList[1], vars["z"]) {
            continue
        }
    for i3 := 9; i3 > 0; i3-- {
        vars := RunCommand(instructions[2], vars["z"], i3)
        if !helper.IntArrayContains(zList[2], vars["z"]) {
            continue
        }
    for i4 := 9; i4 > 0; i4-- {
        vars := RunCommand(instructions[3], vars["z"], i4)
        if !helper.IntArrayContains(zList[3], vars["z"]) {
            continue
        }
    for i5 := 9; i5 > 0; i5-- {
        vars := RunCommand(instructions[4], vars["z"], i5)
        if !helper.IntArrayContains(zList[4], vars["z"]) {
            continue
        }
    for i6 := 9; i6 > 0; i6-- {
        vars := RunCommand(instructions[5], vars["z"], i6)
        if !helper.IntArrayContains(zList[5], vars["z"]) {
            continue
        }
    for i7 := 9; i7 > 0; i7-- {
        vars := RunCommand(instructions[6], vars["z"], i7)
        if !helper.IntArrayContains(zList[6], vars["z"]) {
            continue
        }
    for i8 := 9; i8 > 0; i8-- {
        vars := RunCommand(instructions[7], vars["z"], i8)
        if !helper.IntArrayContains(zList[7], vars["z"]) {
            continue
        }
    for i9 := 9; i9 > 0; i9-- {
        vars := RunCommand(instructions[8], vars["z"], i9)
        if !helper.IntArrayContains(zList[8], vars["z"]) {
            continue
        }
    for i10 := 9; i10 > 0; i10-- {
        vars := RunCommand(instructions[9], vars["z"], i10)
        if !helper.IntArrayContains(zList[9], vars["z"]) {
            continue
        }
    for i11 := 9; i11 > 0; i11-- {
        vars := RunCommand(instructions[10], vars["z"], i11)
        if !helper.IntArrayContains(zList[10], vars["z"]) {
            continue
        }
    for i12 := 9; i12 > 0; i12-- {
        vars := RunCommand(instructions[11], vars["z"], i12)
        if !helper.IntArrayContains(zList[11], vars["z"]) {
            continue
        }
    for i13 := 9; i13 > 0; i13-- {
        vars := RunCommand(instructions[12], vars["z"], i13)
        if !helper.IntArrayContains(zList[12], vars["z"]) {
            continue
        }
    for i14 := 9; i14 > 0; i14-- {
        vars := RunCommand(instructions[13], vars["z"], i14)
        if !helper.IntArrayContains(zList[13], vars["z"]) {
            continue
        }

        input := helper.String2Int(helper.Int2String(i1) + helper.Int2String(i2) + helper.Int2String(i3) + helper.Int2String(i4) + helper.Int2String(i5) + helper.Int2String(i6) + helper.Int2String(i7) + helper.Int2String(i8) + helper.Int2String(i9) + helper.Int2String(i10) + helper.Int2String(i11) + helper.Int2String(i12) + helper.Int2String(i13) + helper.Int2String(i14))

        minV = helper.IntMin(minV, input)
        maxV = helper.IntMax(maxV, input)
    }
    }
    }
    }
    }
    }
    }
    }
    }
    }
    }
    }
    }
    }

    if Part2 {
        return minV
    }

    return maxV
}
