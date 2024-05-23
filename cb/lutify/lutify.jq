# The intended use of this module is at the end: lutify and delutify. It is a
# bit specialized.
#
# The scenario is as follows: we have a collection of JSON files all following
# the exact same schema (as in: they have the same set of paths), to which we
# want to apply the same transformation to restructure them. For example:
# rename .foo to .bar, or move .foo into .bar[0].
#
# Typical use cases would be in configuration files or translations files.
#
# While it is possible to write an ad-hoc jq program to perform this
# transformation over all files, it may be more convenient to perform the
# transformation on one of the files, infer it, and apply it to the other
# files.
#
# However, to correctly infer it, we cannot have duplicate scalars in the file.
# For example, if we have [1, 1] before the transformation and [1, 1] after,
# have we replaced the second value with the first, or swapped them, or just
# left the array untouched? We need a more sophisticated approach to tackle
# that problem.
#
# lutify expands a nested data structure into three parts:
#
# - A look-alike of the input, where each scalar is now a unique string key
#   designed to look similar to the original value.
# - A look-up table that maps each of these unique keys into its path in the
#   first part.
# - The original structure.
#
# delutify undoes that transformation by performing a double lookup (unique
# string key to path, then path to value) to turn the unique string keys back
# to values. It is an inverse to lutify.
#
# While in itself this seems somewhat redundant, it gets interesting when
# the output of lutify is modified:
#
# - In the first part, restructurings are no longer ambiguous because each
#   scalar is distinct.
# - The last part is the only one that contains original values. Modifying
#   these values prior to applying delutify is like modifying them in situ in
#   the output.
#
# Back to our use case, this means we can take one file, lutify it, shuffle the
# first part, then replace the third part with any other file that shares the
# same structure and delutifying to obtain the outcome of the same shuffle on
# that other file.
#
# In other (programmatic) words: this infers the restructuring performed on
# $file1 and applies it to $file2:
#
#     $file1
#     | lutify
#     | (.[0] |= shuffle)  # performed manually in a text editor
#     | (.[2] = $file2)
#     | delutify

import "cb/traverse" as t;

########
# unicify
########

def _brand($tag): "\($tag):\(.)";

# Take all string values in a deep structure and make them unique by branding
# them with a numerical value (starting at 1) counting how many times we have
# seen this same string.
def unicify: t::traverse({};
  if .[1] | type == "string" then
    # Increment count in state .[0] for string .[1], then prepend the count to
    # .[1] with a colon separator.
    .[0][.[1]] += 1
    | .[0] as $s
    | .[1] |= _brand($s[.])
  else . end
)[1];

########
# string leaves
########

# Turn all scalars into strings. Strings have a single quote prepended to them,
# other values are json-stringified.
def string_leaves:
  (.. | scalars) |=
    if type == "string"
    then "'" + .
    else tojson
    end
;

# Opposite of string_leaves, but leaves non-strings alone.
def destring_leaves:
  (.. | strings) |=
    if startswith("'")
    then .[1:]
    else fromjson
    end
;

########
# lutify
########

# assumes strings are unique
def string_lut:
  . as $in
  | reduce paths(strings) as $p (
      {};
      setpath([$in | getpath($p)]; $p)
    )
;

# Produces a triple: a leaf-unique-stringified version of the input, a LUT from
# those unique strings to paths, and the original.
#
# The first entry of the triple can then be freely rearranged, and the
# rearrangement inferred.
def lutify:
  [
    (string_leaves | unicify | (., string_lut)),
    .
  ]
;

# Undoes lutify by double lookup (key into path, path into value).
# TODO: when we encounter a branded string with no LUT entry, remove it.
# TODO: when we encounter an unbranded string or other scalar, keep it as-is.
def delutify:
  .[1] as $paths
  | .[2] as $values
  | .[0]
  | (.. | strings) |= (
      . as $k
      | $values | getpath($paths[$k])
    );
