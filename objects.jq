import "streams" as s;

def _unpairs_boundary: .[1:] | map(.[0]);

# Inserts a key-value pair in the input object at the first location satisfied
# by a given predicate.
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
def ins_between($k; $v; pred):
  reduce s::pairs_boundary(to_entries[]) as $pair (
    # accumulator, and entry to insert (cleared once inserted)
    {acc: [], ins: {key:$k, value:$v}};
    ((.ins != null) and ($pair | pred)) as $matched
    | (.acc = .acc + [
        # skip virtual beginning entry and old entry for $k
        ($pair[0] | values | select(.key != $k)),
        (if $matched then .ins else empty end)
      ])
    | (.ins |= if $matched then null else . end)
  )
  | .acc
  | from_entries;

# Inserts a key-value pair in an object before the first {key,value} (or null)
# satisfying the predicate. The null entry is a virtual entry after the last
# entry.
def ins_before_p($k; $v; pred):
  ins_between($k; $v; .[1] | pred);

# Inserts a key-value pair in an object after the first {key,value} (or null)
# satisfying the predicate. The null entry is a virtual entry before the first
# entry.
def ins_after_p($k; $v; pred):
  ins_between($k; $v; .[0] | pred);

# Inserts a key-value pair in an object before the given key (or null). The
# null entry is a virtual entry after the last entry.
def ins_before($k; $v; $ref):
  ins_before_p($k; $v; .key == $ref);

# Inserts a key-value pair in an object after the given key (or null). The null
# entry is a virtual entry before the first entry.
def ins_after($k; $v; $ref):
  ins_after_p($k; $v; .key == $ref);

# Moves the key passed first before the key passed second (or null to move it
# to last position).
def ins_before($k; $ref):
  ins_before_p($k; .[$k]; .key == $ref);

# Moves the key passed first after the key passed second (or null to move it to
# first position).
def ins_after($k; $ref):
  ins_after_p($k; .[$k]; .key == $ref);

