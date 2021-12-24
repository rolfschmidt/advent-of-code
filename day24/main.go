package main

import (
    "fmt"
    "strings"
    "strconv"
    "github.com/rolfschmidt/advent-of-code-2021/helper"
)

var cache map[[3]int]map[string]int = map[[3]int]map[string]int{}

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

func IsNumber(v string) bool {
    if _, err := strconv.Atoi(v); err == nil {
        return true
    }
    return false
}

func Num(v int) string {
    return helper.Int2String(v)
}

func varString(vars map[string]int) string {
    result := ""
    for key, value := range vars {
        result += "," + key +  ":" + helper.Int2String(value)
    }
    return result
}

func Run(Part2 bool) int {
    if Part2 {
        return 0
    }

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

    print := false

    // for ii := 13579246899999; ii > 10000000000000; ii-- {
    counter := 0
    LOOP:
    for i1 := 9; i1 > 1; i1-- {
    for i2 := 9; i2 > 1; i2-- {
    for i3 := 9; i3 > 1; i3-- {
    for i4 := 9; i4 > 1; i4-- {
    for i5 := 9; i5 > 1; i5-- {
    for i6 := 9; i6 > 1; i6-- {
    for i7 := 9; i7 > 1; i7-- {
    for i8 := 9; i8 > 1; i8-- {
    for i9 := 9; i9 > 1; i9-- {
    for i10 := 9; i10 > 1; i10-- {
    for i11 := 9; i11 > 1; i11-- {
    for i12 := 9; i12 > 1; i12-- {
    for i13 := 9; i13 > 1; i13-- {
    for i14 := 9; i14 > 1; i14-- {
        vars := map[string]int{}
        input := Num(i1) + Num(i2) + Num(i3) + Num(i4) + Num(i5) + Num(i6) + Num(i7) + Num(i8) + Num(i9) + Num(i10) + Num(i11) + Num(i12) + Num(i13) + Num(i14)
        input2 := input
        for ini, iniList := range instructions {
            cacheKey := [3]int{ini, helper.String2Int(string(input[0])), vars["z"]}
            if cv, ok := cache[cacheKey]; ok {
                continue
                // fmt.Println("use cache", len(cache), cacheKey)
                vars = cv
            } else {
                inputIndex := 1
                for _, lineSplit := range iniList {
                    var2 := 0
                    if len(lineSplit) > 2 {
                        if IsNumber(lineSplit[2]) {
                            var2 = helper.String2Int(lineSplit[2])
                        } else {
                            var2 = vars[lineSplit[2]]
                        }
                    }
                    // fmt.Println("lineSplit", lineSplit, var2)

                    if lineSplit[0] == "inp" {
                       vars[ lineSplit[1] ] = helper.String2Int(string(input[0]))
                       input = input[1:]
                       if print {
                           fmt.Println(lineSplit[1], "= i" + helper.Int2String(inputIndex))
                           inputIndex++
                       }
                    } else if lineSplit[0] == "mul" {
                        vars[ lineSplit[1] ] *= var2
                       if print {
                           fmt.Println(lineSplit[1], "*=", lineSplit[2])
                       }
                    } else if lineSplit[0] == "add" {
                        vars[ lineSplit[1] ] += var2
                       if print {
                           fmt.Println(lineSplit[1], "+=", lineSplit[2])
                       }
                    } else if lineSplit[0] == "mod" {
                        vars[ lineSplit[1] ] %= var2
                        if print {
                           fmt.Println(lineSplit[1], "%=", lineSplit[2])
                       }
                    } else if lineSplit[0] == "div" {
                        vars[ lineSplit[1] ] /= var2
                        if print {
                           fmt.Println(lineSplit[1], "/=", lineSplit[2])
                       }
                    } else if lineSplit[0] == "eql" {
                        if vars[ lineSplit[1] ] == var2 {
                            vars[ lineSplit[1] ] = 1
                        } else {
                            vars[ lineSplit[1] ] = 0
                        }
                        if print {
                           fmt.Println("if", lineSplit[1], "==", lineSplit[2], "{", lineSplit[1], "=", 1, "} else {", lineSplit[1], "= 0 }")
                       }
                    } else {
                        panic("wtf")
                    }
                }

                cache[cacheKey] = vars
                // fmt.Println(cacheKey, cache[cacheKey])
            }
        }

        if vars["z"] == 0 && 1 == 0 {
            fmt.Println("vars", input2, vars)
        }


        // i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12, i13, i14 = 1,3,5,7,9,2,4,6,8,9,9,9,9,9
        /*
        w, x, y, z := 0, 0, 0, 0

        w = i1
        // x = 0 // x *= 0
        // x += z
        // x %= 26
        // z /= 1
        // x += 10
        // x = 0 // if x == w { x = 1 } else { x = 0 }
        x = 1 // if x == 0 { x = 1 } else { x = 0 }
        // y = 0 // y *= 0
        // y += 25
        // y *= x
        // y += 1
        y = 26
        z *= y
        y = 0 // y *= 0
        y += w
        y += 15
        // y *= x
        z += y
        w = i2
        x = 0 // x *= 0
        x += z
        x %= 26
        // z /= 1
        x += 12
        if x == w { x = 1 } else { x = 0 }
        if x == 0 { x = 1 } else { x = 0 }
        y = 0 // y *= 0
        y += 25
        y *= x
        y += 1
        z *= y
        y = 0 // y *= 0
        y += w
        y += 8
        y *= x
        z += y
        w = i3
        x = 0 // x *= 0
        x += z
        x %= 26
        // z /= 1
        x += 15
        if x == w { x = 1 } else { x = 0 }
        if x == 0 { x = 1 } else { x = 0 }
        y = 0 // y *= 0
        y += 25
        y *= x
        y += 1
        z *= y
        y = 0 // y *= 0
        y += w
        y += 2
        y *= x
        z += y
        w = i4
        x = 0 // x *= 0
        x += z
        x %= 26
        z /= 26
        x += -9
        if x == w { x = 1 } else { x = 0 }
        if x == 0 { x = 1 } else { x = 0 }
        y = 0 // y *= 0
        y += 25
        y *= x
        y += 1
        z *= y
        y = 0 // y *= 0
        y += w
        y += 6
        y *= x
        z += y
        w = i5
        x = 0 // x *= 0
        x += z
        x %= 26
        // z /= 1
        x += 15
        if x == w { x = 1 } else { x = 0 }
        if x == 0 { x = 1 } else { x = 0 }
        y = 0 // y *= 0
        y += 25
        y *= x
        y += 1
        z *= y
        y = 0 // y *= 0
        y += w
        y += 13
        y *= x
        z += y
        w = i6
        x = 0 // x *= 0
        x += z
        x %= 26
        // z /= 1
        x += 10
        if x == w { x = 1 } else { x = 0 }
        if x == 0 { x = 1 } else { x = 0 }
        y = 0 // y *= 0
        y += 25
        y *= x
        y += 1
        z *= y
        y = 0 // y *= 0
        y += w
        y += 4
        y *= x
        z += y
        w = i7
        x = 0 // x *= 0
        x += z
        x %= 26
        // z /= 1
        x += 14
        if x == w { x = 1 } else { x = 0 }
        if x == 0 { x = 1 } else { x = 0 }
        y = 0 // y *= 0
        y += 25
        y *= x
        y += 1
        z *= y
        y = 0 // y *= 0
        y += w
        y += 1
        y *= x
        z += y
        w = i8
        x = 0 // x *= 0
        x += z
        x %= 26
        z /= 26
        x += -5
        if x == w { x = 1 } else { x = 0 }
        if x == 0 { x = 1 } else { x = 0 }
        y = 0 // y *= 0
        y += 25
        y *= x
        y += 1
        z *= y
        y = 0 // y *= 0
        y += w
        y += 9
        y *= x
        z += y
        w = i9
        x = 0 // x *= 0
        x += z
        x %= 26
        // z /= 1
        x += 14
        if x == w { x = 1 } else { x = 0 }
        if x == 0 { x = 1 } else { x = 0 }
        y = 0 // y *= 0
        y += 25
        y *= x
        y += 1
        z *= y
        y = 0 // y *= 0
        y += w
        y += 5
        y *= x
        z += y
        w = i10
        x = 0 // x *= 0
        x += z
        x %= 26
        z /= 26
        x += -7
        if x == w { x = 1 } else { x = 0 }
        if x == 0 { x = 1 } else { x = 0 }
        y = 0 // y *= 0
        y += 25
        y *= x
        y += 1
        z *= y
        y = 0 // y *= 0
        y += w
        y += 13
        y *= x
        z += y
        w = i11
        x = 0 // x *= 0
        x += z
        x %= 26
        z /= 26
        x += -12
        if x == w { x = 1 } else { x = 0 }
        if x == 0 { x = 1 } else { x = 0 }
        y = 0 // y *= 0
        y += 25
        y *= x
        y += 1
        z *= y
        y = 0 // y *= 0
        y += w
        y += 9
        y *= x
        z += y
        w = i12
        x = 0 // x *= 0
        x += z
        x %= 26
        z /= 26
        x += -10
        if x == w { x = 1 } else { x = 0 }
        if x == 0 { x = 1 } else { x = 0 }
        y = 0 // y *= 0
        y += 25
        y *= x
        y += 1
        z *= y
        y = 0 // y *= 0
        y += w
        y += 6
        y *= x
        z += y
        w = i13
        x = 0 // x *= 0
        x += z
        x %= 26
        z /= 26
        x += -1
        if x == w { x = 1 } else { x = 0 }
        if x == 0 { x = 1 } else { x = 0 }
        y = 0 // y *= 0
        y += 25
        y *= x
        y += 1
        z *= y
        y = 0 // y *= 0
        y += w
        y += 2
        y *= x
        z += y
        w = i14
        x = 0 // x *= 0
        x += z
        x %= 26
        z /= 26
        x += -11
        if x == w { x = 1 } else { x = 0 }
        if x == 0 { x = 1 } else { x = 0 }
        y = 0 // y *= 0
        y += 25
        y *= x
        y += 1
        z *= y
        y = 0 // y *= 0
        y += w
        y += 2
        y *= x
        z += y

        // vars 99999999999999 map[w:9 x:1 y:11 z:7623212595]
        if z == 0 || 1 == 1 {
            input := Num(i1) + Num(i2) + Num(i3) + Num(i4) + Num(i5) + Num(i6) + Num(i7) + Num(i8) + Num(i9) + Num(i10) + Num(i11) + Num(i12) + Num(i13) + Num(i14)
            fmt.Println("input", input)
            fmt.Println("w", w)
            fmt.Println("x", x)
            fmt.Println("y", y)
            fmt.Println("z", z)
            break LOOP
        }

        */
        /*
        vars := map[string]int{}
        input := Num(i1) + Num(i2) + Num(i3) + Num(i4) + Num(i5) + Num(i6) + Num(i7) + Num(i8) + Num(i9) + Num(i10) + Num(i11) + Num(i12) + Num(i13) + Num(i14)
        input2 := input

        inputIndex := 1
        for _, lineSplit := range instructions {
            var2 := 0
            if len(lineSplit) > 2 {
                if IsNumber(lineSplit[2]) {
                    var2 = helper.String2Int(lineSplit[2])
                } else {
                    var2 = vars[lineSplit[2]]
                }
            }
            // fmt.Println("lineSplit", lineSplit, var2)

            if lineSplit[0] == "inp" {
               vars[ lineSplit[1] ] = helper.String2Int(string(input[0]))
               input = input[1:]
               if print {
                   fmt.Println(lineSplit[1], "= i" + helper.Int2String(inputIndex))
                   inputIndex++
               }
            } else if lineSplit[0] == "mul" {
                vars[ lineSplit[1] ] *= var2
               if print {
                   fmt.Println(lineSplit[1], "*=", lineSplit[2])
               }
            } else if lineSplit[0] == "add" {
                vars[ lineSplit[1] ] += var2
               if print {
                   fmt.Println(lineSplit[1], "+=", lineSplit[2])
               }
            } else if lineSplit[0] == "mod" {
                vars[ lineSplit[1] ] %= var2
                if print {
                   fmt.Println(lineSplit[1], "%=", lineSplit[2])
               }
            } else if lineSplit[0] == "div" {
                vars[ lineSplit[1] ] /= var2
                if print {
                   fmt.Println(lineSplit[1], "/=", lineSplit[2])
               }
            } else if lineSplit[0] == "eql" {
                if vars[ lineSplit[1] ] == var2 {
                    vars[ lineSplit[1] ] = 1
                } else {
                    vars[ lineSplit[1] ] = 0
                }
                if print {
                   fmt.Println("if", lineSplit[1], "==", lineSplit[2], "{", lineSplit[1], "=", 1, "} else {", lineSplit[1], "= 0 }")
               }
            } else {
                panic("wtf")
            }
        }

        if vars["z"] == 0 || 1 == 1 {
            fmt.Println("vars", input2, vars)
        }



        */
        if print {}
        if counter % 100000 == 0 {
            input := Num(i1) + Num(i2) + Num(i3) + Num(i4) + Num(i5) + Num(i6) + Num(i7) + Num(i8) + Num(i9) + Num(i10) + Num(i11) + Num(i12) + Num(i13) + Num(i14)
            fmt.Println(input, len(cache))
        }
        counter++
        if 1 == 0 {
            break LOOP
        }
        // continue LOOP
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


    // fmt.Println("lines", lines)
    // fmt.Println("vars", vars)

    return 0
}
