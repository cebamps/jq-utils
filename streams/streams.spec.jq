include "streams"; [pairs(.[])]
[1,2,3]
[[1,2],[2,3]]

include "streams"; [pairs_boundary(.[]; 0)]
[1,2]
[[0,1],[1,2],[2,0]]

include "streams"; [pairs_boundary(.[])]
[1,2]
[[null,1],[1,2],[2,null]]

include "streams"; [drop(2; .[])]
[1,2,3]
[3]

include "streams"; [drop(-1; .[])]
[1,2,3]
[1,2,3]

include "streams"; [tail(.[])]
[1,2,3]
[2,3]
