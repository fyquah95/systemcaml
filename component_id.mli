type t

include Comparable.S with type t := t

val to_string : t -> string
