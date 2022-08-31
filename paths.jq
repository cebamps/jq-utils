# Reconstructs an object out of a sequence of paths, taking only the values referenced in the paths.
#
# Example: focus on all "foo" values in a deeply nested object, by removing everything else:
#    pick(path(.. | objects | select(has("foo")).foo))
# Shorthand:
#    picking(.. | objects | select(has("foo")).foo)
def pick(paths):
  def haspath($path):
    getpath($path[:-1]) | has($path[-1]);

  . as $o | reduce paths as $p
    ( null
    ; if $o | haspath($p) then setpath($p; $o | getpath($p)) else . end
    );

def picking(pathexprs): pick(path(pathexprs));
