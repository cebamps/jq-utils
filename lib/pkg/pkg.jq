# rudimentary / ad-hoc jq package utilities

# parse def signatures out of a line of jq code, assuming a syntax subset
def signatures:
  capture("^def (?<sign>[^:]+):").sign
;

# create a barrel file out of a stream of signatures, a filter that generates a
# local module name (e.g. from input_filename), and a filter that generates an
# import path from the module name
def barrel_file(sig_expr; mod_expr; import_path):
  [sig_expr | {sig: ., mod: mod_expr} | .imp = (.mod | import_path)]
  | group_by(.mod)
  | map({
      import: .[0] | "import \"\(.imp)\" as \(.mod);",
      exports: map("def \(.sig): \(.mod)::\(.sig);")
    })
  | [[.[].import], .[].exports | join("\n")] | join("\n\n")
;

# barrel file setup for this package
def _barrel_file:
  barrel_file(
    inputs | signatures | select(startswith("_") or (input_filename | endswith("jq/main.jq")) | not);
    input_filename | split("/")[1];
    input_filename | split("/")[:2] | join("/")
  )
;
