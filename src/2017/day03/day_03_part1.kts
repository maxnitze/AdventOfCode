import kotlin.math.absoluteValue
import kotlin.math.ceil
import kotlin.math.sqrt

fun manhattenDistanceInUlamSpiralForNumber(number: Int): Int {
    val matrixWidth = ceil(sqrt(number.toDouble())).toInt()
    return (matrixWidth/2).absoluteValue + ((matrixWidth/2)-((number-(matrixWidth-1)*(matrixWidth-1))%matrixWidth)).absoluteValue
}

val inputNumber = (if (!args.isEmpty()) args[0] else "325489").toInt()

val manhattenDistance = manhattenDistanceInUlamSpiralForNumber(inputNumber)
println("input number '$inputNumber' has a manhatten distance of '$manhattenDistance' to the center")
