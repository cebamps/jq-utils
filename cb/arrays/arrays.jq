import "cb/streams" as s;

# index, with predicate
def index_p(pred):
  label $out | foreach .[] as $x (-1; . + 1;
    if $x|pred then (., break $out) else empty end
  ) // null
;

def pairs: [s::pairs(.[])];
def pairs_boundary(boundary): [s::pairs_boundary(.[]; boundary)];
def pairs_boundary: [s::pairs_boundary(.[])];
