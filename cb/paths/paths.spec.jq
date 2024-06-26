include "cb/paths"; picking(.foo.bar.deep)
{"foo": {"bar": {"deep": 123, "unrelated": null}, "unrelated": null}, "unrelated": null}
{"foo": {"bar": {"deep": 123} } }

include "cb/paths"; picking(.foo[5].bar)
{"foo": [{"bar": 123}, null, [0], 0, {}, {"bar": 456, "unrelated": null}]}
{"foo": [null, null, null, null, null, {"bar": 456 }] }

# null and the empty object are still legal for access, but the utility skips
# them
include "cb/paths"; picking(.foo[].bar?)
{"foo": [{"bar": 123}, null, [0], 0, {}, {"bar": 456, "unrelated": null}, {"bar": null}]}
{"foo": [{"bar": 123}, null, null, null, null, {"bar": 456 }, {"bar": null}] }
