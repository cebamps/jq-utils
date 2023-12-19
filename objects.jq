import "streams" as s;

def _jq_truthy: not | not;

# Inserts an ordered set of key-value pairs in the input object at the first location satisfied
# by a given predicate.
#
# The ordered set is provided as an object.
#
# The predicate receives a pair of entries as a two-item array. The key is
# inserted between those entries.
#
# An entry is either a {key,value} object, or null. There are two null entries:
# before the first entry of the input and after the last one. This allows
# insertion at the beginning or end of the input.
#
# In particular, when the input is empty, the predicate is only tested once,
# against the input [null,null].
def ins_between($kv; pred):
  [s::ins_between(
    to_entries[]; 
    select(.key | in($kv) | not);
    $kv | to_entries[];
    map(.[0]) | pred
  )] | from_entries;

# Same as ins_between/2, but with a single key and value passed individually.
def ins_between($k; $v; pred):
  ins_between({($k): $v}; pred);

# Inserts key-value pairs in an object before the first {key,value} (or null)
# satisfying the predicate. The null entry is a virtual entry after the last
# entry.
def ins_before($kv; pred):
  ins_between($kv; .[1] | pred);

# Inserts key-value pairs in an object after the first {key,value} (or null)
# satisfying the predicate. The null entry is a virtual entry before the first
# entry.
def ins_after($kv; pred):
  ins_between($kv; .[0] | pred);

# Inserts key-value pairs in an object before the given key (or null). The null
# entry is a virtual entry after the last entry.
def ins_before_key($kv; $ref):
  ins_before($kv; .key == $ref);

# Inserts key-value pairs in an object after the given key (or null). The null
# entry is a virtual entry before the first entry.
def ins_after_key($kv; $ref):
  ins_after($kv; .key == $ref);

# Moves the key passed first before the key passed second (or null to move it
# to last position).
def mv_before_key($k; $ref):
  ins_before_key({($k): .[$k]}; $ref);

# Moves the key passed first after the key passed second (or null to move it to
# first position).
def mv_after_key($k; $ref):
  ins_after_key({($k): .[$k]}; $ref);
