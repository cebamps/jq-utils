import "lib/arrays" as arrays;
import "lib/dates" as dates;
import "lib/deeptype" as deeptype;
import "lib/i18n" as i18n;
import "lib/lutify" as lutify;
import "lib/objects" as objects;
import "lib/paths" as paths;
import "lib/sets" as sets;
import "lib/streams" as streams;
import "lib/to_sort" as to_sort;
import "lib/translation" as translation;
import "lib/traverse" as traverse;

def index_p(pred): arrays::index_p(pred);
def pairs: arrays::pairs;
def pairs_boundary(boundary): arrays::pairs_boundary(boundary);
def pairs_boundary: arrays::pairs_boundary;

def date_add(num; field): dates::date_add(num; field);
def date_add(num): dates::date_add(num);

def deeptype(depth): deeptype::deeptype(depth);
def deeptype: deeptype::deeptype;
def types: deeptype::types;

def plural: i18n::plural;

def unicify: lutify::unicify;
def string_leaves: lutify::string_leaves;
def destring_leaves: lutify::destring_leaves;
def string_lut: lutify::string_lut;
def lutify: lutify::lutify;
def delutify: lutify::delutify;

def flat(f; stop): objects::flat(f; stop);
def flat(f): objects::flat(f);
def flat: objects::flat;
def flat_on(stop): objects::flat_on(stop);
def unflat(f): objects::unflat(f);
def unflat: objects::unflat;
def ins_between($k; $v; pred): objects::ins_between($k; $v; pred);
def ins_before_p($k; $v; pred): objects::ins_before_p($k; $v; pred);
def ins_after_p($k; $v; pred): objects::ins_after_p($k; $v; pred);
def ins_before($k; $v; $ref): objects::ins_before($k; $v; $ref);
def ins_after($k; $v; $ref): objects::ins_after($k; $v; $ref);
def ins_before($k; $ref): objects::ins_before($k; $ref);
def ins_after($k; $ref): objects::ins_after($k; $ref);

def pick(paths): paths::pick(paths);
def picking(pathexprs): paths::picking(pathexprs);

def intersection($other; f): sets::intersection($other; f);
def intersection(other): sets::intersection(other);
def difference($other; f): sets::difference($other; f);
def difference(other): sets::difference(other);
def union($other; f): sets::union($other; f);
def union(other): sets::union(other);
def sym_difference($other; f): sets::sym_difference($other; f);
def sym_difference(other): sets::sym_difference(other);

def pairs(s): streams::pairs(s);
def pairs_boundary(s; boundary): streams::pairs_boundary(s; boundary);
def pairs_boundary(s): streams::pairs_boundary(s);
def drop(n; s): streams::drop(n; s);
def tail(s): streams::tail(s);

def divide(stream; pred): to_sort::divide(stream; pred);
def divide(pred): to_sort::divide(pred);
def drop_while(stream; pred): to_sort::drop_while(stream; pred);
def drop_while(pred): to_sort::drop_while(pred);
def rdrop_while(pred): to_sort::rdrop_while(pred);
def take_until(stream; pred): to_sort::take_until(stream; pred);
def take_until(pred): to_sort::take_until(pred);
def unpad(pred): to_sort::unpad(pred);
def edge_flip: to_sort::edge_flip;

def is_plural: translation::is_plural;

def isiterable: traverse::isiterable;
def walkstate_recur(update): traverse::walkstate_recur(update);
def traverse_recur(update): traverse::traverse_recur(update);
def traverse_stream(update): traverse::traverse_stream(update);
def walkstate_recur($s0; update): traverse::walkstate_recur($s0; update);
def traverse_recur($s0; update): traverse::traverse_recur($s0; update);
def traverse_stream($s0; update): traverse::traverse_stream($s0; update);
def walkstate(s0; update): traverse::walkstate(s0; update);
def walkstate(update): traverse::walkstate(update);
def traverse(s0; update): traverse::traverse(s0; update);
def traverse(update): traverse::traverse(update);
