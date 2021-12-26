package helper

import (
    "fmt"
    "os"
    "bufio"
    "sort"
    "strings"
    "strconv"
    "unicode"
)

func WriteFileString(path string, value string) {
    f, _ := os.Create(path)
    defer f.Close()

    f.WriteString(value)
}

func ReadFileStringPlain(path string) string {
    file, err := os.Open(path)
    if err != nil {
        panic(err.Error() + `: ` + path)
    }
    defer file.Close()

    var result string
    scanner := bufio.NewScanner(file)

    const maxCapacity = 512 * 1024 * 1024
    buf := make([]byte, maxCapacity)
    scanner.Buffer(buf, maxCapacity)

    for scanner.Scan() {
        result = result + string(scanner.Text()) + "\n"
    }

    return result
}

func ReadFile(path string) []string {
    result := Split(ReadFileString(path), "\n")
    for li := range result {
        result[li] = Trim(result[li])
    }

	return result
}

func ReadFileString(path string) string {
    return Trim(ReadFileStringPlain(path))
}

func IntArrayString(ints []int) []string {
    var result []string
    for _, value := range ints {
        result = append(result, Int2String(value))
    }
    return result
}

func IntArrayContains(list []int, v int) bool {
    for _, lv := range list {
        if lv == v {
            return true
        }
    }
    return false
}

func StringArrayInt(strings []string) []int {
    var result []int
    for _, value := range strings {
        result = append(result, String2Int(value))
    }
    return result
}

func Int2String(value int) string {
    return strconv.Itoa(value)
}

func String2Int(value string) int {
    result, _ := strconv.Atoi(value)
    return result
}

func String2Int64(value string) int64 {
	result, _ := strconv.ParseInt(value, 10, 64)
	return result
}

func StringArray2Int64Array(strings []string) []int64 {
	var result []int64
	for _, value := range strings {
		result = append(result, String2Int64(value))
	}
	return result
}

func Binary2Int(b string) int {
    v, err := strconv.ParseInt(b, 2, 64)
    if err != nil {
        panic(err)
    }
    n, err := strconv.Atoi(fmt.Sprintf("%d", v))
    if err != nil {
        panic(err)
    }

    return n
}

func Hex2Binary(input string) []uint64 {
    val, err := strconv.ParseUint(input, 16, 32)
    if err != nil {
        fmt.Printf("%s", err)
    }

    bits := []uint64{}
    for i := 20; i < 24; i++ {
        bits = append([]uint64{val & 0x1}, bits...)
        // or
        // bits = append(bits, val & 0x1)
        // depending on the order you want
        val = val >> 1
    }

    return bits
}

func IntMin(vars ...int) int {
    min := vars[0]

    for _, i := range vars {
        if min > i {
            min = i
        }
    }

    return min
}

func IntMax(vars ...int) int {
    min := vars[0]

    for _, i := range vars {
        if min < i {
            min = i
        }
    }

    return min
}

func StringArraySelect(arr []string, filter func(string) bool) string {
    for _, value := range arr {
        if filter(value) {
            return value
        }
    }
    return ""
}

func StringArrayPop(arr []string) (string, []string) {
    return arr[len(arr) - 1], arr[:len(arr) - 1]
}

func StringSort(word string) string {
    s := []rune(word)
    sort.Slice(s, func(i int, j int) bool { return s[i] < s[j] })
    return string(s)
}

func Split(value string, delimiter string) []string {
    return strings.Split(value, delimiter)
}

func Join(value []string, delimiter string) string {
    return strings.Join(value[:], delimiter)
}

func Trim(value string) string {
    return strings.TrimSpace(value)
}

func Replace(value string, from string, to string) string {
    return strings.ReplaceAll(value, from, to)
}

func IsUpper(s string) bool {
    for _, r := range s {
        if !unicode.IsUpper(r) && unicode.IsLetter(r) {
            return false
        }
    }
    return true
}

func IsLower(s string) bool {
    for _, r := range s {
        if !unicode.IsLower(r) && unicode.IsLetter(r) {
            return false
        }
    }
    return true
}