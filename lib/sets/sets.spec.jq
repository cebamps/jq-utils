include "lib/sets"; intersection(["e", "B", "d"])
["a","b","c"]
[]

include "lib/sets"; intersection(["e", "B", "d"])
["a","b","c"]
[]

include "lib/sets"; intersection(["e", "B", "d"]; ascii_downcase)
["a","b","c"]
["b"]

include "lib/sets"; union(["e", "B", "d"]; ascii_downcase)
["a","b","c"]
["a","b","c","e","d"]

include "lib/sets"; difference(["e", "B", "d"]; ascii_downcase)
["a","b","c"]
["a","c"]

include "lib/sets"; sym_difference(["e", "B", "d"]; ascii_downcase)
["a","b","c"]
["a","c","e","d"]

# input bias: input dictates the order and item duplication

include "lib/sets"; intersection([2,3,3])
[1,3,2,2]
[3,2,2]

include "lib/sets"; union([5,4,4,2,3,3])
[1,3,2,2]
[1,3,2,2,5,4,4]

include "lib/sets"; sym_difference([5,4,4,2,3,3])
[1,3,2,2,1]
[1,1,5,4,4]
