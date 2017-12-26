import java.io.File

val inputFile = File(if (!args.isEmpty()) args[0] else "input")
if (!inputFile.exists() || !inputFile.isFile()) {
    println("input file with name '${inputFile.getPath()}' does not exist or is not a file")
    System.exit(1)
}

data class Node(val name: String, val weight: Int, val children: Set<String>)

fun nodeForName(nodeName: String, nodesMap: Map<String, Node>): Node {
    return nodesMap[nodeName] ?: throw RuntimeException("something went very wrong here!")
}

fun towerWeightOfNode(nodeName: String, nodesMap: Map<String, Node>): Int {
    val node = nodeForName(nodeName, nodesMap)
    return node.weight + node.children
        .map { towerWeightOfNode(it, nodesMap) }
        .fold(0, { sum, v -> sum + v } )
}

val regex = """^(\S+) \((\d+)\)( -> (.*))?$""".toRegex()
val nodesMap = inputFile
    .readLines()
    .filter { regex.matches(it) }
    .map {
        val (_, name, weight, _, children) = regex.matchEntire(it)!!.groups.map { it?.value }
        Node(name!!, weight!!.toInt(), if (children != null) children.split(",").map { it.trim() }.toSet() else emptySet())
    }
    .associateBy( { it.name }, { it } )

val rootNode = nodesMap
    .map { it.value }
    .single { node -> !nodesMap.any { it.value.children.contains(node.name) } }

println("the name of the bottom program is '${rootNode.name}'")

val unbalancedDiscNode = nodesMap
    .map { it.value }
    .filter { !it.children.isEmpty() }
    .filter {
        it.children.all { 
            nodeForName(it, nodesMap).children.map { towerWeightOfNode(it, nodesMap) }.distinct().size == 1
        }
    }
    .single {
        it.children.map { towerWeightOfNode(it, nodesMap) }.distinct().size != 1
    }

val wrongWeightNode = nodeForName(unbalancedDiscNode
    .children
    .single { nodeName ->
        unbalancedDiscNode.children.map { towerWeightOfNode(it, nodesMap) }.count { it == towerWeightOfNode(nodeName, nodesMap) } == 1
    }, nodesMap)

val rightFullWeight = towerWeightOfNode(unbalancedDiscNode
    .children
    .find { nodeName ->
        unbalancedDiscNode.children.map { towerWeightOfNode(it, nodesMap) }.count { it == towerWeightOfNode(nodeName, nodesMap) } != 1
    }!!, nodesMap)

val balancedWeight = wrongWeightNode.weight + (rightFullWeight - towerWeightOfNode(wrongWeightNode.name, nodesMap))

println("the disc of '${unbalancedDiscNode.name}' is unbalanced, bc '${wrongWeightNode.name} (${wrongWeightNode.weight})' should have a weight of $balancedWeight")
