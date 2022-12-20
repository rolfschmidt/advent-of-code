package main

import (
    "fmt"
    "math"
    "sort"
    "github.com/rolfschmidt/advent-of-code-2021/helper"
)

var lowCount int
var rooms []Room
var roomEntranceList []int
var roomsByName map[string][]Room
var cache map[string]int
var cost map[string]int = map[string]int{
    "A": 1,
    "B": 10,
    "C": 100,
    "D": 1000,
}

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
    history []string
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

func (ii Instance) PrintString() string {
    result := ""
    for y := range ii.matrix {
        for x := range ii.matrix[y] {
            result += ii.matrix[y][x].name
        }
        result += "\n"
    }
    result += "\n"
    return result
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

func (ii Instance) String() string {
    result := helper.Int2String(ii.count) + ""
    for y := range ii.matrix {
        for _, xv := range ii.matrix[y] {
            if xv.name == "#" || xv.name == " " {
                continue
            }
            result += xv.name
        }
    }
    return result
}

func (ii Instance) Run() int {
    count := ii.count
    if count > lowCount {
        return lowCount
    }

    if len(rooms) == ii.objectCount {
        lowCount = helper.IntMin(count, lowCount)

        return count
    }

    if lowCount != math.MaxInt {
        potentialCost := ii.count
        for _, oo := range ii.Amphis() {
            if oo.Done(&ii) {
                continue
            }

            if oo.y == 1 {
                potentialCost += oo.Price(&ii, oo)
            } else {
                potentialCost += oo.Price(&ii, ii.matrix[1][oo.x])
            }
        }

        if potentialCost > lowCount {
            return lowCount
        }
    }

    count = math.MaxInt
    amphiWays := map[Object][]Object{}
    for _, oo := range ii.Amphis() {
        if oo.Done(&ii) {
            continue
        }

        for _, way := range oo.Ways(ii) {
            amphiWays[oo] = append(amphiWays[oo], way)
        }
    }

    for oo := range amphiWays {
        sort.Slice(amphiWays[oo], func(i int, j int) bool {
            return oo.Price(&ii, amphiWays[oo][i]) < oo.Price(&ii, amphiWays[oo][j])
        })
    }

    sortedAmphis := []Object{}
    for oo := range amphiWays {
        sortedAmphis = append(sortedAmphis, oo)
    }

    sort.Slice(sortedAmphis, func(i int, j int) bool {
        a := sortedAmphis[i]
        b := sortedAmphis[j]

        return a.Price(&ii, amphiWays[a][0]) < b.Price(&ii, amphiWays[b][0])
    })

    for oo, ways := range amphiWays {
        for _, way := range ways {
            amphiWays[oo] = append(amphiWays[oo], way)

            newInstance := Instance{
                count: ii.count,
                objectCount: ii.objectCount,
                matrix: CopyMatrix(ii.matrix),
                history: ii.history[0:],
            }
            newInstance.matrix[oo.y][oo.x].Move(&newInstance, way.x, way.y)

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
    for _, room := range oRooms {
        if oo.x == room.x && oo.y == room.y {
            oo.done = true
            ii.objectCount++
            return true
        }
        if ii.matrix[room.y][room.x].name != "." && ii.matrix[room.y][room.x].name != room.name {
            return false
        }
    }

    return false
}

func (oo *Object) Entrance(ii Instance) Object {
    for _, room := range oo.Rooms() {
        return ii.matrix[1][room.x]
    }

    panic("no entrance")
    return Object{}
}

func (oo *Object) EntranceWays(ii Instance) []Object {
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

    return oRooms
}

func (oo *Object) Ways(ii Instance) []Object {
    if oo.y != 1 {
        free := true
        wy := -1
        for free {
            free = ii.EntranceFree(oo.x, oo.y + wy)
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
            return []Object{}
        }
    }

    finalWay := true
    entrance := oo.Entrance(ii)
    for sx := helper.IntMin(oo.x, entrance.x); sx <= helper.IntMax(oo.x, entrance.x); sx++ {
        if sx == oo.x {
            continue
        }
        if !ii.EntranceFree(sx, 1) {
            finalWay = false
            break
        }
    }

    if finalWay {
        entranceWays := oo.EntranceWays(ii)
        if len(entranceWays) > 0 {
            return entranceWays
        }
    }

    if oo.y == 1 {
        return []Object{}
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
    if oo.x == x && oo.y > 1 && y > 1 {
        fmt.Println("weird", oo, x, y)
        ii.Print()
    }

    a := ii.matrix[y][x]
    a.x = ii.matrix[oo.y][oo.x].x
    a.y = ii.matrix[oo.y][oo.x].y

    b := ii.matrix[oo.y][oo.x]
    b.x = ii.matrix[y][x].x
    b.y = ii.matrix[y][x].y

    distance := Distance(x, y, oo.x, oo.y)
    if oo.y != 1 && y != 1 {
        distance = Distance(oo.x, oo.y, oo.x, 1) + Distance(oo.x, 1, x, y)
    }

    ii.count += distance * cost[b.name]

    b.Done(ii)

    ii.matrix[y][x] = b
    ii.matrix[oo.y][oo.x] = a

    ii.history = append(ii.history, ii.PrintString())
}

func (oo Object) Price(ii *Instance, target Object) int {
    if target.y > 1 {
        return 0
    }

    distance := Distance(oo.x, oo.y, target.x, target.y)

    eWays := oo.Rooms()
    eWay := eWays[len(eWays) - 1]
    distance += Distance(target.x, target.y, eWay.x, eWay.y)

    return distance * cost[oo.name]
}

func Run(Part2 bool) int {
    lowCount = math.MaxInt
    rooms = []Room{}
    roomEntranceList = []int{}
    roomsByName = map[string][]Room{}
    cache = map[string]int{}

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

    if Part2 {
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
    }

    matrix := [][]Object{}
    for y, line := range helper.Split(fileString, "\n") {
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
