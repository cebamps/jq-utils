# Recursive version of "type"
# On arrays, we assume all elements have the same shape; only the first element is recursed into (if it exists).
# On objects, recursion is done on values.
# The optional parameter specifies the recursion depth. Use a negative value for unbounded recursion.
def deeptype(depth):
  if depth == 0 then
    type
  elif type == "array" then
    .[:1] | map(deeptype(depth-1))
  elif type == "object" then
    map_values(deeptype(depth-1))
  else
    type
  end;

def deeptype: deeptype(-1);
def types: types(1);
