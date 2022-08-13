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
    print("Yay, I love \(iceCream) ice cream!")
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
print(s is [String:Polygon])
guard let p = s as? Polygon else {
    exit(1)
}
print("\(p.getName()) \(p.height + p.width)")

// Enum declaration
enum Direction {
    case north
    case south
    case east
    case west
}
print(Direction.north)
