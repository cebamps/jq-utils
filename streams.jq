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
