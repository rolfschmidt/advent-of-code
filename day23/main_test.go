package main

import (
    "testing"
    "github.com/stretchr/testify/assert"
)

var c1 CubeRange
var c2 CubeRange

func TestInclude(t *testing.T) {
    c1 = CubeRange{true, 10, 12, 10, 12, 10, 12}
    c2 = CubeRange{true, 10, 12, 10, 12, 10, 12}
    assert.Equal(t, true, c1.Include(c2))

    c1 = CubeRange{true, 10, 12, 10, 12, 10, 12}
    c2 = CubeRange{true, 10, 12, 10, 12, 10, 13}
    assert.Equal(t, false, c1.Include(c2))

    c1 = CubeRange{true, 10, 12, 10, 12, 10, 12}
    c2 = CubeRange{true, 7, 9, 7, 9, 7, 9}
    assert.Equal(t, false, c1.Include(c2))
}

func TestExclude(t *testing.T) {
    c1 = CubeRange{true, 10, 12, 10, 12, 10, 12}
    c2 = CubeRange{true, 10, 12, 10, 12, 10, 12}
    assert.Equal(t, false, c1.Exclude(c2))

    c1 = CubeRange{true, 10, 12, 10, 12, 10, 12}
    c2 = CubeRange{true, 10, 12, 10, 12, 10, 13}
    assert.Equal(t, false, c1.Exclude(c2))

    c1 = CubeRange{true, 10, 12, 10, 12, 10, 12}
    c2 = CubeRange{true, 7, 9, 7, 9, 7, 9}
    assert.Equal(t, true, c1.Exclude(c2))

    c1 = CubeRange{true, 10, 12, 10, 12, 10, 12}
    c2 = CubeRange{true, 7, 10, 7, 9, 7, 9}
    assert.Equal(t, true, c1.Exclude(c2))
}

func TestValid(t *testing.T) {
    c1 = CubeRange{true, 1, 1, 1, 1, 1, 1}
    assert.Equal(t, false, c1.Valid())

    c1 = CubeRange{true, 1, 2, 1, 2, 1, 2}
    assert.Equal(t, true, c1.Valid())
}

func TestAdd(t *testing.T) {
    var add []CubeRange

    c1 = CubeRange{true, 10, 12, 10, 12, 10, 12}
    c2 = CubeRange{true, 10, 12, 10, 12, 10, 12}
    assert.Equal(t, c1.Add(c2), []CubeRange{c1})

    c1 = CubeRange{true, 10, 12, 10, 12, 10, 12}
    c2 = CubeRange{true, 7, 9, 7, 9, 7, 9}
    assert.Equal(t, c1.Add(c2), []CubeRange{c1, c2})

    c1 = CubeRange{true, 10, 12, 10, 12, 10, 12}
    c2 = CubeRange{true, 7, 10, 7, 10, 7, 10}
    add = c1.Add(c2)
    assert.Equal(t, 2, len(add))
    assert.Equal(t, 7, add[1].x1)
    assert.Equal(t, 9, add[1].x2)
}