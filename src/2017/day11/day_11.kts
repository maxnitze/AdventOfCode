import java.io.File

import kotlin.math.absoluteValue

val inputFile = File(if (!args.isEmpty()) args[0] else "input")
if (!inputFile.exists() || !inputFile.isFile()) {
    println("input file with name '${inputFile.getPath()}' does not exist or is not a file")
    System.exit(1)
}

data class Hexagon(val x: Int, val y: Int, val z: Int) {

    fun move(direction: String): Hexagon {
        return when (direction) {
            "n"  -> Hexagon(x, y+1, z-1)
            "ne" -> Hexagon(x+1, y, z-1)
            "se" -> Hexagon(x+1, y-1, z)
            "s"  -> Hexagon(x, y-1, z+1)
            "sw" -> Hexagon(x-1, y, z+1)
            "nw" -> Hexagon(x-1, y+1, z)
            else -> throw RuntimeException("something went very wrong here!")
        }
    }

    fun distanceTo(other: Hexagon): Int {
        return listOf(
            (x - other.x).absoluteValue,
            (y - other.y).absoluteValue,
            (z - other.z).absoluteValue
        ).max()!!
    }

}

val resultHexagon = inputFile
    .readText()
    .split(",")
    .fold(Hexagon(0,0,0), { hexagon, direction ->
        hexagon.move(direction)
    })

println("on the shortest path it takes '${resultHexagon.distanceTo(Hexagon(0,0,0))}' steps to reach the stuck process")
