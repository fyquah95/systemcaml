type input
type output

external input : string -> int -> input = "systemcaml__input" [@@noalloc]
external output : string -> int -> output = "systemcaml__output" [@@noalloc]

external read_input : input -> int = "systemcaml__read_input"
external write_output : output -> int -> unit = "systemcaml__read_output"

let main (input : input) (output : output) : unit =
  let x = read_input input in
  write_output output (x + 1)
;;
