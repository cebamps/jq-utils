def divide(stream; pred):
  foreach stream as $it (
    [null,null]
    ;
    if $it | pred
      then [null,.[0]]
      else [.[0]+[$it], null]
    end
    ;
    if .[1] != null
      then .[1]
      else empty
    end
  );

def divide(pred): [divide(.[], pred)];

###

def drop_while(stream; pred):
  foreach stream as $it (
    true;  # drop
    . and ($it | pred);
    if . then empty else $it end
  );

def drop_while(pred): [drop_while(.[]; pred)];
def rdrop_while(pred): reverse | drop_while(pred) | reverse;

###

def take_until(stream; pred):
  foreach stream as $it (
    false;  # drop
    . or ($it | pred);
    if . then empty else $it end
  );

def take_until(pred): [take_until(.[]; pred)];

###

def unpad(pred): drop_while(pred) | rdrop_while(pred);
