# Stateful depth-first walk of a structure's scalars, with an update function
# transforming [state,value] pairs.
#
# (recursive implementation)
def walk_recur(update):
  if .[1] | type | (. == "object" or . == "array") then
    .[0] as $s0
    | reduce (.[1] | to_entries[]) as $x (
      [$s0];
      # re-built object/array so far
      .[1] as $acc
      # apply stateful update with current state
      | .[1] = $x.value | walk_recur(update)
      # keeping new state, place new value in accumulator
      | .[1] |= (
          . as $new
          | $acc | .[$x.key] = $new
        )
    )
  else . end
  | update
;

def traverse_recur(update):
  walk_recur(if .[1] | isempty(scalars) then . else update end)
;

# Stateful depth-first traversal of a structure's scalars, with an update
# function transforming [state,scalar] pairs.
#
# (stream-based implementation, similar to recursive but over a jq stream of
# [path,value]|[path] instead of {key,value})
def traverse_stream(update):
  .[0] as $s0
  | reduce (.[1] | tostream) as $el (
      [$s0];
      if $el | length <= 1 then .[1] += [$el]
      else
        .[1] as $acc
        | .[1] = $el[1]
        | update
        | .[1] |= $acc + [[$el[0], .]]
      end
    )
  | .[1] |= fromstream(.[])
;

# versions with initial state given as parameter
def walk_recur($s0; update): [$s0,.] | walk_recur(update);
def traverse_recur($s0; update): [$s0,.] | traverse_recur(update);
def traverse_stream($s0; update): [$s0,.] | traverse_stream(update);
