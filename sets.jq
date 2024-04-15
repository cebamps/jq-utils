# The output of union and intersection is biased toward the input:
# - When items are kept that exist in both the input and the first argument,
#   the version from the input is the one that is retained.
# - When duplicates exist in the input, they are preserved. Duplicates that
#   only exist in the argument are also preserved.
# - Items that exist in the input come first, and their order is preserved.
#
# Similarly, symmetric difference start with items from the input, in the same
# order as they were found in the input.
#
# Difference works exactly as a filter on the input that rules out items that
# exist in the argument.
#

# Intersect arrays by a function that maps items to comparable values.
def intersection($other; f):
  map(select(IN(f; $other[] | f)))
;
# Intersect arrays by equality.
def intersection(other): intersection(other; .);

def difference($other; f):
  map(select(IN(f; $other[] | f) | not))
;
def difference(other): difference(other; .);

def union($other; f):
  . + (. as $in | $other | difference($in; f))
;
def union(other): union(other; .);

def sym_difference($other; f):
  difference($other; f) + (. as $in | $other | difference($in; f))
;
def sym_difference(other): sym_difference(other; .);
