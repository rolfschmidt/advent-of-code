package main

import (
    // "os"
    // "runtime/pprof"
    // "net/http"
    // _ "net/http/pprof"
    "fmt"
    "time"
    "math"
    "sort"
    "strings"
    "github.com/rolfschmidt/advent-of-code-2021/helper"
)

var lowCount int = math.MaxInt
var rooms []Room = []Room{}
var roomEntranceList []int = []int{}
var roomsByName map[string][]Room = map[string][]Room{}
var cache map[string]int = map[string]int{}

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

func Distance(x1 int, y1 int, x2 int, y2 int) int {
    diffX := int(math.Abs(float64(helper.IntMax(x1, x2) - helper.IntMin(x1, x2))))
    diffY := int(math.Abs(float64(helper.IntMax(y1, y2) - helper.IntMin(y1, y2))))
    return diffX + diffY
}

func ContainsPos(list []Object, x int, y int) bool {
    for _, obj := range list {
        if obj.x == x && obj.y == y {
            return true
        }
    }

    return false
}

func CopyMatrix(list [][]Object) [][]Object {
    result := [][]Object{}
    for y := range list {
        row := []Object{}
        for x := range list[y] {
            row = append(row, list[y][x])
        }
        result = append(result, row)
    }
    return result
}

type Instance struct {
    matrix [][]Object
    count int
    objectCount int
}

func (ii Instance) Print() {
    for y := range ii.matrix {
        for x := range ii.matrix[y] {
            fmt.Print(ii.matrix[y][x].name)
        }
        fmt.Println()
    }
    fmt.Println()
}

func (ii Instance) RoomEntrances() []Object {
    result := []Object{}
    if len(roomEntranceList) < 1 {
        for _, room := range rooms {
            roomEntranceList = append(roomEntranceList, room.x)
        }
    }

    for _, x := range roomEntranceList {
        result = append(result, ii.matrix[1][x])
    }

    return result
}

func (ii Instance) PosFree(x int, y int) string {
    if ContainsPos(ii.RoomEntrances(), x, y) {
        return "entrance"
    }
    if ii.matrix[y][x].name == "." {
        return "free"
    }
    return "blocked"
}

func (ii Instance) Amphis() []Object {
    result := []Object{}
    for y := range ii.matrix {
        for x := range ii.matrix[y] {
            if ii.matrix[y][x].name == "A" || ii.matrix[y][x].name == "B" || ii.matrix[y][x].name == "C" || ii.matrix[y][x].name == "D" {
                result = append(result, ii.matrix[y][x])
            }
        }
    }
    return result
}

func (ii Instance) EntranceFree(x int, y int) bool {
    if ii.matrix[y][x].name == "." {
        return true
    }
    return false
}

// func (ii Instance) Step(x int, y int) bool {
//     oo := ii.matrix[y][x]
//     if oo.Done(ii) {
//         fmt.Println("done", oo)
//         return false
//     }

//     // fmt.Println("new step", oo.name, x, y)

//     ways := oo.Ways(ii)
//     if len(ways) < 1 {
//         return false
//     }

//     ii = oo.Move(ii, ways[0].x, ways[0].y)

//     return true
// }

func (ii Instance) IsCompleted() (bool, int) {
    count := 0
    done := true
    for _, room := range rooms {
        if ii.matrix[room.y][room.x].name == room.name {
            if ii.matrix[room.y][room.x].name == "A" {
                count += ii.matrix[room.y][room.x].moved * 1
            } else if ii.matrix[room.y][room.x].name == "B" {
                count += ii.matrix[room.y][room.x].moved * 10
            } else if ii.matrix[room.y][room.x].name == "C" {
                count += ii.matrix[room.y][room.x].moved * 100
            } else if ii.matrix[room.y][room.x].name == "D" {
                count += ii.matrix[room.y][room.x].moved * 1000
            } else {
                panic("wtf completed")
            }
        } else {
            done = false
        }
    }

    return done, count
}

func (ii Instance) String() string {
    result := helper.Int2String(ii.count) + ""
    for y := range ii.matrix {
        if y != 1 {
            continue
        }
        for _, xv := range ii.matrix[y] {
            if xv.name == "#" || xv.name == " " {
                continue
            }
            result += xv.name
        }
    }
    // fmt.Println(len(cache), result)
    return result
}

func (ii Instance) Run() int {
    // if ii.count > lowCount {
    //     // fmt.Println("abort by", ii.count, lowCount)
    //     return lowCount
    // }

    count := ii.count
    if count > lowCount {
        return lowCount
    }
    if len(rooms) == ii.objectCount {
        if count != lowCount {
            fmt.Println("done", count, len(rooms), ii.objectCount)
        }
        lowCount = helper.IntMin(count, lowCount)

        return count
    }

    count = math.MaxInt
    for _, oo := range ii.Amphis() {
        if oo.Done(&ii) {
            continue
        }

        for _, way := range oo.Ways(&ii) {
            newInstance := Instance{
                count: ii.count,
                objectCount: ii.objectCount,
                matrix: CopyMatrix(ii.matrix),
            }
            newInstance.matrix[oo.y][oo.x].Move(&newInstance, way.x, way.y)
            if 1 == 0 {
                newInstance.Print()
                time.Sleep(50000000)
            }
            // time.Sleep(100000000)

            if cv, ok := cache[newInstance.String()]; ok {
                count = helper.IntMin(count, cv)
            } else {
                count = helper.IntMin(count, newInstance.Run())
                cache[newInstance.String()] = count
            }
        }

    }

    return count
}

type Object struct {
    name string
    x int
    y int
    onTrack bool
    moved int
    done bool
}

type Room struct {
    name string
    x int
    y int
}


func (oo *Object) Rooms() []Room {
    if list, ok := roomsByName[oo.name]; ok {
        return list
    }

    result := []Room{}
    for _, room := range rooms {
        if room.name == oo.name {
            result = append(result, room)
        }
    }

    sort.Slice(result, func(i int, j int) bool { return result[i].y > result[j].y })
    roomsByName[oo.name] = result

    return result
}

func (oo *Object) Done(ii *Instance) bool {
    if oo.done {
        return true
    }

    oRooms := oo.Rooms()
    // sort.Slice(oRooms, func(i int, j int) bool { return oRooms[i].y > oRooms[j].y })

    for _, room := range oRooms {
        if oo.x == room.x && oo.y == room.y {
            oo.done = true
            return true
        }
        if ii.matrix[room.y][room.x].name != room.name {
            return false
        }
    }

    return false
}

func (oo *Object) Entrance(ii *Instance) Object {
    for _, room := range oo.Rooms() {
        return ii.matrix[1][room.x]
    }

    panic("no entrance")
    return Object{}
}

func (oo *Object) EntranceWays(ii *Instance) []Object {
    oRooms := []Object{}
    for _, room := range oo.Rooms() {
        if ii.matrix[room.y][room.x].name != "." && ii.matrix[room.y][room.x].name != room.name {
            return []Object{}
        }
        if ii.matrix[room.y][room.x].name == room.name {
            continue
        }

        oRooms = append(oRooms, ii.matrix[room.y][room.x])
    }

    // sort.Slice(oRooms, func(i int, j int) bool { return oRooms[i].y > oRooms[j].y })

    return oRooms
}

func (oo *Object) Ways(ii *Instance) []Object {
    if oo.y != 1 {
        free := true
        wy := -1
        for free {
            free = ii.EntranceFree(oo.x, oo.y + wy)
            // fmt.Println("loop 0 free ", free, oo.x, oo.y + wy)
            if !free {
                free = false
                break
            }
            if oo.y + wy == 1 {
                break
            }
            wy--
        }

        if !free {
            // fmt.Println("block way out", oo)
            return []Object{}
        }
    }

    if oo.onTrack {
        // fmt.Println("consider", oo.name, "to move in final entrance")
        entrance := oo.Entrance(ii)
        for sx := helper.IntMin(oo.x, entrance.x); sx <= helper.IntMax(oo.x, entrance.x); sx++ {
            if sx == oo.x {
                continue
            }
            if !ii.EntranceFree(sx, 1) {
                // fmt.Println("blocked", oo.name, sx, 1)
                return []Object{}
            }
        }

        // fmt.Println("entrance way free", oo.name, oo.EntranceWays(ii))
        return oo.EntranceWays(ii)
    }

    result := []Object{}
    for sx := oo.x; sx > 0; sx-- {
        posFree := ii.PosFree(sx, 1)
        if posFree == "entrance" {
            continue
        }
        if posFree == "blocked" {
            break
        }

        result = append(result, ii.matrix[1][sx])
    }
    for sx := oo.x; sx < 12; sx++ {
        posFree := ii.PosFree(sx, 1)
        if posFree == "entrance" {
            continue
        }
        if posFree == "blocked" {
            break
        }

        result = append(result, ii.matrix[1][sx])
    }

    // fmt.Println("consider move out of entrance", oo.name, oo.x, oo.y, result)

    return result
}

func (oo Object) Move(ii *Instance, x int, y int) {
    a := ii.matrix[y][x]
    a.x = ii.matrix[oo.y][oo.x].x
    a.y = ii.matrix[oo.y][oo.x].y

    b := ii.matrix[oo.y][oo.x]
    b.x = ii.matrix[y][x].x
    b.y = ii.matrix[y][x].y
    b.onTrack = true

    distance := Distance(x, y, oo.x, oo.y)
    b.moved += distance

    if b.name == "A" {
        ii.count += distance * 1
    } else if b.name == "B" {
        ii.count += distance * 10
    } else if b.name == "C" {
        ii.count += distance * 100
    } else if b.name == "D" {
        ii.count += distance * 1000
    } else {
        panic("wtf distance")
    }

    if b.Done(ii) {
        ii.objectCount += 1
    }

    ii.matrix[y][x] = b
    ii.matrix[oo.y][oo.x] = a
}

func Run(Part2 bool) int {
    // f, err := os.Create("profile.pprof")
    // if err != nil {
    //     fmt.Printf("Error: %s\n", err)
    //     return 0
    // }
    // defer f.Close()
    // pprof.StartCPUProfile(f)
    // defer pprof.StopCPUProfile()

    // go func() {
    //   fmt.Println(http.ListenAndServe("localhost:6060", nil))
    // }()

    rooms = append(rooms, Room{
        name: "A",
        x: 3,
        y: 2,
    })
    rooms = append(rooms, Room{
        name: "A",
        x: 3,
        y: 3,
    })
    rooms = append(rooms, Room{
        name: "B",
        x: 5,
        y: 2,
    })
    rooms = append(rooms, Room{
        name: "B",
        x: 5,
        y: 3,
    })
    rooms = append(rooms, Room{
        name: "C",
        x: 7,
        y: 2,
    })
    rooms = append(rooms, Room{
        name: "C",
        x: 7,
        y: 3,
    })
    rooms = append(rooms, Room{
        name: "D",
        x: 9,
        y: 2,
    })
    rooms = append(rooms, Room{
        name: "D",
        x: 9,
        y: 3,
    })

    fileString := helper.ReadFileStringPlain("input.txt")
    // if !Part2 {
    //     return 0
    // }

    if Part2 {
        return 0
        appendString := "\n  #D#C#B#A#\n  #D#B#A#C#"
        fileString = helper.Trim(fileString[0:41] + appendString + fileString[41:])

        rooms = append(rooms, Room{
            name: "A",
            x: 3,
            y: 4,
        })
        rooms = append(rooms, Room{
            name: "A",
            x: 3,
            y: 5,
        })
        rooms = append(rooms, Room{
            name: "B",
            x: 5,
            y: 4,
        })
        rooms = append(rooms, Room{
            name: "B",
            x: 5,
            y: 5,
        })
        rooms = append(rooms, Room{
            name: "C",
            x: 7,
            y: 4,
        })
        rooms = append(rooms, Room{
            name: "C",
            x: 7,
            y: 5,
        })
        rooms = append(rooms, Room{
            name: "D",
            x: 9,
            y: 4,
        })
        rooms = append(rooms, Room{
            name: "D",
            x: 9,
            y: 5,
        })
        fmt.Println(fileString)
    }

    matrix := [][]Object{}
    for y, line := range strings.Split(fileString, "\n") {
        row := []Object{}
        for x, char := range line {
            row = append(row, Object{ name: string(char), x: x, y: y })
        }

        matrix = append(matrix, row)
    }

    instance := Instance{
        matrix: matrix,
    }

    count := instance.Run()

    return count
}
