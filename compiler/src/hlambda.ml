open! Core
open! Ocaml_shadow
open! Ocaml_optcomp 

module Let_expr = struct
  type t = int [@@deriving sexp]

  (*
  module Arg_kind = struct
    type t =
      | Input_port
      | Output_port
      | Value (** This can be either a OCaml value or immediate.  *)
  end

  module Arg = struct
    type t =
      { kind : Arg_kind.t
      ; name : string
      }
  end
     *)
end

module Expr = struct
  type t =
    | Let of Let_expr.t
    | Constant of int
  [@@deriving sexp]
end
