#!/usr/bin/env -S jq -Rrn -f

def signatures: capture("^def (?<sign>[^:]+):").sign | select((startswith("_") | not) and (input_filename | startswith("jq/") | not));

reduce (inputs | signatures) as $s ({}; .[input_filename] += [$s])
| to_entries
| map(
    (.key | split("/")[0]) as $mod | .value
    | {import: "import \"lib/\($mod)\" as \($mod);", exports: map("def \(.): \($mod)::\(.);")}
  )
| [[.[].import], .[].exports | join("\n")] | join("\n\n")
