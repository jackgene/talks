module Examples exposing (..)


cssExample : String
cssExample = String.trimLeft
  """
stock::before {
  display: block;
  content: "To scale, the lengths of materials in stock are:";
}
stock > * {
  display: block;
  width: attr(length em); /* default 0 */
  height: 1em;
  border: solid thin;
  margin: 0.5em;
}
.wood {
  background: orange url(wood.png);
}
.metal {
  background: #c0c0c0 url(metal.png);
}
"""


elmExample : String
elmExample = String.trimLeft
  """
module Main exposing (..)

import Html exposing (Html, text)

type Msg
  = Increment
  | Decrement

type alias Model =
  { count : Int
  , name : String
  }

-- Main function

main : Html a
main =
  text "Hello, World!"
"""


goExample : String
goExample = String.trimLeft
  """
package main

import (
    "fmt"
)

// Some values
const Pi float64 = float64(3.14)
var chr byte = 'x'
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
func Multiply(num1 float64, num2 float64) float64 {
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

func (p Polygon) Fits(s Shape) bool {
    return p.Size() > s.Size()
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
    fmt.Println(NORTH)
}
"""


kotlinExample : String
kotlinExample = String.trimLeft
  """
package syntax

// Some values
val Pi: Any = 3.14 as Any
val chr: Char = 'x'
var byte: Byte? = null
var num: Double = 42.0
val nums: IntArray = intArrayOf(1, 2, 3)
val flag: Boolean = Pi !is Double || false
val iceCream: String = if (flag) "chocolate" else "vanilla"

// Code snippet
if (iceCream == "chocolate") {
    print("Yay, I love ${iceCream} ice cream!")
} else {
    print("Awwww, but chocolate is my favorite...")
}

// Function declaration
fun multiply(num1: Double, num2: Double): Array<Double> {
    val result = num1 * num2 * 1.0
    return result
}

// Function evaluation
val product: Double = multiply(num, 10.0)

// Type definition
@Deprecated
interface Shape {
    var size: Double
    fun fits(within: Shape): Boolean
}
"""


pythonExample : String
pythonExample = String.trimLeft
  """
from enum import Enum
from typing import *

# Comment
PI: float = 3.14
num: Optional[int] = None
nums: list[int] = [1, 2, 3]
flag: bool = True
iceCream: str = "chocolate" if flag else "vanilla"

if iceCream == 'chocolate':
    print(f'Yay, I love ${iceCream} ice cream!')
else:
    print('Awwww, but chocolate is my favorite...')


def multiply(num1: float, num2: float) -> float:
    result = num1 * num2 * 1.0
    return result


product: float = multiply(num, 10)


class Thing:
    pass


class Polygon(Thing):
    _name: str
    _height: float
    _width: float

    def __init__(self, height: float, width: float):
        super()
        self._name = 'Polygon'
        self._height = height
        self._width = width

    @staticmethod
    def get_name(self) -> str:
        print("hello")
        x = 1 * 2
        return self._name


def make_polygon(height: float) -> Polygon:
    return Polygon(height, product)


p: Polygon = make_polygon(1.4)
p.get_name()


class Direction(Enum):
    NORTH = "n"
    SOUTH = "s"
    EAST = "e"
    WEST = "w"


print(Direction.NORTH)
"""


swiftExample : String
swiftExample = String.trimLeft
  """
import Foundation

// Some values
let Pi: Float = 3.14 as Float
var byte: UInt8? = nil
var num: Double = 42
let nums: [UInt] = [1, 2, 3]
let flag: Bool = true
let iceCream: String = flag ? "chocolate" : "vanilla"

// Code snippet
if iceCream == "chocolate" {
    print("Yay, I love \\(iceCream) ice cream!")
} else {
    print("Awwww, but chocolate is my favorite...")
}

// Function declaration
fileprivate func multiply(_ num1: Double, _ num2: Double) -> Double {
    let result = num1 * num2 * 1.0
    return result
}

// Function evaluation
let product: Double = multiply(num, Double(10))

// Type definition
public protocol Shape {
    var size: Double { get }
    func fits(within: Shape) -> Bool
}
public class Thing {
    internal let name: String

    public init(name: String) {
        self.name = name
    }

    public func getName() -> String {
        name
    }
}
internal class Polygon: Thing {
    let height: Double
    let width: Double

    @objc
    public init(height: Double, width: Double) {
        self.height = height
        self.width = width
        super.init(name: "Polygon")
    }

    public override func getName() -> String {
        print("hello");
        let _ = 1 * 2
        return super.name
    }

    var area: Double {
        get {
            return multiply(self.height, self.width)
        }
    }
}
extension Polygon: Shape {
    var size: Double {
        get {
            return self.area
        }
    }

    public func fits(within: Shape) -> Bool {
        self.size < within.size
    }
}

// Function using declared type
func makePolygon(height: Double) -> Polygon {
    return Polygon(height: height, width: product)
}
let s: Shape = makePolygon(height: 1.4)
print(s is Polygon)
guard let p = s as? Polygon else {
    exit(1)
}
print("\\(p.getName()) \\(p.height + p.width)")

// Enum declaration
enum Direction {
    case north
    case south
    case east
    case west
}
print(Direction.north)
"""


typeScriptExample : String
typeScriptExample = String.trimLeft
  """
import { window } from "./exhaustive/exhaustive"

// Comment
const Pi: number = 3.14 as number
nan: number = NaN
var num: number = 42
let flag: boolean = true
let iceCream: string = flag ? "chocolate" : "vanilla";

if (iceCream === 'chocolate') {
  alert(`Yay, I love ${iceCream} ice cream!`);
} else {
  alert('Awwww, but chocolate is my favorite...');
}

function multiply(num1: number, num2: number): number {
  const result = num1 * num2 * 1.0;
  return result;
}

const product: number = multiply(num, 10 as number)

class Thing {}

export class Polygon extends Thing {
  private readonly name: string;
  private height: number;
  private width: number;

  constructor(height: number, width: number) {
    super();
    this.name = 'Polygon';
    this.height = height;
    this.width = width;
  }

  getName(): string {
    alert("hello");
    let x = 1 * 2
    return this.name;
  }
}
function rotatePolygon(input: Polygon): Polygon {
  return new Polygon(input.width, input.height) as Shape;
}
let p: Polygon = makePolygon(1.4)
p.getName()

enum Direction {
  NORTH = "n",
  SOUTH = "s",
  EAST = "e",
  WEST = "w"
}
alert(Direction.NORTH)
"""


xmlExample : String
xmlExample = String.trimLeft
  """
<!-- Comment -->
<html>
  <head>
    <title>Elm Syntax Highlight</title>
  </head>
  <body id="main" number=42>
    <p class="hero">Hello World</p>
  </body>
</html>
"""
