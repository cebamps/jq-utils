def isiterable: isempty(scalars);

# Stateful depth-first walk of a structure's scalars, with an update function
# transforming [state,value] pairs.
#
# (recursive implementation)
def walkstate_recur(update):
  if .[1] | isiterable then
    .[0] as $s0
    | reduce (.[1] | to_entries[]) as $x (
      [$s0];
      # re-built object/array so far
      .[1] as $acc
      # apply stateful update with current state
      | .[1] = $x.value | walkstate_recur(update)
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
  walkstate_recur(if .[1] | isiterable then . else update end)
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
def walkstate_recur($s0; update): [$s0,.] | walkstate_recur(update);
def traverse_recur($s0; update): [$s0,.] | traverse_recur(update);
def traverse_stream($s0; update): [$s0,.] | traverse_stream(update);

# names with no reference to implementation detail
def walkstate(s0; update): walkstate_recur(s0; update);
def walkstate(update): walkstate_recur(update);
def traverse(s0; update): traverse_stream(s0; update);
def traverse(update): traverse_stream(update);
