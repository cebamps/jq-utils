#!/usr/bin/env -S jq -Rrn -f

def signatures: capture("^def (?<sign>[^:]+):").sign | select(startswith("_") | not);

reduce (inputs | signatures) as $s ({}; .[input_filename] += [$s])
| to_entries
| map(
    (.key | split("/")[0]) as $mod | .value
    | {import: "import \"\($mod)\" as \($mod);", exports: map("def \(.): \($mod)::\(.);")}
  )
| [[.[].import], .[].exports | join("\n")] | join("\n\n")
