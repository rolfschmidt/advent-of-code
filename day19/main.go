package main

import (
    "fmt"
    "strings"
    "math"
    "github.com/rolfschmidt/advent-of-code-2021/helper"
)

func main() {
    fmt.Println()
    fmt.Println()
    fmt.Println()
    fmt.Println()
    fmt.Println()
    fmt.Println()
    fmt.Println()
    fmt.Println("Part 1", Part1())
    fmt.Println("Part 2", Part2())
}

func Part1() int {
    return Run(false)
}

func Part2() int {
    return Run(true)
}

type Coord struct {
    x int
    y int
    z int
}

func ContainsCoord(list []Coord, coord Coord) bool {
    for _, check := range list {
        if check.String() == coord.String() {
            return true
        }
    }

    return false
}

func AppendCoord(list []Coord, coord Coord) []Coord {
    if ContainsCoord(list, coord) {
        return list
    }

    list = append(list, coord)

    return list
}

func RotateList(list []Coord) [][]Coord {
    result := [][]Coord{}
    for ic, coord := range list {
        for ir, rotatedCoord := range coord.Rotations() {
            if ic == 0 {
                result = append(result, []Coord{})
            }
            result[ir] = append(result[ir], rotatedCoord)
        }
    }

    return result
}

func String2Coord(value string) Coord {
    parts := helper.StringArrayInt(helper.Split(value, ","))
    return Coord{
        x: parts[0],
        y: parts[1],
        z: parts[2],
    }
}

func (co *Coord) Add(co2 Coord) Coord {
    return Coord{
        x: co.x + co2.x,
        y: co.y + co2.y,
        z: co.z + co2.z,
    }
}

func (co *Coord) Sub(co2 Coord) Coord {
    return Coord{
        x: co.x - co2.x,
        y: co.y - co2.y,
        z: co.z - co2.z,
    }
}

func (co *Coord) Rotations() []Coord {
    result := []Coord{}

    cX := int(math.Abs(float64(co.x)))
    cY := int(math.Abs(float64(co.y)))
    cZ := int(math.Abs(float64(co.z)))

    // positive x
    result = append(result, Coord{ x: cX * 1, y: cY * 1, z: cZ * 1})
    result = append(result, Coord{ x: cX * 1, y: cZ * -1, z: cY * 1})
    result = append(result, Coord{ x: cX * 1, y: cY * -1, z: cZ * -1})
    result = append(result, Coord{ x: cX * 1, y: cZ * 1, z: cY * -1})
    // negative x
    result = append(result, Coord{ x: cX * -1, y: cY * -1, z: cZ * 1})
    result = append(result, Coord{ x: cX * -1, y: cZ * 1, z: cY * 1})
    result = append(result, Coord{ x: cX * -1, y: cY * 1, z: cZ * -1})
    result = append(result, Coord{ x: cX * -1, y: cZ * -1, z: cY * -1})
    // positive y
    result = append(result, Coord{ x: cY * 1, y: cZ * 1, z: cX * 1})
    result = append(result, Coord{ x: cY * 1, y: cX * -1, z: cZ * 1})
    result = append(result, Coord{ x: cY * 1, y: cZ * -1, z: cX * -1})
    result = append(result, Coord{ x: cY * 1, y: cX * 1, z: cZ * -1})
    // negative y
    result = append(result, Coord{ x: cY * -1, y: cZ * -1, z: cX * 1})
    result = append(result, Coord{ x: cY * -1, y: cX * 1, z: cZ * 1})
    result = append(result, Coord{ x: cY * -1, y: cZ * 1, z: cX * -1})
    result = append(result, Coord{ x: cY * -1, y: cX * -1, z: cZ * -1})
    // positive z
    result = append(result, Coord{ x: cZ * 1, y: cX * 1, z: cY * 1})
    result = append(result, Coord{ x: cZ * 1, y: cY * -1, z: cX * 1})
    result = append(result, Coord{ x: cZ * 1, y: cX * -1, z: cY * -1})
    result = append(result, Coord{ x: cZ * 1, y: cY * 1, z: cX * -1})
    // negative z
    result = append(result, Coord{ x: cZ * -1, y: cX * -1, z: cY * 1})
    result = append(result, Coord{ x: cZ * -1, y: cY * 1, z: cX * 1})
    result = append(result, Coord{ x: cZ * -1, y: cX * 1, z: cY * -1})
    result = append(result, Coord{ x: cZ * -1, y: cY * -1, z: cX * -1})

    return result
}

func (co *Coord) Directions() []Coord {
    result := []Coord{}
    for _, dX := range []int{1, -1} {
        for _, dY := range []int{1, -1} {
            for _, dZ := range []int{1, -1} {
                check := Coord{
                    x: co.x * dX,
                    y: co.y * dY,
                    z: co.z * dZ,
                }
                result = append(result, check)
            }
        }
    }
    return result
}

func (co *Coord) Variants(co2 Coord) []Coord {
    result := []Coord{}
    bAdd := co.Add(co2)
    bSub := co.Sub(co2)
    for _, wantFindX := range []int{ bAdd.x, bSub.x } {
        for _, wantFindY := range []int{ bAdd.y, bSub.y } {
            for _, wantFindZ := range []int{ bAdd.z, bSub.z } {
                for _, dX := range []int{1, -1} {
                    for _, dY := range []int{1, -1} {
                        for _, dZ := range []int{1, -1} {
                            check := Coord{
                                x: wantFindX * dX,
                                y: wantFindY * dY,
                                z: wantFindZ * dZ,
                            }
                            result = append(result, check)
                        }
                    }
                }
            }
        }
    }

    return result
}

func (co Coord) Distance(co2 Coord) Coord {
    return Coord{
        x: int(math.Abs(float64(helper.IntMax(co.x, co2.x) - helper.IntMin(co.x, co2.x)))),
        y: int(math.Abs(float64(helper.IntMax(co.y, co2.y) - helper.IntMin(co.y, co2.y)))),
        z: int(math.Abs(float64(helper.IntMax(co.z, co2.z) - helper.IntMin(co.z, co2.z)))),
    }
}

func (co Coord) String() string {
    return helper.Int2String(co.x) + "," + helper.Int2String(co.y) + "," + helper.Int2String(co.z)
}

type Scanner struct {
    name string
    pos Coord
    known bool
    beacons []Coord
    beaconsRelativeAbsCount map[string][]Coord
}

func (sc *Scanner) Init() *Scanner {
    sc.SetRelatives()
    if sc.name == "scanner 0" {
        // sc.known = true
    }

    return sc
}

func ListRelatives(list []Coord) map[string][]Coord {
    result := map[string][]Coord{}
    for _, cA := range list {
        for _, cB := range list {
            if cA.String() == cB.String() {
                continue
            }

            key := cA.Distance(cB).String()
            result[key] = append(result[key], cA)
        }
    }

    return result
}

func (sc *Scanner) SetRelatives() *Scanner {
    sc.beaconsRelativeAbsCount = map[string][]Coord{}
    for _, cA := range sc.beacons {
        for _, cB := range sc.beacons {
            if cA.String() == cB.String() {
                continue
            }

            key := cA.Distance(cB).String()
            sc.beaconsRelativeAbsCount[key] = append(sc.beaconsRelativeAbsCount[key], cA)
        }
    }

    return sc
}

func (sc *Scanner) OverlapCoordsMap(sc2 Scanner, work func(bA string, bACoords []Coord, bBCoords []Coord) bool ) {
    for bA, bACoords := range sc.beaconsRelativeAbsCount {
        bBCoords, ok := sc2.beaconsRelativeAbsCount[bA]
        if !ok {
            continue
        }

        if len(bACoords) != len(bBCoords) {
            continue
        }

        continueFunc := work(bA, bACoords, bBCoords)
        if !continueFunc {
            break
        }
    }
}

func (sc *Scanner) Overlap(sc2 Scanner) ([]Coord, []Coord, []Coord) {
    overlapCountRequired := 12
    overlapCountRequired = (overlapCountRequired - 1) * overlapCountRequired

    relativesListA := ListRelatives(sc.beacons)

    hotRelativesA := []Coord{}
    hotRelativesB := []Coord{}
    hotList := []Coord{}
    for _, list := range RotateList(sc2.beacons) {

        matchRelativesA := []Coord{}
        matchRelativesB := []Coord{}
        for relativesKey, relativesB := range ListRelatives(list) {
            relativesA, ok := relativesListA[relativesKey]
            if !ok {
                continue
            }

            if len(relativesA) != len(relativesB) {
                continue
            }

            for _, coord := range relativesA {
                matchRelativesA = AppendCoord(matchRelativesA, coord)
            }
            for _, coord := range relativesB {
                matchRelativesB = AppendCoord(matchRelativesB, coord)
            }
        }

        if len(matchRelativesB) > len(hotRelativesB) {
            hotRelativesA = matchRelativesA
            hotRelativesB = matchRelativesB
            hotList = list
        }
    }

    fmt.Println("hotRelativesB", len(hotRelativesB))
    if len(hotRelativesB) >= 12 {
        return hotRelativesA, hotRelativesB, hotList
    }

    return hotRelativesA, hotRelativesB, hotList
}

func (sc *Scanner) OverlapOld(sc2 Scanner) bool {
    overlapCountRequired := 12
    overlapCountRequired = (overlapCountRequired - 1) * overlapCountRequired

    bACoordsUnique := []Coord{}
    bBCoordsUnique := []Coord{}

    overlapCount := 0
    sc.OverlapCoordsMap(sc2, func(bA string, bACoords []Coord, bBCoords []Coord) bool {
        overlapCount += len(bBCoords)

        for _, coord := range bACoords {
            bACoordsUnique = AppendCoord(bACoordsUnique, coord)
        }
        for _, coord := range bBCoords {
            bBCoordsUnique = AppendCoord(bBCoordsUnique, coord)
        }


        // println("bBCoords", bBCoords[0].String(), bBCoords[1].String())

        // fmt.Println("bBCoords", bBCoords)

        return true
    })

    fmt.Println("overlapCount", overlapCount, overlapCountRequired, len(bACoordsUnique), len(bBCoordsUnique))
    if overlapCount >= overlapCountRequired {
        return true
    }

    return false
}

func (sc *Scanner) SetPos(sc2 *Scanner, hotRelativesA []Coord, hotRelativesB []Coord, hotList []Coord) {
    // sc2.beacons = hotList

    fmt.Println("hotRelativesA", len(hotRelativesA))
    fmt.Println("hotRelativesB", len(hotRelativesB))

    counts := map[string]int{}
    for _, coordA := range hotRelativesA {
        distance := sc.pos.Distance(coordA)

        for _, coordB := range hotRelativesB {
            for _, rotatedDistance := range distance.Rotations() {
                counts[coordB.Add(rotatedDistance).Distance(Coord{0,0,0}).String()] += 1
                // counts[coordB.Add(rotatedDistance).String()] += 1
            }
        }
    }

    highestPos := ""
    highestCount := 0
    for key, count := range counts {
        if count > highestCount {
            highestPos = key
            highestCount = count
            fmt.Println("new high", highestCount, highestPos)
        }
    }

    // 68,-1246,-43
    fmt.Println("highestCount", highestCount)
    fmt.Println("highestPos", highestPos)


    // X: (B - F) * -1
    // Y: (B - F)
    // Y: (B - F)

    highestCoord := String2Coord(highestPos)

    variantIndex := -1
    variantCoords := map[int][]Coord{}
    for ci, coord := range sc2.beacons {
        for vi, newCoord := range coord.Variants(highestCoord) {
            if ci == 0 {
                variantCoords[vi] = []Coord{}
            }

            variantCoords[vi] = append(variantCoords[vi], newCoord)

            if ContainsCoord(hotRelativesA, newCoord) {
                if variantIndex == -1 {
                    variantIndex = vi
                } else if variantIndex != vi {
                    panic("multiple variants")
                }
            }
        }
    }

    fmt.Println("set variant", variantIndex, len(variantCoords[variantIndex]))

    sc2.beacons = variantCoords[variantIndex]


    for _, coord := range sc.beacons {
        sc2.beacons = AppendCoord(sc2.beacons, coord)
    }
}

func (sc *Scanner) SetPosOld(sc2 *Scanner) {
    targetPosCount := map[string]int{}
    bACoordsUnique := []Coord{}
    bBCoordsUnique := []Coord{}
    sc.OverlapCoordsMap(*sc2, func(bA string, bACoords []Coord, bBCoords []Coord) bool {
        if (len(bACoords) != 2) {
            return true
        }

        for _, bACoord := range bACoords {
            if ContainsCoord(bACoordsUnique, bACoord) {
                continue
            }
            bACoordsUnique = append(bACoordsUnique, bACoord)

            distance := sc.pos.Distance(bACoord)
            if distance.String() == "618,824,621" {
                // fmt.Println(distance)
            }

            for _, bBCoord := range bBCoords {
                if ContainsCoord(bBCoordsUnique, bBCoord) {
                    continue
                }
                bBCoordsUnique = append(bBCoordsUnique, bBCoord)

                // 618,824,621
                // distance := String2Coord(bA)
                // fmt.Println(distance.String())

                // fmt.Println("bACoord", bACoord)
                // fmt.Println("bBCoord", bBCoord)

                for _, coordPosNew := range bBCoord.Variants(distance) {
                    match := false
                    for _, bBNew := range bBCoord.Directions() {
                        if bBNew.Add(coordPosNew).String() == bACoord.String() {
                            match = true
                            break
                        }
                    }

                    if !match {
                        continue
                    }

                    targetPosCount[coordPosNew.String()] += 1

                    // c := String2Coord("68,-1246,-43")
                    // if coordPosNew.String() == c.String() {
                    //     fmt.Println("foundx", coordPosNew.String())
                    // }
                }

                // bAdd := coord.Add(distance)
                // bSub := coord.Sub(distance)
                // for _, wantFindX := range []int{ bAdd.x, bSub.x } {
                //     for _, wantFindY := range []int{ bAdd.y, bSub.y } {
                //         for _, wantFindZ := range []int{ bAdd.z, bSub.z } {
                //             for _, dX := range []int{1, -1} {
                //                 for _, dY := range []int{1, -1} {
                //                     for _, dZ := range []int{1, -1} {
                //                         check := Coord{
                //                             x: wantFindX * dX,
                //                             y: wantFindY * dY,
                //                             z: wantFindZ * dZ,
                //                         }

                //                         targetPosCount[check.String()] += 1

                //                         c := String2Coord("68,-1246,-43")
                //                         if check.String() == c.String() {
                //                             fmt.Println("found", check.String())
                //                         }
                //                     }
                //                 }
                //             }
                //         }
                //     }
                // }
            }
        }

        return true
    })

    highestCount := -1
    highestPos := ""
    for key, value := range targetPosCount {
        // if strings.Count(key, "68,-1246,-43") > 0 { // key == "68,-1246,-43" {
            // fmt.Println("YES SIR", key)
        // }

        if value >= highestCount {
            highestCount = value
            highestPos = key
            // fmt.Println("highestPos", highestPos, highestCount)
        }
    }

    if highestPos == "" {
        return
    }
    fmt.Println("bACoordsUnique", bACoordsUnique)
    fmt.Println("bBCoordsUnique", bBCoordsUnique)

    sc2.pos = String2Coord(highestPos)
    sc2.known = true


    VARIANTS:
    for _, dX := range []int{1, -1} {
        for _, dY := range []int{1, -1} {
            for _, dZ := range []int{1, -1} {
                checkB := Coord{
                    x: bBCoordsUnique[0].x * dX,
                    y: bBCoordsUnique[0].y * dY,
                    z: bBCoordsUnique[0].z * dZ,
                }

                checkB = checkB.Add(sc2.pos)

                found := false
                for _, checkA := range bACoordsUnique {
                    if checkA.String() == checkB.String() {
                        found = true
                        break
                    }
                }

                if !found {
                    continue
                }

                fmt.Println("here we go")

                for bi := range sc2.beacons {
                    biNew := Coord{
                        x: sc2.beacons[bi].x * dX,
                        y: sc2.beacons[bi].y * dY,
                        z: sc2.beacons[bi].z * dZ,
                    }
                    biNew = biNew.Add(sc2.pos)

                    sc2.beacons[bi] = biNew
                }

                break VARIANTS
            }
        }
    }

    // fmt.Println("before ", sc2.beacons)
    // for bi := range sc2.beacons {
    //     sc2.beacons[bi] = sc2.beacons[bi].Add(sc2.pos)
    //     // fmt.Println("sc1", sc2.beacons[bi])
    // }

    // sc2.SetRelatives()

    fmt.Println("new pos", sc2.pos)
    fmt.Println("new beacons", sc2.beacons)
    // fmt.Println("bACoordsUnique", bACoordsUnique)

    // 423,-701,434

    bPrint := map[string]bool{}
    bPrint["-618,-824,-621"] = true
    bPrint["-537,-823,-458"] = true
    bPrint["-447,-329,318"] = true
    bPrint["404,-588,-901"] = true
    bPrint["544,-627,-890"] = true
    bPrint["528,-643,409"] = true
    bPrint["-661,-816,-575"] = true
    bPrint["390,-675,-793"] = true
    bPrint["423,-701,434"] = true
    bPrint["-345,-311,381"] = true
    bPrint["459,-707,401"] = true
    bPrint["-485,-357,347"] = true
    for print := range bPrint {
        found := false
        for _, coord := range sc2.beacons {
                // fmt.Println("compare", print, coord.String())
            if coord.String() == "404,-588,-901" {
                fmt.Println("wofofof")
            }

            if print == coord.String() {
                found = true
                break
            }
        }

        if found {
            continue
        }

        fmt.Println(print, "not found")
    }

    // bPrint["459,-707,401"] = true
    // bPrint["-739,-1745,668"] = true
    // bPrint["-485,-357,347"] = true
    // bPrint["432,-2009,850"] = true
    // bPrint["528,-643,409"] = true
    // bPrint["423,-701,434"] = true
    // bPrint["-345,-311,381"] = true
    // bPrint["408,-1815,803"] = true
    // bPrint["534,-1912,768"] = true
    // bPrint["-687,-1600,576"] = true
    // bPrint["-447,-329,318"] = true
    // bPrint["-635,-1737,486"] = true

    // bPrint["459,-707,401"] = true
    // bPrint["-739,-1745,668"] = true
    // bPrint["-485,-357,347"] = true
    // bPrint["432,-2009,850"] = true
    // bPrint["528,-643,409"] = true
    // bPrint["423,-701,434"] = true
    // bPrint["-345,-311,381"] = true
    // bPrint["408,-1815,803"] = true
    // bPrint["534,-1912,768"] = true
    // bPrint["-687,-1600,576"] = true
    // bPrint["-447,-329,318"] = true
    // bPrint["-635,-1737,486"] = true
    // for _, coord := range sc2.beacons {
    //     // fmt.Println("check", coord.String())
    //     if !bPrint[coord.String()] {
    //         continue
    //     }

    //     fmt.Println("found", coord.String())
    // }

    sc2.SetRelatives()
}

func Run(Part2 bool) int {
    if Part2 {
        return 0
    }

    // test := []Coord{
    //     Coord{ 4, 5, 6 },
    //     Coord{ 1, 2, 3 },
    //     Coord{ 7, 8, 9 },
    // }

    // fmt.Println(len(RotateList(test)))

    // return 0
    // a := String2Coord("-618,-824,-621")
    // b := String2Coord("686,422,578")
    // c := String2Coord("68,-1246,-43")

    // s := Coord{}
    // distance := s.Distance(a)

    // bAdd := b.Add(distance)
    // bSub := b.Sub(distance)
    // for _, wantFindX := range []int{ bAdd.x, bSub.x } {
    //     for _, wantFindY := range []int{ bAdd.y, bSub.y } {
    //         for _, wantFindZ := range []int{ bAdd.z, bSub.z } {
    //             for _, dX := range []int{1, -1} {
    //                 for _, dY := range []int{1, -1} {
    //                     for _, dZ := range []int{1, -1} {
    //                         check := Coord{
    //                             x: wantFindX * dX,
    //                             y: wantFindY * dY,
    //                             z: wantFindZ * dZ,
    //                         }

    //                         fmt.Println("check", wantFindX, check.String())

    //                         if check.String() == c.String() {
    //                             fmt.Println("found", check.String())
    //                         }
    //                     }
    //                 }
    //             }
    //         }
    //     }
    // }


    // fmt.Println(a,b,c)
    // fmt.Println("d => ", distance)

    // return 0

    content := helper.ReadFileString("input_test2.txt")
    contentScanners := strings.Split(content, "\n\n")

    scanners := []Scanner{}
    for _, scanner := range contentScanners {
        beacons := strings.Split(scanner, "\n")
        name := helper.Trim(strings.Replace(beacons[0], "---", "", -1))
        beacons = beacons[1:]

        scanner := Scanner{ name: name }
        for _, beaconstr := range beacons {
            beacons := helper.StringArrayInt(strings.Split(beaconstr, ","))
            scanner.beacons = append(scanner.beacons, Coord{ x: beacons[0], y: beacons[1], z: beacons[2], })
        }

        scanner.Init()
        scanners = append(scanners, scanner)
    }


    hotRelativesA, hotRelativesB, hotList := scanners[0].Overlap(scanners[1])
    scanners[0].SetPos(&scanners[1], hotRelativesA, hotRelativesB, hotList)

    hotRelativesA, hotRelativesB, hotList = scanners[1].Overlap(scanners[4])
    scanners[1].SetPos(&scanners[4], hotRelativesA, hotRelativesB, hotList)

    hotRelativesA, hotRelativesB, hotList = scanners[4].Overlap(scanners[3])
    scanners[4].SetPos(&scanners[3], hotRelativesA, hotRelativesB, hotList)

    hotRelativesA, hotRelativesB, hotList = scanners[3].Overlap(scanners[2])
    scanners[3].SetPos(&scanners[2], hotRelativesA, hotRelativesB, hotList)


    return len(scanners[2].beacons)

    // fmt.Println("overlapcheck", scanners[0].Overlap(scanners[1]))
    allBeacons := []Coord{}
    for s1 := range scanners {
        for _, coord := range scanners[s1].beacons {
            allBeacons = AppendCoord(allBeacons, coord)
        }
    }



    owner := 0
    done := map[int]bool{}
    force := false

    fmt.Println("scanner count", len(scanners))
    LOOP:
    for len(done) < len(scanners) {

        SCANNER:
        for s1 := range scanners {
            sc1 := &scanners[s1]
            if s1 != owner {
                continue
            }

            fmt.Println("run", sc1.name)

            for s2 := range scanners {
                sc2 := &scanners[s2]
                if sc1.name == sc2.name || done[s2] {
                    continue
                }

                fmt.Println("run", sc2.name)

                // fmt.Println(sc1.name, "check overlaps with", sc2.name)
                hotRelativesA, hotRelativesB, hotList := sc1.Overlap(*sc2)
                if len(hotRelativesB) >= 12 || force {
                    // sc2.beacons = hotList

                    fmt.Println(sc1.name, "overlaps with", sc2.name)
                    sc1.SetPos(sc2, hotRelativesA, hotRelativesB, hotList)
                    owner = s2
                    done[s1] = true
                    done[s2] = true

                    // break SCANNER
                    continue SCANNER
                }
            }

            if !force {
                force = true
                continue LOOP
            }

            panic("no matches for scanner" + sc1.name)
        }
    }

    fmt.Println("beacon count before", len(allBeacons))
    return len(scanners[owner].beacons)
}
