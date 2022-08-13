package main

import (
	"fmt"
)

// Some values
const Pi float64 = float64(3.14)
var chr byte = 'x'
var num float64 = 42
var nums []int = []int{1, 2, 3}
var flag bool = true
var dict map[int]string = nil

func init() {
	num := Pi
	iceCream := "vanilla"
	fmt.Println(num, nums, iceCream)
	// Code snippet
	if iceCream == "chocolate" {
		fmt.Printf(`Yay, I love %s ice cream!`, iceCream)
	} else {
		fmt.Printf("Awwww, but chocolate is my favorite...")
	}
}

// Function declaration
func Multiply(num1, num2 float64) float64 {
	result := num1 * num2 * 1.0
	return result
}

// Function evaluation
var product float64 = Multiply(float64(nums[0]), 10)

// Type definition
type Shape interface {
	Size() float64
	Fits(Shape) bool
}
type Thing struct{}
type Polygon struct {
	Thing
	name   string
	Height float64
	Width  float64
}

func (p Polygon) GetName() string {
	return p.name
}

func (p Polygon) Size() float64 {
	return Multiply(p.Height, p.Width)
}

func (p Polygon) Fits(in Shape) bool {
	return p.Size() < in.Size()
}

// Function using declared type
func MakePolygon(height float64) Polygon {
	return Polygon{name: "", Height: height, Width: product}
}
var s Shape = MakePolygon(1.4)
func PrintPolygon() {
	p := s.(Polygon)
	fmt.Println(p.GetName(), p.Height + p.Width)
}

// Enum declaration
type Direction byte
const (
	NORTH Direction = iota
	SOUTH
	EAST
	WEST
)
func ReadDirection() {
	println()
	fmt.Println(NORTH)
}
