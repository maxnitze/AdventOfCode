import java.io.File

val inputFile = File(if (!args.isEmpty()) args[0] else "input")
if (!inputFile.exists() || !inputFile.isFile()) {
    println("input file with name '${inputFile.getPath()}' does not exist or is not a file")
    System.exit(1)
}

val noDuplicatePasswords = inputFile
    .readLines()
    .map { it.split("\\s+".toRegex()) }
    .filter { it.size == it.distinct().size }
    .size

println("the input contains '$noDuplicatePasswords' valid passphrases with no duplicate words")

val noAnagramPasswords = inputFile
    .readLines()
    .map { it.split("\\s+".toRegex()) }
    .filter { it.size == it.map { it.toCharArray().sorted() }.distinct().size }
    .size

println("the input contains '$noAnagramPasswords' valid passphrases with no anagrams")
