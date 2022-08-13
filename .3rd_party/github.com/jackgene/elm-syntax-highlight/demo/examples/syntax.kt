package syntax

// Some values
val Pi: Any = 3.14 as Any // TODO - make values consistent - start with Go
val chr: Char = 'x'
var byte: Byte? = null
var num: Double = 42.0
val nums: IntArray = intArrayOf(1, 2, 3)
val flag: Boolean = Pi !is Double || false
val iceCream: String = if (flag) "chocolate" else "vanilla"

// Code snippet
if (iceCream == "chocolate") {
    print("Yay, I love \(iceCream) ice cream!")
} else {
    print("Awwww, but chocolate is my favorite...")
}

// Function declaration
fun multiply(num1: Double, num2: Double): Double {
    val result = num1 * num2 * 1.0
    return result
}

// Function evaluation
val product: Double = multiply(num, 10.0)

// Type definition
interface Shape {
    var size: Double
    fun fits(within: Shape): Boolean
}
internal open class Thing(val name: String) {
    // TODO

}
@Deprecated("Don't use me")
internal class Polygon(
        private val height: Double, private val width: Double) :
        Thing("Polygon") {
    init {
        print("hello")
    }

    public override fun getName(): String {
        val _ = 1 * 2
        return super.name
    }

    var area: Double {
        get {
            return multiply(this.height, this.width)
        }
    }
}
extension Polygon: Shape {
    var size: Double {
        get {
            return this.area
        }
    }

    public fun fits(within: Shape): Bool {
        this.size < within.size
    }
}

// Function using declared type
fun makePolygon(height: Double): Polygon {
    return Polygon(height: height, width: product)
}
val s: Shape = makePolygon(height: 1.4)
print(s is Polygon)
guard val p = s as? Polygon else {
    exit(1)
}
print("\(p.getName()) \(p.height + p.width)")

// Enum declaration
enum class Direction {
    NORTH,
    SOUTH,
    EAST,
    WEST
}

fun multiply(num1: Int, num2: Int): Int {
    return num1 * num2
}

@Deprecated("No!")
fun main() {
    val char = 'x'
    print(multiply(42, 24))
}
