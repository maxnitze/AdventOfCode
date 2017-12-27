import java.io.File

val inputFile = File(if (!args.isEmpty()) args[0] else "input")
if (!inputFile.exists() || !inputFile.isFile()) {
    println("input file with name '${inputFile.getPath()}' does not exist or is not a file")
    System.exit(1)
}

data class State(var currentRule: String, var ignore: Boolean, var currentScore: Int, var totalScore: Int)

val state = State("group", false, 0, 0)
val summedScore = inputFile
    .readText()
    .trim()
    .toCharArray()
    .fold(0, { sum, char ->
        when (state.currentRule) {
            "group" -> {
                when (char) {
                    '{' -> {
                        state.currentScore += 1
                        sum
                    }
                    '}' -> {
                        state.currentScore -= 1
                        sum + (state.currentScore+1)
                    }
                    ',' -> sum
                    '<' -> {
                        state.currentRule = "garbage"
                        sum
                    }
                    else -> throw RuntimeException("something went very wrong here!")
                }
            }
            "garbage" -> {
                if (state.ignore) {
                    state.ignore = false
                } else if (char == '!') {
                    state.ignore = true
                } else if (char == '>') {
                    state.currentRule = "group"
                }

                sum
            }
            else -> throw RuntimeException("something went very wrong here!")
        }
    })

println("the total score for all groups is '$summedScore'")
