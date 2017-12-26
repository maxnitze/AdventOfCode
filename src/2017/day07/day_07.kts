import java.io.File

val inputFile = File(if (!args.isEmpty()) args[0] else "input")
if (!inputFile.exists() || !inputFile.isFile()) {
    println("input file with name '${inputFile.getPath()}' does not exist or is not a file")
    System.exit(1)
}

data class Node(val name: String, val weight: Int, val children: Set<String>)

val regex = """^(\S+) \((\d+)\)( -> (.*))?$""".toRegex()
val nodesMap = inputFile
    .readLines()
    .filter { regex.matches(it) }
    .map {
        val (_, name, weight, _, children) = regex.matchEntire(it)!!.groups.map { it?.value }
        Node(name!!, weight!!.toInt(), if (children != null) children.split(",").map { it.trim() }.toSet() else emptySet())
    }
    .associateBy( {it.name}, {it} )

val rootNode = nodesMap
    .map { it.value }
    .single { node -> !nodesMap.any { it.value.children.contains(node.name) } }

println("the name of the bottom program is '${rootNode.name}'")
