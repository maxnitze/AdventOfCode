import java.io.File

val inputFile = File(if (!args.isEmpty()) args[0] else "input")
if (!inputFile.exists() || !inputFile.isFile()) {
    println("input file with name '${inputFile.getPath()}' does not exist or is not a file")
    System.exit(1)
}

fun handleGroup(char: Char, sumPair: Pair<Int, Int>, state: State): Pair<Int, Int> {
    return when (char) {
        '{' -> {
            state.currentScore += 1
            sumPair
        }
        '}' -> {
            state.currentScore -= 1
            Pair(sumPair.first + (state.currentScore+1), sumPair.second)
        }
        ',' -> sumPair
        '<' -> {
            state.currentRule = "garbage"
            sumPair
        }
        else -> throw RuntimeException("something went very wrong here!")
    }
}

fun handleGarbage(char: Char, sumPair: Pair<Int, Int>, state: State): Pair<Int, Int> {
    return if (state.ignore) {
        state.ignore = false
        sumPair
    } else if (char == '!') {
        state.ignore = true
        sumPair
    } else if (char == '>') {
        state.currentRule = "group"
        sumPair
    } else {
        Pair(sumPair.first, sumPair.second+1)
    }
}

data class State(var currentRule: String, var ignore: Boolean, var currentScore: Int, var totalScore: Int)

val state = State("group", false, 0, 0)

// destructuring assignment not possible here due to script compiler bug
// https://youtrack.jetbrains.com/issue/KT-22029
val counts = inputFile
    .readText()
    .trim()
    .toCharArray()
    .fold(Pair(0, 0), { sumPair, char ->
        when (state.currentRule) {
            "group" -> {
                handleGroup(char, sumPair, state)
            }
            "garbage" -> {
                handleGarbage(char, sumPair, state)
            }
            else -> throw RuntimeException("something went very wrong here!")
        }
    })

println("the total score for all groups is '${counts.first}' with '${counts.second}' characters of garbage")
