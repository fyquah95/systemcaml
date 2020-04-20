open! Base
open! Ocaml_shadow
open! Ocaml_optcomp
open! Flambda2_basic

module Continuation = struct
  module T = struct
    type t = Continuation.t [@@deriving compare]

    let sexp_of_t (t : Continuation.t) = Int.sexp_of_t (t :> int)
  end

  include T
  include Comparable.Make(T)
end

type continuation =
  | Return
  | Exn
  | Inline of
      { handler_body : Flambda.Expr.t
      ; handler_params : Flambda2_basic.Kinded_parameter.t list
      }

type t =
  { continuations : continuation Map.M(Continuation).t
  }

let enter_function_definition ~return_continuation ~exn_continuation =
  if Continuation.equal return_continuation exn_continuation then (
    raise_s [%message
       "Return continuation and exn continuation cannot be equal"
    ];
  );
  let continuations =
    Map.of_alist_exn
      (module Continuation)
      [ return_continuation, Return
      ; exn_continuation, Exn
      ]
  in
  { continuations }
;;

let get_continuation t continuation =
  Map.find_exn t.continuations continuation
;;

