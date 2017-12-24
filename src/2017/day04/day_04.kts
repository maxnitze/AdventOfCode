import java.io.File

val inputFile = File(if (!args.isEmpty()) args[0] else "input")
if (!inputFile.exists() || !inputFile.isFile()) {
    println("input file with name '${inputFile.getPath()}' does not exist or is not a file")
    System.exit(1)
}

val validPasswords = inputFile
    .readLines()
    .map { it.split("\\s+".toRegex()) }
    .filter { it.size == it.distinct().size }
    .size

println("the input contains '$validPasswords' valid passwords")
