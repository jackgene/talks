// import { window } from "./exhaustive/exhaustive"

// Some values
const Pi: number = 3.14 as number
var num: number = 42
let nums: number[] = [1, 2, 3]
let flag: boolean = true
let iceCream: string = flag ? "chocolate" : "vanilla";

// Code snippet
if (iceCream === 'chocolate') {
  alert(`Yay, I love ${iceCream} ice cream!`);
} else {
  alert('Awwww, but chocolate is my favorite...');
}

// Function declaration
function multiply(num1: number, num2: number): number {
  const result = num1 * num2 * 1.0;
  return result;
}

// Function evaluation
const product: number = multiply(num, 10 as number)

// Type definition
export interface Shape {
  getArea(): number;
}
class Thing {}
export class Polygon extends Thing implements Shape {
  private readonly name: string;
  readonly height: number;
  readonly width: number;

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

  getArea(): number {
    return multiply(this.height, this.width);
  }
}

// Function using declared type
function makePolygon(height: number): Polygon {
  return new Polygon(height, product);
}
let p: Polygon = makePolygon(1.4);
alert(p.getName() + p.height + p.width);

// Enum declaration
enum Direction {
  NORTH = "n",
  SOUTH = "s",
  EAST = "e",
  WEST = "w"
}
alert(Direction.NORTH);
