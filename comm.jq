def intersect(other; on): map(select(IN(. | on; other[] | on)));
def intersect(other): intersect(other; .);

def sub(other; on): map(select(IN(. | on; other[] | on) | not));
def sub(other): sub(other; .);

def comm(other; on):
  intersect(other; on) as $int |
  {
    left: sub($int; on),
    right: (other | sub($int; on)),
    both: $int,
  };
def comm(other) = comm(other; .);
