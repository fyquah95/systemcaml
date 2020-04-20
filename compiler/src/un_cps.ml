open! Base
open! Ocaml_shadow
open! Ocaml_optcomp
open! Flambda2_basic

let of_flambda_expr (expr : Flambda.Expr.t) =
  let descr = Flambda.Expr.descr expr in
  match descr with
  | Let_cont let_cont ->
    begin match let_cont with
      | Non_recursive { handler = _; num_free_occurrences = _ } ->
        Non_recursive.
        ()
      | Recursive _ -> ()
    end
  | _ -> assert false

;;

let of_flambda_unit (flambda : Flambda_unit.t) =
  let body = Flambda_unit.body flambda in
  let _bla = of_flambda_expr body in
  Hlambda.Expr.Constant 0
;;
