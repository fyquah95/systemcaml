(** A restricted form of the Flambda2 IR. It has the following properties:
 *
 *  - Non synthesizable functions are removed. The exception is recursive
 *    functions. This will be transformed.
 *  - High order functions are not present.
 *  - Functions are no longer in a CPS-style code.
 *  - exceptions are not permitted.
 *  - top level static expressions are not allowed.
 *)

module rec Expr : sig
  type t =
    | Let of Let_expr.t
    | Constant of int

  (* val print : Format.formatter -> t -> unit *)

end and Let_expr : sig
  type t
end
