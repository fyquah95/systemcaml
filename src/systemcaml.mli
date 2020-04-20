module Input : sig
  type t
end

module Output : sig
  type t
end

val input : string -> int -> Input.t
val output : string -> int -> Output.t
val read : Input.t -> int
val write : Output.t -> int -> unit
