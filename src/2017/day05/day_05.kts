import java.io.File

val inputFile = File(if (!args.isEmpty()) args[0] else "input")
if (!inputFile.exists() || !inputFile.isFile()) {
    println("input file with name '${inputFile.getPath()}' does not exist or is not a file")
    System.exit(1)
}

val offsetList = inputFile
    .readLines()
    .map { it.toInt() }
    .toMutableList()

var index = 0
var steps = 0
while (index < offsetList.size) {
    offsetList[index] += 1
    index += offsetList[index]-1
    steps += 1
}

println("it takes '${steps}' steps to the first one leading out of the list")
