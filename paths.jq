# Reconstructs an object out of a sequence of paths, taking only the values referenced in the paths.
#
# Example: focus on all "foo" values in a deeply nested object, by removing everything else:
#    pick(path(.. | objects | select(has("foo")).foo))
# Shorthand:
#    picking(.. | objects | select(has("foo")).foo)
def pick(paths):
  . as $o | reduce paths as $p
    ( null
    ; setpath($p; $o | getpath($p))
    );

def picking(pathexprs): pick(path(pathexprs));
