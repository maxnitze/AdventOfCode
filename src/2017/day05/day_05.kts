import java.io.File

val inputFile = File(if (!args.isEmpty()) args[0] else "input")
if (!inputFile.exists() || !inputFile.isFile()) {
    println("input file with name '${inputFile.getPath()}' does not exist or is not a file")
    System.exit(1)
}

val offsetList = inputFile
    .readLines()
    .map { it.toInt() }

val partOneOffsetList = offsetList.toMutableList()

var partOneIndex = 0
var partOneSteps = 0
while (partOneIndex < partOneOffsetList.size) {
    partOneOffsetList[partOneIndex] += 1
    partOneIndex += partOneOffsetList[partOneIndex]-1
    partOneSteps += 1
}

println("it takes '${partOneSteps}' steps to the first one leading out of the list when increasing by one")

val partTwoOffsetList = offsetList.toMutableList()

var partTwoIndex = 0
var partTwoSteps = 0
while (partTwoIndex < partTwoOffsetList.size) {
    val incValue = if (partTwoOffsetList[partTwoIndex] >= 3) -1 else 1
    partTwoOffsetList[partTwoIndex] += incValue
    partTwoIndex += partTwoOffsetList[partTwoIndex]-incValue
    partTwoSteps += 1
}

println("it takes '${partTwoSteps}' steps to the first one leading out of the list when increasing by one or decreasing by three")
