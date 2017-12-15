import kotlin.math.absoluteValue
import kotlin.math.ceil
import kotlin.math.sqrt

class Coordinate(val x: Int, val y: Int) {
}

fun getCoordForNumber(number: Int): Coordinate {
    val matrixWidth = ceil(sqrt(number.toDouble())).toInt()

    val outerOffset = number - (matrixWidth-1)*(matrixWidth-1)
    val matrixSideOffset = (matrixWidth/2) - (outerOffset%matrixWidth)

    // unnecessary for the solution but otherwise coordinate would be wrong
    val coordFactor = if (matrixWidth%2 == 0) 1 else -1 

    return when (outerOffset / matrixWidth) {
        0 -> Coordinate(coordFactor*matrixWidth/2, coordFactor*(-matrixSideOffset))
        1 -> Coordinate(coordFactor*matrixSideOffset, coordFactor*matrixWidth/2)
        else -> throw RuntimeException("Something went very wrong here!")
    }
}

val inputNumber = (if (!args.isEmpty()) args[0] else "325489").toInt()

val coord = getCoordForNumber(inputNumber)
val manhattenDistance = coord.x.absoluteValue + coord.y.absoluteValue

println("the coordinate of input number '$inputNumber' is '(${coord.x}, ${coord.y})' with a manhatten distance of '$manhattenDistance' to the center")