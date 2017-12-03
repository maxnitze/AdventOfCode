import java.io.File

val inputFile = File(if (!args.isEmpty()) args[0] else "")
if (!inputFile.exists() || !inputFile.isFile()) {
    println("input file with name '${inputFile.getPath()}' does not exist or is not a file")
    System.exit(1)
}

val inputFileMatrix = inputFile
    .readLines()
    .map { it.split("\\s+".toRegex()).map { it.toInt() } }

val checksum = inputFileMatrix
    .map { it.max()!! - it.min()!! }
    .fold(0, { sum, v -> sum + v } )
println("the checksum of the spredsheet is '$checksum'")
