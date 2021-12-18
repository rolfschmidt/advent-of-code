package main

import (
    "fmt"
    "encoding/json"
    "math"
    "bytes"
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

type NestedInt struct {
    value    int
    children []NestedInt
}

func (n *NestedInt) UnmarshalJSON(b []byte) error {
    if bytes.HasPrefix(b, []byte("[")) {
        return json.Unmarshal(b, &n.children)
    }
    return json.Unmarshal(b, &n.value)
}

func (ni NestedInt) Add(v2 NestedInt) NestedInt {
    childs := []NestedInt{}
    childs = append(childs, ni)
    childs = append(childs, v2)

    return NestedInt{
        children: childs,
    }
}

func (ni NestedInt) IsValue() bool {
    return len(ni.children) < 1
}

func (ni NestedInt) DepthCount() int {
    result := 0
    if !ni.IsValue() {
        childMax := 0
        for _, child := range ni.children {
            childMax = helper.IntMax(childMax, child.DepthCount())
        }

        result = 1 + childMax
    }

    return result
}

func (ni *NestedInt) Split() bool {
    splitted := false
    if !ni.IsValue() {
        for ci := range ni.children {
            splitted = ni.children[ci].Split()
            if splitted {
                return true
            }
        }
    } else if ni.value > 9 {
        ni.children = []NestedInt{
            NestedInt{ value: int(math.Floor(float64(ni.value) / 2)) },
            NestedInt{ value: int(math.Ceil(float64(ni.value) / 2)) },
        }
        ni.value = 0
        splitted = true
    }

    return splitted
}

func (ni *NestedInt) Explode() bool {

    popValues := []int{}
    exploded := false
    var lastLiteral *NestedInt

    // 1
    for ci1 := range ni.children {
        child1 := &ni.children[ci1]
        if child1.IsValue() {
            lastLiteral = child1
            if len(popValues) > 0 {
                lastLiteral.value += popValues[1]
                popValues = []int{}
            }
            continue
        }

        // 2
        for ci2 := range child1.children {
            child2 := &child1.children[ci2]
            if child2.IsValue() {
                lastLiteral = child2
                if len(popValues) > 0 {
                    lastLiteral.value += popValues[1]
                    popValues = []int{}
                }
                continue
            }

            // 3
            for ci3 := range child2.children {
                child3 := &child2.children[ci3]
                if child3.IsValue() {
                    lastLiteral = child3
                    if len(popValues) > 0 {
                        lastLiteral.value += popValues[1]
                        popValues = []int{}
                    }
                    continue
                }

                // 4
                for ci4 := range child3.children {
                    child4 := &child3.children[ci4]
                    if child4.IsValue() {
                        lastLiteral = child4
                        if len(popValues) > 0 {
                            lastLiteral.value += popValues[1]
                            popValues = []int{}
                        }
                        continue
                    }

                    // 5
                    for ci5 := range child4.children {
                        child5 := &child4.children[ci5]
                        if !child5.IsValue() {
                            panic("Level 5 children has children for some reason")
                        }


                        if !exploded {
                            popValues = append(popValues, child5.value)
                        } else {
                            lastLiteral = child5
                            if len(popValues) > 0 {
                                lastLiteral.value += popValues[1]
                                popValues = []int{}
                            }
                        }
                    }

                    if !exploded {
                        exploded = true

                        child4.children = []NestedInt{}

                        if len(popValues) != 2 {
                            panic("popValues do not contain 2 values")
                        }

                        if lastLiteral != nil {
                            lastLiteral.value += popValues[0]
                        }

                        lastLiteral = nil
                    }
                }
            }
        }
    }

    return exploded
}

func (ni *NestedInt) Reduce() *NestedInt {
    if ni.DepthCount() > 5 {
        panic("DepthCount the card house is burning down")
    }

    for true {
        exploded := ni.Explode()
        if exploded {
            continue
        }

        splited := ni.Split()
        if !splited {
            break
        }
    }

    return ni
}

func (ni *NestedInt) Magnitude() int {
    if ni.IsValue() {
        return ni.value
    } else if len(ni.children) == 2 && ni.children[0].IsValue() && ni.children[1].IsValue() {
        return (ni.children[0].value * 3) + (ni.children[1].value * 2)
    }

    return (ni.children[0].Magnitude() * 3) + (ni.children[1].Magnitude() * 2)
}

func (ni NestedInt) String() string {
    result := ""
    if !ni.IsValue() {
        result += "["
        for ci := range ni.children {
            result += ni.children[ci].String()
            if ci < len(ni.children) - 1 {
                result += ","
            }
        }
        result += "]"
    } else {
        result += helper.Int2String(ni.value)
    }

    return result
}

func (ni NestedInt) Print() {
    fmt.Println(ni.String())
}

func ParseNestedInt(line string) NestedInt {
    var nested NestedInt
    if err := json.Unmarshal([]byte(line), &nested); err != nil {
        panic(err)
    }
    return nested
}

func Run(Part2 bool) int {
    lines := []string{}
    for _, line := range helper.ReadFile("input.txt") {
        lines = append(lines, line)
    }

    if Part2 {
        hotMagnitude := 0
        for i := 0; i < len(lines); i++ {
            for j := 0; j < len(lines); j++ {
                if i == j {
                    continue
                }

                a := ParseNestedInt(lines[i])
                b := ParseNestedInt(lines[j])
                c := a.Add(b)
                c.Reduce()
                hotMagnitude = helper.IntMax(hotMagnitude, c.Magnitude())
            }
        }

        return hotMagnitude
    }

    var final NestedInt
    for _, line := range lines {
        node := ParseNestedInt(line)
        if len(final.children) < 1 {
            final = node
        } else {
            final = final.Add(node)
            final.Reduce()
        }
    }

    return final.Magnitude()
}
