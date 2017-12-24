import kotlin.math.absoluteValue

data class Coord(val x: Int, val y: Int) {

    fun getBaseCoordsInSpiral(): Set<Coord> {
        return if (x == 0 && y == 0) {
            throw RuntimeException("you should not call this on the center value")
        } else if (x == 1 && y == 0) {
            setOf(Coord(0, 0))
        } else if (x == 1 && y == 1) {
            setOf(Coord(0, 0), Coord(1,0))
        }
        // start value of a new "square"
        else if (x > 0 && y < 0 && x == y.absoluteValue+1) {
            setOf(
                Coord(x-1, y), Coord(x-1, y+1)
            )
        }
        // right side of matrix
        else if (x >= 0 && (x > y.absoluteValue || x == y)) {
            setOf(
                Coord(x, y-1), Coord(x-1, y-1)
            ) union (
                if (x != y) setOf(Coord(x-1, y)) else emptySet()
            ) union (
                if (x > y+1) setOf(Coord(x-1, y+1)) else emptySet()
            )
        }
        // top side of matrix
        else if (y >= 0 && (y > x.absoluteValue || y == -x)) {
            setOf(
                Coord(x+1, y), Coord(x+1, y-1)
            ) union (
                if (y != -x) setOf(Coord(x, y-1)) else emptySet()
            ) union (
                if (y > -(x-1)) setOf(Coord(x-1, y-1)) else emptySet()
            )
        }
        // left side of matrix
        else if (x <= 0 && (-x > y.absoluteValue || -x == y.absoluteValue)) {
            setOf(
                Coord(x, y+1), Coord(x+1, y+1)
            ) union (
                if (-x != y.absoluteValue) setOf(Coord(x+1, y)) else emptySet()
            ) union (
                if (-x > -(y-1)) setOf(Coord(x+1, y-1)) else emptySet()
            )
        }
        // bottom side of matrix
        else if (y <= 0 && -y >= x.absoluteValue) {
            setOf(
                Coord(x-1, y), Coord(x-1, y+1), Coord(x, y+1)
            ) union (
                if (-y >= x+1) setOf(Coord(x+1, y+1)) else emptySet()
            )
        } else {
            throw RuntimeException("something went very wrong!")
        }
    }

}

fun neighborSumForCoord(coord: Coord, cache: MutableMap<Coord, Int>): Int {
    return if (coord.x == 0 && coord.y == 0) {
        1
    } else {
        coord
            .getBaseCoordsInSpiral()
            .map { c -> cache.getOrPut(c) { neighborSumForCoord(c, cache) } }
            .fold(0, { sum, v -> sum + v })
    }
}

fun nextSpiralCoord(coord: Coord): Coord {
    return if (coord.x == 0 && coord.y == 0) {
        Coord(1, 0)
    } else if (coord.x >= 0 && coord.x > coord.y.absoluteValue) {
        Coord(coord.x, coord.y+1)
    } else if (coord.y >= 0 && (coord.y > coord.x.absoluteValue || coord.y == coord.x)) {
        Coord(coord.x-1, coord.y)
    } else if (coord.x <= 0 && (-coord.x > coord.y.absoluteValue || -coord.x == coord.y)) {
        Coord(coord.x, coord.y-1)
    } else if (coord.y <= 0 && -coord.y >= coord.x.absoluteValue) {
        Coord(coord.x+1, coord.y)
    } else {
        throw RuntimeException("something went very wrong!")
    }
}

fun firstValueLargerThenInput(coord: Coord, input: Int, cache: MutableMap<Coord, Int>): Int {
    val coordValue = cache.getOrPut(coord) { neighborSumForCoord(coord, cache) }
    return if (coordValue > input) {
        coordValue
    } else {
        firstValueLargerThenInput(nextSpiralCoord(coord), input, cache)
    }
}

val inputNumber = (if (!args.isEmpty()) args[0] else "325489").toInt()

val cache = mutableMapOf<Coord, Int>(Coord(0,0) to 1)
val firstLargerValue = firstValueLargerThenInput(Coord(0, 0), inputNumber, cache)
println("the first value larger then the input number '$inputNumber' is '$firstLargerValue'")
