include "lib/lutify"; unicify
{ "a": [1,   "hi",   "world"], "b":   "hi", "c": true }
{ "a": [1, "1:hi", "1:world"], "b": "2:hi", "c": true }

include "lib/lutify"; map(string_leaves)
[  "hello",  "'world",  null ,  -1 , {"k":  true }, [ false ] ]
[ "'hello", "''world", "null", "-1", {"k": "true"}, ["false"] ]

include "lib/lutify"; map(destring_leaves)
[ "'hello", "''world", "null", "-1", {"k": "true"}, ["false"] ]
[  "hello",  "'world",  null ,  -1 , {"k":  true }, [ false ] ]

include "lib/lutify"; map(destring_leaves)
[ 0, -1, null, {"k": true}, [false] ]
[ 0, -1, null, {"k": true}, [false] ]

include "lib/lutify"; lutify[]
{ "a":    "hello", "b": [   "world",    "hello", [   42 ]] }
{ "a": "1:'hello", "b": ["1:'world", "2:'hello", ["1:42"]] }
{ "1:'hello": ["a"], "1:'world": ["b",0], "2:'hello": ["b",1],"1:42": ["b",2,0] }
{ "a":    "hello", "b": [   "world",    "hello", [   42 ]] }

# shuffling is the same as shuffling the first lutify element
include "lib/lutify"; def shuf: .c = .b | .b |= [.[2][0],.[0]]; shuf, shuf == (lutify | (.[0] |= shuf) | delutify)
{"a":"hello","b":["world","hello",[42]]}
{"a":"hello","c":["world","hello",[42]],"b":[42,"world"]}
true

# intended use case: shuffle the first and substitute the last
include "lib/lutify"; lutify | .[0] |= reverse | .[2] = ["goodbye","mars"] | delutify
["hello","world"]
["mars","goodbye"]

include "lib/lutify"; lutify | .[0] |= {a:.b, b:.a} | .[2] = {a:"goodbye", b:"mars"} | delutify
{"a":"hello","b":"world"}
{"a":"mars","b":"goodbye"}
