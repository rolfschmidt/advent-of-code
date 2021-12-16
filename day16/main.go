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
    return Run(false)
}

func Part2() int {
    return Run(true)
}

type Package struct {
    version int
    typeID int
    literal int
    subs []Package
}

func ParseNext(input string) (string, []Package) {
    result := []Package{}

    version := helper.Binary2Int(input[0:3])
    typeID := helper.Binary2Int(input[3:6])

    if typeID == 4 {
        total := ""

        endIndex := 6
        for true {
            lastGroup := helper.Binary2Int(input[endIndex:endIndex+1])
            total += input[endIndex+1:endIndex+5]

            endIndex += 5
            if lastGroup == 0 {
                break
            } else {
            }
        }

        literal := helper.Binary2Int(total)

        pkg := Package{
            version: version,
            typeID: typeID,
            literal: literal,
        }

        input = input[endIndex:]
        result = append(result, pkg)
    } else {
        length := input[6:7]
        if length == "0" {
            valueL := helper.Binary2Int(input[7:22])

            subs := []Package{}
            start := input[22:]
            for valueL > 0 && len(start) > 0 {
                inputSub, subSub := ParseNext(start)

                valueL -= len(start) - len(inputSub)

                start = inputSub
                subs = append(subs, subSub...)
            }

            pkg := Package{
                version: version,
                typeID: typeID,
                subs: subs,
            }

            result = append(result, pkg)
            input = start
        } else if length == "1" {
            valueL := helper.Binary2Int(input[7:18])

            subs := []Package{}
            start := input[18:]
            for i := 0; i < valueL; i++ {
                inputSub, subSub := ParseNext(start)
                start = inputSub
                subs = append(subs, subSub...)
            }

            pkg := Package{
                version: version,
                typeID: typeID,
                subs: subs,
            }

            result = append(result, pkg)
            input = start
        } else {
            fmt.Println("ERROR")
        }
    }

    return input, result
}

func PackageVersionCount(packages []Package) int {
    result := 0
    for _, pp := range packages {
        result += pp.version
        result += PackageVersionCount(pp.subs)
    }
    return result
}

func (pp *Package) calculate() *Package {
    newValue := 0

    for pi := range pp.subs {
        pp.subs[pi].calculate()
    }

    if pp.typeID == 0 {
        for _, sub := range pp.subs {
            newValue += sub.literal
        }
    } else if pp.typeID == 1 {
        newValue = 1
        for _, sub := range pp.subs {
            newValue *= sub.literal
        }
    } else if pp.typeID == 2 {
        newValue = pp.subs[0].literal
        for _, sub := range pp.subs {
            newValue = helper.IntMin(sub.literal, newValue)
        }
    } else if pp.typeID == 3 {
        newValue = pp.subs[0].literal
        for _, sub := range pp.subs {
            newValue = helper.IntMax(sub.literal, newValue)
        }
    } else if pp.typeID == 5 {
        if pp.subs[0].literal > pp.subs[1].literal {
            newValue = 1
        } else {
            newValue = 0
        }
    } else if pp.typeID == 6 {
        if pp.subs[0].literal < pp.subs[1].literal {
            newValue = 1
        } else {
            newValue = 0
        }
    } else if pp.typeID == 7 {
        if pp.subs[0].literal == pp.subs[1].literal {
            newValue = 1
        } else {
            newValue = 0
        }
    } else {
        return pp
    }

    pp.literal = newValue

    return pp
}

func (pp Package) print() {

    if pp.typeID != 4 {
        fmt.Print("(")
    }
    if pp.typeID == 0 {
        fmt.Print("+")
    } else if pp.typeID == 1 {
        fmt.Print("*")
    } else if pp.typeID == 2 {
        fmt.Print("min")
    } else if pp.typeID == 3 {
        fmt.Print("max")
    } else if pp.typeID == 4 {
        fmt.Print(pp.literal, " ")
    } else if pp.typeID == 5 {
        fmt.Print(">")
    } else if pp.typeID == 6 {
        fmt.Print("<")
    } else if pp.typeID == 7 {
        fmt.Print("=")
    }

    for pi := range pp.subs {
        pp.subs[pi].print()
    }

    if pp.typeID != 4 {
        fmt.Print(")")
     }
}

func String2Binary(input string) string {
    input_binary := ""
    for _, val := range input {
        for _, bin := range helper.Hex2Binary(string(val)) {
            input_binary += helper.Int2String(int(bin))
        }
    }
    return input_binary
}

func Run(Part2 bool) int {
    input := helper.ReadFileString("input.txt")
    input_binary := String2Binary(input)

    _, packages := ParseNext(input_binary)
    if Part2 {
        return packages[0].calculate().literal
    }

    return PackageVersionCount(packages)
}
