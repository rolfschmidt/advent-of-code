package main

import (
    "testing"
    "github.com/stretchr/testify/assert"
)

func TestParseNestedInt(t *testing.T) {
    assert := assert.New(t)
    check := "[[[[[9,8],1],2],3],4]"
    assert.Equal(check, ParseNestedInt(check).String(), "Fail " + check)
}

func TestAdd(t *testing.T) {
    assert := assert.New(t)
    checkA := "[1,2]"
    checkB := "[[1,2],3]"
    assert.Equal("[[1,2],[[1,2],3]]", ParseNestedInt(checkA).Add(ParseNestedInt(checkB)).String(), "Fail " + checkA + " and " + checkB)
}

func TestDepthCount(t *testing.T) {
    assert := assert.New(t)
    check := "[[[[[9,8],1],2],3],4]"
    assert.Equal(5, ParseNestedInt(check).DepthCount(), "Fail " + check)
}

func TestExplode(t *testing.T) {
    assert := assert.New(t)
    check := "[[[[[9,8],1],2],3],4]"
    node := ParseNestedInt(check)
    node.Explode()
    assert.Equal("[[[[0,9],2],3],4]", node.String(), "Fail " + check)
}

func TestExplode2(t *testing.T) {
    assert := assert.New(t)
    check := "[7,[6,[5,[4,[3,2]]]]]"
    node := ParseNestedInt(check)
    node.Explode()
    assert.Equal("[7,[6,[5,[7,0]]]]", node.String(), "Fail " + check)
}

func TestExplode3(t *testing.T) {
    assert := assert.New(t)
    check := "[[6,[5,[4,[3,2]]]],1]"
    node := ParseNestedInt(check)
    node.Explode()
    assert.Equal("[[6,[5,[7,0]]],3]", node.String(), "Fail " + check)
}

func TestExplode4(t *testing.T) {
    assert := assert.New(t)
    check := "[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]"
    node := ParseNestedInt(check)
    node.Explode()
    assert.Equal("[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]", node.String(), "Fail " + check)
}

func TestExplode5(t *testing.T) {
    assert := assert.New(t)
    check := "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]"
    node := ParseNestedInt(check)
    node.Explode()
    assert.Equal("[[3,[2,[8,0]]],[9,[5,[7,0]]]]", node.String(), "Fail " + check)
}

func TestSplit(t *testing.T) {
    assert := assert.New(t)
    check := "[[[[0,7],4],[15,[0,13]]],[1,1]]"
    node := ParseNestedInt(check)
    node.Split()
    assert.Equal("[[[[0,7],4],[[7,8],[0,13]]],[1,1]]", node.String(), "Fail " + check)
    node.Split()
    assert.Equal("[[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]", node.String(), "Fail " + check)
}

func TestReduce(t *testing.T) {
    assert := assert.New(t)

    a := ParseNestedInt("[[[[4,3],4],4],[7,[[8,4],9]]]")
    b := ParseNestedInt("[1,1]")

    check := "[[[[4,3],4],4],[7,[[8,4],9]]] + [1,1]"
    node := a.Add(b)
    assert.Equal("[[[[0,7],4],[[7,8],[6,0]]],[8,1]]", node.Reduce().String(), "Fail " + check)
}

func TestReduce2(t *testing.T) {
    assert := assert.New(t)

    a := ParseNestedInt("[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]")
    b := ParseNestedInt("[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]")

    check := "[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]] + [7,[[[3,7],[4,3]],[[6,3],[8,8]]]]"
    node := a.Add(b)
    assert.Equal("[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]", node.Reduce().String(), "Fail " + check)
}

func TestMagnitude(t *testing.T) {
    assert := assert.New(t)

    tests := map[string]int{}
    tests["[[1,2],[[3,4],5]]"] = 143
    tests["[[[[0,7],4],[[7,8],[6,0]]],[8,1]]"] = 1384
    tests["[[[[1,1],[2,2]],[3,3]],[4,4]]"] = 445
    tests["[[[[3,0],[5,3]],[4,4]],[5,5]]"] = 791
    tests["[[[[5,0],[7,4]],[5,5]],[6,6]]"] = 1137
    tests["[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]"] = 3488
    tests["[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]"] = 4140

    for test, result := range tests {
    	t.Log("TestMagnitude", test,result)
	    check := test
	    node := ParseNestedInt(test)
	    assert.Equal(result, node.Magnitude(), "Fail " + check)
    }
}


// func TestPart1(t *testing.T) {
// 	result := Part1()
// 	t.Log(" Part 1:", result)
//     if result != 14535 {
//         t.Errorf("part 1 failing")
//     }
// }

// func TestPart2(t *testing.T) {
// 	result := Part2()
// 	t.Log(" Part 2:", result)
//     if result != 2270 {
//         t.Errorf("part 2 failing")
//     }
// }
