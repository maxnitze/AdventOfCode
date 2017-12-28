import java.io.File

val inputFile = File(if (!args.isEmpty()) args[0] else "input")
if (!inputFile.exists() || !inputFile.isFile()) {
    println("input file with name '${inputFile.getPath()}' does not exist or is not a file")
    System.exit(1)
}

data class Program(val pid: Int, val connected: Set<Int>)

fun programForPid(pid: Int, programs: Map<Int, Program>): Program {
    return programs[pid] ?: throw RuntimeException("something went very wrong here!")
}

val inputRegex = """^(\d+) <-> (\d+(!?, \d+)*)$""".toRegex()

val programs = inputFile
    .readLines()
    .filter { inputRegex.matches(it) }
    .map {
        val (_, pid, connected) = inputRegex.matchEntire(it)!!.groups.map { it?.value }
        Program(pid!!.toInt(), connected!!.split(",").map { it.trim().toInt() }.toSet())
    }
    .associateBy( { it.pid }, { it } )

val programZeroGroup = mutableSetOf<Int>()
var programsToFollow = mutableSetOf(0)
while (programsToFollow.any()) {
    programsToFollow = programsToFollow
        .fold(mutableSetOf<Int>(), { thisProgramsToFollow, pid ->
            if (!programZeroGroup.contains(pid)) {
                programZeroGroup.add(pid)
                thisProgramsToFollow.addAll(programForPid(pid, programs).connected)
            }

            thisProgramsToFollow
        })
}

println("the group of the program with the id '0' contains '${programZeroGroup.size}' programs")
