import java.io.File

val inputFile = File(if (!args.isEmpty()) args[0] else "input")
if (!inputFile.exists() || !inputFile.isFile()) {
    println("input file with name '${inputFile.getPath()}' does not exist or is not a file")
    System.exit(1)
}

fun reallocateConfig(config: MutableList<Int>) {
    val maxIndex = (0..config.size-1)
        .maxBy { config[it] }
    if (maxIndex != null) {
        val maxBlocks = config[maxIndex]
        config[maxIndex] = 0
        (0..config.size-1)
            .forEach {
                config[it] += maxBlocks/config.size + if ((it-1-maxIndex+config.size)%config.size < maxBlocks%config.size) 1 else 0
            }
    } else {
        throw RuntimeException("something went very wrong here!")
    }
}

val currentConfig = inputFile
    .readLines()[0]
    .split("\\s+".toRegex())
    .map { it.toInt() }
    .toMutableList()

val configs = mutableListOf<List<Int>>()
var cycles = 0
var currentConfigIndex: Int
do {
    configs.add(currentConfig.toList())
    reallocateConfig(currentConfig)
    cycles += 1
    currentConfigIndex = configs.indexOf(currentConfig.toList())
} while (currentConfigIndex == -1)

println("it takes '$cycles' redistribution cycles to reach a configuration, that had been seen before")
println("the length of the found cycle is '${configs.size-currentConfigIndex}'")
