import java.io.File

val inputFile = File(if (!args.isEmpty()) args[0] else "input")
if (!inputFile.exists() || !inputFile.isFile()) {
    println("input file with name '${inputFile.getPath()}' does not exist or is not a file")
    System.exit(1)
}

fun compare(expr: String, registers: MutableMap<String, Int>): Boolean {
    val (_, cmpVar, cmp, cmpVal) = """^(\S+) (==|!=|<=|>=|<|>) (\-?\d+)$""".toRegex().matchEntire(expr)!!.groups.map { it!!.value }
    val registerVal = registers.getOrPut(cmpVar, { 0 })
    return when (cmp) {
        "==" -> registerVal == cmpVal.toInt()
        "!=" -> registerVal != cmpVal.toInt()
        "<=" -> registerVal <= cmpVal.toInt()
        ">=" -> registerVal >= cmpVal.toInt()
        "<"  -> registerVal <  cmpVal.toInt()
        ">"  -> registerVal >  cmpVal.toInt()
        else -> throw RuntimeException("something went very wrong here!")
    }
}

val regex = """^(\S+) (inc|dec) (\-?\d+) if (\S+ (!?==|!=|<=|>=|<|>) \-?\d+)$""".toRegex()

var highestOverallValue = 0
val registers = inputFile
    .readLines()
    .filter { regex.matches(it) }
    .fold(mutableMapOf<String, Int>(), { registers, line ->
        val (_, assVar, incDec, assVal, expr) = regex.matchEntire(line)!!.groups.map { it!!.value }
        
        if (compare(expr, registers)) {
            when (incDec) {
                "inc" -> registers.put(assVar, registers.getOrPut(assVar, { 0 }) + assVal.toInt())
                "dec" -> registers.put(assVar, registers.getOrPut(assVar, { 0 }) - assVal.toInt())
                else -> throw RuntimeException("something went very wroong here!")
            }

            val assVarRegisterVal = registers.get(assVar)!!
            highestOverallValue = if (assVarRegisterVal > highestOverallValue) assVarRegisterVal else highestOverallValue
        }

        registers
    })

val highestEndValue = registers
    .map { it.value }
    .max()

println("after completing the instructions the largest value is any register is '${highestEndValue ?: "null"}'")
println("during the process the highest value of any register was '$highestOverallValue'")
