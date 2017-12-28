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

val (resultHexagon, maxDistance) = inputFile
    .readText()
    .split(",")
    .fold(Pair(Hexagon(0,0,0), 0), { (hexagon, maxDistance), direction ->
        val resultHexagon = hexagon.move(direction)
        Pair(resultHexagon, listOf(maxDistance, resultHexagon.distanceTo(Hexagon(0,0,0))).max()!!)
    })

println("on the shortest path it takes '${resultHexagon.distanceTo(Hexagon(0,0,0))}' steps to reach the stuck process")
println("on the shortest path it takes '${maxDistance}' steps to reach the furthest the stuck process ever got")
