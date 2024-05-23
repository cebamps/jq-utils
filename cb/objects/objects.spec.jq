# flatten
include "cb/objects"; flat(join(" > "))
{"foo": {"bar": 42}, "qux": 100, "baz": {}}
{"foo > bar": 42, "qux": 100}

include "cb/objects"; flat
{"foo": {"bar": 42}, "qux": 100}
{"foo.bar": 42, "qux": 100}

# flatten with arrays
include "cb/objects"; flat
{"foo": [42, 100], "bar": []}
{"foo.0": 42, "foo.1": 100}

include "cb/objects"; flat
[42]
{"0": 42}

# flatten with nulls
include "cb/objects"; flat
{"foo": [null], "bar": {"qux": null}}
{"foo.0": null, "bar.qux": null}

# unflatten
include "cb/objects"; unflat(split(" > "))
{"foo > bar": 42, "qux": 100}
{"foo": {"bar": 42}, "qux": 100}

include "cb/objects"; unflat
{"foo.bar": 42, "qux": 100}
{"foo": {"bar": 42}, "qux": 100}

# unflatten with arrays
include "cb/objects"; unflat
{"foo.0": 42, "foo.1": 100}
{"foo": [42, 100]}

include "cb/objects"; unflat
{"foo.1": 100}
{"foo": [null, 100]}

include "cb/objects"; unflat
{"1": 42}
[null, 42]

# without arrays
include "cb/objects"; unflat(split("."))
{"foo.0": 42, "foo.1": 100}
{"foo": {"0": 42, "1": 100}}

# flatten with custom stopping criterion
include "cb/objects"; flat_on(type == "object" and has("_"))
{"foo": {"_": 42}, "qux": {"baz": 100}}
{"foo": {"_": 42}, "qux.baz": 100}

# insert between virtual entries
include "cb/objects"; ins_between("new"; 9; . == [null,null])
{}
{"new":9}

# insert between virtual entries (no such pair)
include "cb/objects"; ins_between("new"; 9; . == [null,null])
{"a":0,"b":1}
{"a":0,"b":1}

# insert at left boundary
include "cb/objects"; ins_between("new"; 9; .[0] == null) | .,keys_unsorted
{"a":0,"b":1}
{"a":0,"b":1,"new":9}
["new","a","b"]

# insert at right boundary
include "cb/objects"; ins_between("new"; 9; .[1] == null) | .,keys_unsorted
{"a":0,"b":1}
{"a":0,"b":1,"new":9}
["a","b","new"]

# insert between
include "cb/objects"; ins_between("new"; 9; map(.key) == ["a","b"]) | .,keys_unsorted
{"a":0,"b":1}
{"a":0,"new":9,"b":1}
["a","new","b"]

# updates value (when moving after)
include "cb/objects"; ins_between("b"; 9; .[1] == null) | .,keys_unsorted
{"a":1,"b":2,"c":3}
{"a":1,"c":3,"b":9}
["a","c","b"]

# updates value (when moving before)
include "cb/objects"; ins_between("b"; 9; .[0] == null) | .,keys_unsorted
{"a":1,"b":2,"c":3}
{"b":9,"a":1,"c":3}
["b","a","c"]

# no match, key does not exist in input
include "cb/objects"; ins_between("new"; 9; false)
{"a":1}
{"a":1}

# no match, key exists in input
include "cb/objects"; ins_between("a"; 9; false)
{"a":1}
{}

# predicate uses jq's notion of truthiness (null is falsy)
# The predicate skips first position using falsy null.
include "cb/objects"; ins_between("new"; 9; if .[0] == null then null else true end) | .,keys_unsorted
{"a":1,"b":2}
{"a":1,"new":9,"b":2}
["a","new","b"]

# predicate uses jq's notion of truthiness (0 is truthy)
# The predicate accepts second position using truthy 0.
include "cb/objects"; ins_between("new"; 9; if .[0] == null then false else 0 end) | .,keys_unsorted
{"a":1,"b":2}
{"a":1,"new":9,"b":2}
["a","new","b"]

### elementary tests for the shorthands, just to be sure they are coded right

include "cb/objects"; ins_before_p("new"; 9; .value == 2) | .,keys_unsorted
{"a":1,"b":2,"c":3}
{"a":1,"new":9,"b":2,"c":3}
["a","new","b","c"]

include "cb/objects"; ins_after_p("new"; 9; .value == 2) | .,keys_unsorted
{"a":1,"b":2,"c":3}
{"a":1,"b":2,"new":9,"c":3}
["a","b","new","c"]

include "cb/objects"; ins_before("new"; 9; "b") | .,keys_unsorted
{"a":1,"b":2,"c":3}
{"a":1,"new":9,"b":2,"c":3}
["a","new","b","c"]

include "cb/objects"; ins_after("new"; 9; "b") | .,keys_unsorted
{"a":1,"b":2,"c":3}
{"a":1,"b":2,"new":9,"c":3}
["a","b","new","c"]

include "cb/objects"; ins_before("r"; "b") | .,keys_unsorted
{"a":1,"b":2,"c":3,"r":9}
{"a":1,"r":9,"b":2,"c":3}
["a","r","b","c"]

include "cb/objects"; ins_before("r"; "b") | .,keys_unsorted
{"r":9,"a":1,"b":2,"c":3}
{"a":1,"r":9,"b":2,"c":3}
["a","r","b","c"]

include "cb/objects"; ins_after("r"; "b") | .,keys_unsorted
{"a":1,"b":2,"c":3,"r":9}
{"a":1,"b":2,"r":9,"c":3}
["a","b","r","c"]

include "cb/objects"; ins_after("r"; "b") | .,keys_unsorted
{"r":9,"a":1,"b":2,"c":3}
{"a":1,"b":2,"r":9,"c":3}
["a","b","r","c"]
