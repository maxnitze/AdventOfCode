import java.io.File

val inputFile = File(if (!args.isEmpty()) args[0] else "")
if (!inputFile.exists() || !inputFile.isFile()) {
    println("input file with name '${inputFile.getPath()}' does not exist or is not a file")
    System.exit(1)
}

val inputFileText = inputFile.readText()
val sameSuccessorsSum = inputFileText
    .filterIndexed { i, c -> c == inputFileText[(i+1)%inputFileText.length] }
    .map { it.toString().toInt() }
    .fold(0, { sum, v -> sum + v })

println("the sum of the values that are the same as their sucessor is '$sameSuccessorsSum'")

val sameHalfWayRoundSuccessorsSum = inputFileText
    .filterIndexed { i, c -> c == inputFileText[(i+inputFileText.length/2)%inputFileText.length] }
    .map { it.toString().toInt() }
    .fold(0, { sum, v -> sum + v })

println("the sum of the values that are the same as their half-way-round-sucessor is '$sameHalfWayRoundSuccessorsSum'")
