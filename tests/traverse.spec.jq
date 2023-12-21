# State is an array starting with a number. Update transform: append value to
# state, replace value with that first number, then increment the number.
include "traverse"; traverse_recur([0]; .[0] += [.[1]] | .[1] = .[0][0] | .[0][0] += 1)[]
{"a": "hello", "b": [[["world", "!"], false], null]}
[5,"hello","world","!",false,null]
{"a": 0, "b": [[[1, 2], 3], 4]}

include "traverse"; traverse_stream([0]; .[0] += [.[1]] | .[1] = .[0][0] | .[0][0] += 1)[]
{"a": "hello", "b": [[["world", "!"], false], null]}
[5,"hello","world","!",false,null]
{"a": 0, "b": [[[1, 2], 3], 4]}
