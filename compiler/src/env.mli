open! Ocaml_shadow
open! Ocaml_optcomp
open! Flambda2_basic

type t

type continuation =
  | Return
  | Exn
  | Inline of
      { handler_body : Flambda.Expr.t
      ; handler_params : Flambda2_basic.Kinded_parameter.t list
      }

val enter_function_definition
  :  return_continuation: Continuation.t
  -> exn_continuation:  Continuation.t
  -> t

val get_continuation : t -> Continuation.t -> continuation

