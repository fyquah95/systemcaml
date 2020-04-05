open Core

let command =
  Command.basic
    ~summary:"OCaml FPGA High Level Syntehsis Compiler"
    [%map_open.Command
      let filename = anon ("filename" %: string) in
      fun () ->
        ignore (filename : string);
        Stdio.print_endline "Hello world"]
;;
