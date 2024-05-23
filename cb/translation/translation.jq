# Determines if a value is an object whose keys are CLDR plural rules. Follows
# CLDR conventions for en, fr, ja, ko, zh-cn, plus the nonstandard "zero" rule
# used by some TMS.
def is_plural:
  type == "object" and (
    keys | length > 0 and all(IN("one","other","zero"))
  )
;
