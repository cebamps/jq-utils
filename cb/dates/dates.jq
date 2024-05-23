# Beware: timezone handling may be unreliable due to jq's builtins. On macOS
# for example, "now | (gmtime|mktime) - ." shows a one-hour offset in my
# current timezone.
#
# Example:
#
# TZ=UTC jq -n 'include "cb/dates"; now | [., date_add(10; "months")] | map(todate)'
# [
#   "2021-08-31T09:42:38Z",
#   "2022-07-01T09:42:38Z"
# ]

def _datefield(field):
  ["years","months","days","minutes","seconds"] | index(field) // error("Invalid date field name.");

def date_add(num; field): gmtime | (.[_datefield(field)] += num) | mktime;
def date_add(num): date_add(num; "days");
