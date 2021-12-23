package main

import (
    "fmt"
    "strings"
    "github.com/rolfschmidt/advent-of-code-2021/helper"
)

var cubeRanges []CubeRange = []CubeRange{}

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

type CubeRange struct {
    turOn bool
    x1 int
    x2 int
    y1 int
    y2 int
    z1 int
    z2 int
}

func (cr CubeRange) MinX() int {
    return helper.IntMin(cr.x1, cr.x2)
}

func (cr CubeRange) MaxX() int {
    return helper.IntMax(cr.x1, cr.x2)
}

func (cr CubeRange) InX(value int, fallback int) int {
    if value >= cr.MinX() && value <= cr.MaxX() {
        return value
    }
    return fallback
}

func (cr CubeRange) DiffX() int {
    count := 0
    for i := cr.MinX(); i <= cr.MaxX(); i++ {
        count += 1
    }

    return count
}

func (cr CubeRange) MinY() int {
    return helper.IntMin(cr.y1, cr.y2)
}

func (cr CubeRange) MaxY() int {
    return helper.IntMax(cr.y1, cr.y2)
}

func (cr CubeRange) InY(value int, fallback int) int {
    if value >= cr.MinY() && value <= cr.MaxY() {
        return value
    }
    return fallback
}

func (cr CubeRange) DiffY() int {
    count := 0
    for i := cr.MinY(); i <= cr.MaxY(); i++ {
        count += 1
    }

    return count
}

func (cr CubeRange) MinZ() int {
    return helper.IntMin(cr.z1, cr.z2)
}

func (cr CubeRange) MaxZ() int {
    return helper.IntMax(cr.z1, cr.z2)
}

func (cr CubeRange) InZ(value int, fallback int) int {
    if value >= cr.MinZ() && value <= cr.MaxZ() {
        return value
    }
    return fallback
}

func (cr CubeRange) DiffZ() int {
    count := 0
    for i := cr.MinZ(); i <= cr.MaxZ(); i++ {
        count += 1
    }

    return count
}

func (cr CubeRange) Count() int {
    return cr.DiffX() * cr.DiffY() * cr.DiffZ()
}

func (cr CubeRange) Valid() bool {
    vx := cr.x2 - cr.x1 > -1
    vy := cr.y2 - cr.y1 > -1
    vz := cr.z2 - cr.z1 > -1

    return vx && vy && vz
}

func (cr CubeRange) ContainsPos(x int, y int, z int) bool {
    if x >= cr.MinX() && x <= cr.MaxX() && y >= cr.MinY() && y <= cr.MaxY() && z >= cr.MinZ() && z <= cr.MaxZ() {
        return true
    }
    return false
}

func (cr CubeRange) CollideX(value int) bool {
    if value >= cr.MinX() && value <= cr.MaxX() {
        return true
    }
    return false
}

func (cr CubeRange) CollideY(value int) bool {
    if value >= cr.MinY() && value <= cr.MaxY() {
        return true
    }
    return false
}

func (cr CubeRange) CollideZ(value int) bool {
    if value >= cr.MinZ() && value <= cr.MaxZ() {
        return true
    }
    return false
}

func (cr CubeRange) Collide(cr2 CubeRange) bool {
    colX := (cr2.MinX() >= cr.MinX() && cr2.MinX() <= cr.MaxX()) || (cr2.MaxX() >= cr.MinX() && cr2.MaxX() <= cr.MaxX())
    colY := (cr2.MinY() >= cr.MinY() && cr2.MinY() <= cr.MaxY()) || (cr2.MaxY() >= cr.MinY() && cr2.MaxY() <= cr.MaxY())
    colZ := (cr2.MinZ() >= cr.MinZ() && cr2.MinZ() <= cr.MaxZ()) || (cr2.MaxZ() >= cr.MinZ() && cr2.MaxZ() <= cr.MaxZ())
    if colX && colY && colZ {
        return true
    }
    return false
}

func (cr CubeRange) Include(cr2 CubeRange) bool {
    if cr.MinX() <= cr2.MinX() && cr.MaxX() >= cr2.MaxX() && cr.MinY() <= cr2.MinY() && cr.MaxY() >= cr2.MaxY() && cr.MinZ() <= cr2.MinZ() && cr.MaxZ() >= cr2.MaxZ() {
        return true
    }

    return false
}

func (cr CubeRange) Exclude(cr2 CubeRange) bool {
    cX := cr2.MaxX() < cr.MinX() || cr2.MinX() > cr.MaxX()
    cY := cr2.MaxY() < cr.MinY() || cr2.MinY() > cr.MaxY()
    cZ := cr2.MaxZ() < cr.MinZ() || cr2.MinZ() > cr.MaxZ()
    if cX && cY && cZ {
        return true
    }

    return false
}

func (cr CubeRange) Add(cr2 CubeRange) []CubeRange {
    result := []CubeRange{}
    if cr.Include(cr2) {
        fmt.Println("include", cr2)
        return append(result, cr)
    }
    if cr.Exclude(cr2) || !cr.Collide(cr2) {
        fmt.Println("exclude", cr, cr2)
        return append(append(result, cr), cr2)
    }

    // minX := cr.InX(cr2.MinX(), cr.MinX())
    // maxX := cr.InX(cr2.MaxX(), cr.MaxX())
    minY := cr.InY(cr2.MinY(), cr.MinY())
    maxY := cr.InY(cr2.MaxY(), cr.MaxY())
    minZ := cr.InZ(cr2.MinZ(), cr.MinZ())
    maxZ := cr.InZ(cr2.MaxZ(), cr.MaxZ())


    var cube CubeRange
    // var search bool

    // for vx := cr2.x1; vx <= cr2.x2; vx++ {
    //     for vy := cr2.y1; vy <= cr2.y2; vy++ {
    //         for vz := cr2.z1; vz <= cr2.z2; vz++ {
    //             colX := cr.CollideX(vx)
    //             colY := cr.CollideX(vy)
    //             colZ := cr.CollideX(vz)
    //             colAny := colX || colY || colZ
    //             colAll := colX && colY && colZ

    //             fmt.Println("check", vx, vy, vz)
    //             fmt.Println("col", colX, colY, colZ, colAny)

    //             if !search && !colAny {
    //                 cube = CubeRange{}
    //                 cube.x1 = vx
    //                 cube.y1 = vy
    //                 cube.z1 = vz
    //                 search = true
    //             }

    //             if colAny && search {
    //                 if colX {
    //                     cube.x2 = vx - 1
    //                 } else {
    //                     cube.x2 = vx
    //                 }
    //                 if colY {
    //                     cube.y2 = vy - 1
    //                 } else {
    //                     cube.y2 = vy
    //                 }
    //                 if colZ {
    //                     cube.z2 = vz - 1
    //                 } else {
    //                     cube.z2 = vz
    //                 }
    //                 result = append(result, cube)
    //                 search = false
    //             }
    //         }
    //     }
    // }


    // left
    cube = CubeRange{
        true,
        cr2.MinX(),
        cr.MinX() - 1,
        minY,
        maxY,
        minZ,
        maxZ,
    }
    if cube.Valid() {
        fmt.Println("left", cube)
        result = append(result, cube)
    }

    // right
    cube = CubeRange{
        true,
        cr.MaxX() + 1,
        cr2.MaxX(),
        minY,
        maxY,
        minZ,
        maxZ,
    }
    if cube.Valid() {
        fmt.Println("right", cube)
        result = append(result, cube)
    }

    // front
    cube = CubeRange{
        true,
        cr2.MinX(),
        cr2.MaxX(),
        minY,
        maxY,
        cr2.MinZ(),
        cr.MinZ() - 1,
    }
    if cube.Valid() {
        fmt.Println("front", cube)
        result = append(result, cube)
    }

    // back
    cube = CubeRange{
        true,
        cr2.MinX(),
        cr2.MaxX(),
        minY,
        maxY,
        cr.MaxZ() + 1,
        cr2.MaxZ(),
    }
    if cube.Valid() {
        fmt.Println("back", cube)
        result = append(result, cube)
    }

    // bottom
    cube = CubeRange{
        true,
        cr2.MinX(),
        cr2.MaxX(),
        cr2.MinY(),
        cr.MinY() - 1,
        cr2.MinZ(),
        cr2.MaxZ(),
    }
    if cube.Valid() {
        fmt.Println("bottom", cube)
        result = append(result, cube)
    }

    // top
    cube = CubeRange{
        true,
        cr2.MinX(),
        cr2.MaxX(),
        cr.MaxY() + 1,
        cr2.MaxY(),
        cr2.MinZ(),
        cr2.MaxZ(),
    }
    if cube.Valid() {
        fmt.Println("top", cube)
        result = append(result, cube)
    }

    fmt.Println("done")
    return result
}


func (cr CubeRange) Sub(cr2 CubeRange) []CubeRange {
    result := []CubeRange{}
    if cr.Exclude(cr2) || !cr.Collide(cr2) {
        fmt.Println("exclude", cr, cr2)
        return append(result, cr)
    }

    // minX := cr.InX(cr2.MinX(), cr.MinX())
    // maxX := cr.InX(cr2.MaxX(), cr.MaxX())
    minY := helper.IntMin(cr.MinY(), cr2.MinY())
    maxY := helper.IntMin(cr.MaxY(), cr2.MinY() - 1)
    minZ := cr2.InZ(cr.MinZ(), cr2.MinZ())
    maxZ := cr2.InZ(cr.MaxZ(), cr2.MaxZ())


    var cube CubeRange

    // left
    cube = CubeRange{
        true,
        cr.MinX(),
        cr2.MinX() - 1,
        cr.MinY(),
        cr2.MinY() - 1,
        cr.MinZ(),
        cr2.MinZ() - 1,
    }
    if cube.Valid() {
        fmt.Println("left", cube)
        result = append(result, cube)
    }

    // right
    cube = CubeRange{
        true,
        cr.MaxX() + 1,
        cr2.MaxX(),
        minY,
        maxY,
        minZ,
        maxZ,
    }
    if cube.Valid() {
        fmt.Println("right", cube)
        result = append(result, cube)
    }

    // front
    cube = CubeRange{
        true,
        cr2.MinX(),
        cr2.MaxX(),
        minY,
        maxY,
        cr2.MinZ(),
        cr.MinZ() - 1,
    }
    if cube.Valid() {
        fmt.Println("front", cube)
        result = append(result, cube)
    }

    // back
    cube = CubeRange{
        true,
        cr2.MinX(),
        cr2.MaxX(),
        minY,
        maxY,
        cr.MaxZ() + 1,
        cr2.MaxZ(),
    }
    if cube.Valid() {
        fmt.Println("back", cube)
        result = append(result, cube)
    }

    // bottom
    cube = CubeRange{
        true,
        cr2.MinX(),
        cr2.MaxX(),
        cr2.MinY(),
        cr.MinY() - 1,
        cr2.MinZ(),
        cr2.MaxZ(),
    }
    if cube.Valid() {
        fmt.Println("bottom", cube)
        result = append(result, cube)
    }

    // top
    cube = CubeRange{
        true,
        cr2.MinX(),
        cr2.MaxX(),
        cr.MaxY() + 1,
        cr2.MaxY(),
        cr2.MinZ(),
        cr2.MaxZ(),
    }
    if cube.Valid() {
        fmt.Println("top", cube)
        result = append(result, cube)
    }

    fmt.Println("done")
    return result
}

// func (cr CubeRange) OverlapCount(cr2 CubeRange) int {
//     count := 0
//     for x1 := cr.minX(); x1 <= cr.maxX(); x1++ {
//         if x1 < cr2.minX() || x1 > cr2.MaxX() {
//             continue
//         }

//         for y1 := cr.minY(); y1 <= cr.maxY(); y1++ {
//             if y1 < cr2.minY() || y1 > cr2.MaxY() {
//                 continue
//             }

//             for z1 := cr.minZ(); z1 <= cr.maxX(); z1++ {
//                 if z1 < cr2.minZ() || z1 > cr2.MaxZ() {
//                     continue
//                 }

//                 count += 1
//             }
//         }
//     }

//     return count
// }

func CountPos(idx int, x int, y int, z int) (bool, int) {
    if idx < 0 {
        return false, 0
    }
    if !cubeRanges[idx].ContainsPos(x, y, z) {
        // fmt.Println("does not contain", x, y, z)
        return CountPos(idx - 1, x, y, z)
    }

    doneBefore, countBefore := CountPos(idx - 1, x, y, z)
    if !cubeRanges[idx].turOn {
        if doneBefore {
            return true, -1
        } else {
            return true, 0
        }
    }
    if doneBefore && countBefore > 0 {
        return true, 0
    }
    // fmt.Println("does contain", x, y, z)

    return true, 1
}

func CountRange(idx int) int {
    result := 0
    cRange := cubeRanges[idx]
    for vx := cRange.x1; vx <= cRange.x2; vx++ {
        for vy := cRange.y1; vy <= cRange.y2; vy++ {
            for vz := cRange.z1; vz <= cRange.z2; vz++ {
                done, count := CountPos(idx, vx, vy, vz)
                if done {
                    result += count
                }
            }
        }
    }

    return result
}

func Run(Part2 bool) int {
    if len(cubeRanges) < 1 {
        for _, line := range helper.ReadFile("input_test2.txt") {
            cubeRange := CubeRange{}
            for _, part := range strings.Split(line, ",") {
                values := strings.Split(part, "=")
                varName := string(values[0][len(values[0]) - 1])
                rangeValue := helper.StringArrayInt(strings.Split(values[1], ".."))

                // fmt.Println(rangeValue,
                if varName == "x" {
                    cubeRange.x1 = helper.IntMin(rangeValue[0], rangeValue[1])
                    cubeRange.x2 = helper.IntMax(rangeValue[0], rangeValue[1])
                } else if varName == "y" {
                    cubeRange.y1 = helper.IntMin(rangeValue[0], rangeValue[1])
                    cubeRange.y2 = helper.IntMax(rangeValue[0], rangeValue[1])
                } else if varName == "z" {
                    cubeRange.z1 = helper.IntMin(rangeValue[0], rangeValue[1])
                    cubeRange.z2 = helper.IntMax(rangeValue[0], rangeValue[1])
                }

            }

            if strings.Count(line, "on") > 0 {
                cubeRange.turOn = true
            }
            cubeRanges = append(cubeRanges, cubeRange)
        }
    }

    if Part2 {


        fmt.Println("start", cubeRanges[0])
        fmt.Println("end", cubeRanges[1])
        fmt.Println(cubeRanges[0].Sub(cubeRanges[1]))


        // fmt.Println("first count", cubeRanges[0].Count())
        // count := cubeRanges[0].Count()
        // for _, cRange := range cubeRanges[0].Add(cubeRanges[1]) {
        //     count += cRange.Count()
        // }
        // fmt.Println("count", count)

        // count := 0
        // for idx := range cubeRanges {
        //     count += CountRange(idx)
        //     fmt.Println("count", idx, count)
        // }

        // fmt.Println("cubeRanges", len(cubeRanges))
        // fmt.Println("testxxxxx", cubeRanges[:0])
        // fmt.Println(cubeRanges, count)

        return 0
    }

    matrix := map[[3]int]bool{}
    max := -50
    min := 50

    count := 0
    for ci, cRange := range cubeRanges {
        for vx := helper.IntMax(max, cRange.x1); vx <= helper.IntMin(min, cRange.x2); vx++ {
            for vy := helper.IntMax(max, cRange.y1); vy <= helper.IntMin(min, cRange.y2); vy++ {
                for vz := helper.IntMax(max, cRange.z1); vz <= helper.IntMin(min, cRange.z2); vz++ {
                    key := [3]int{vx, vy, vz}
                    if matrix[key] {
                        if !cRange.turOn {
                            count -= 1
                        }
                    } else {
                        if cRange.turOn {
                            count += 1
                        }
                    }

                    matrix[key] = cRange.turOn
                }
            }
        }
        fmt.Println("count", ci, count)
    }

    // count := 0
    // for vx := range matrix {
    //     for vy := range matrix[vx] {
    //         for vz := range matrix[vx][vy] {
    //             if matrix[vx][vy][vz] {
    //                 count += 1
    //             }
    //         }
    //     }
    // }

    return count
}
