import java.io.File

fun getEvenDivision(list: List<Int>, i: Int, j: Int): Int {
    if (i >= j || i >= list.size) {
        println("something went very wrong!")
        System.exit(1)
    }

    return if (j >= list.size) {
        getEvenDivision(list, i+1, i+2)
    } else if (list[i]%list[j] == 0) {
        list[i]/list[j]
    } else if (list[j]%list[i] == 0) {
        list[j]/list[i]
    } else {
        getEvenDivision(list, i, j+1)
    }
}

val inputFile = File(if (!args.isEmpty()) args[0] else "")
if (!inputFile.exists() || !inputFile.isFile()) {
    println("input file with name '${inputFile.getPath()}' does not exist or is not a file")
    System.exit(1)
}

val inputFileMatrix = inputFile
    .readLines()
    .map { it.split("\\s+".toRegex()).map { it.toInt() } }

val minMaxChecksum = inputFileMatrix
    .map { it.max()!! - it.min()!! }
    .fold(0, { sum, v -> sum + v } )
println("the minimum-maximum-checksum of the spredsheet is '$minMaxChecksum'")

val evenDivisionChecksum = inputFileMatrix
    .map { getEvenDivision(it, 0, 1) }
    .fold(0, { sum, v -> sum + v } )
println("the even-division-checksum of the spredsheet is '$evenDivisionChecksum'")
