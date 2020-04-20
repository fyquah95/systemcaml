module Input = struct
  type t
end

module Output = struct
  type t
end

external input : string -> int -> Input.t = "systemcaml__input" 
external output : string -> int -> Output.t = "systemcaml__output"
external read : Input.t -> int = "systemcaml__read"
external write : Output.t -> int -> unit = "systemcaml__write"
