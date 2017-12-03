import java.io.File

fun sumListOfFilteredCharacters(intCharacterString: String, offset: Int): Int {
    return intCharacterString
        .filterIndexed { i, c -> c == intCharacterString[(i+offset)%intCharacterString.length] }
        .map { it.toString().toInt() }
        .fold(0, { sum, v -> sum + v })
}

val inputFile = File(if (!args.isEmpty()) args[0] else "")
if (!inputFile.exists() || !inputFile.isFile()) {
    println("input file with name '${inputFile.getPath()}' does not exist or is not a file")
    System.exit(1)
}

val inputFileText = inputFile.readText()

val sameSuccessorsSum = sumListOfFilteredCharacters(inputFileText, 1)
println("the sum of the values that are the same as their sucessor is '$sameSuccessorsSum'")

val sameHalfWayRoundSuccessorsSum = sumListOfFilteredCharacters(inputFileText, inputFileText.length/2)
println("the sum of the values that are the same as their half-way-round-sucessor is '$sameHalfWayRoundSuccessorsSum'")
