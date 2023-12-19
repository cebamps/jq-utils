# Turns a stream of values into a stream of (overlapping) pairs.
def pairs(s):
  foreach s as $x (
    [];
    .[-1:] + [$x];
    if length < 2 then empty else . end
  )
;

# Like pairs, but also includes custom values at the boundaries.
#
# Example: [pairs_boundary(1)] == [[null,1], [1,null]]
def pairs_boundary(s; boundary): pairs(boundary, s, boundary);

# pairs_boundary/2 with null as the boundary value.
def pairs_boundary(s): pairs_boundary(s; null);

# Drops the first n elements of the stream.
def drop(n; s):
  foreach s as $x (
    n;
    . - 1;
    if . < 0 then $x else empty end
  )
;

# Drops the first element of the stream.
def tail(s): drop(1; s);

def _jq_truthy: not | not;

# TODO: document, test, maybe generalize
def ins_between(s; f; x; pred):
  # box values so we know null is the sentinel
  foreach pairs_boundary(s | [.]) as $pair (
    # state values: false: "do not insert yet"; true: "insert now"; null: "done"
    false;
    if . == false then
      $pair | pred | _jq_truthy
    else null end;
    # skip virtual beginning entry
    ($pair[0] | values | .[0] | f),
    # (null | x) ensures no information leaks into x
    if . == true then (null | x) else empty end
  )
;
