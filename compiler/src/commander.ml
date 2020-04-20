open! Core

(*
let compile_code (code : Flambda.Static_const.Code.t) : Compiled_function.t =
  let params_and_body = code.params_and_body in
  match params_and_body with
  | Deleted -> Deleted
  | Present function_params_and_body ->
    Flambda.Function_params_and_body.pattern_match
      function_params_and_body
      ~f:(fun ~return_continuation exn_continuation parameter_list ~body ~my_closure ->
          (* CR fquah: Actual logic comes here. *)
          Compiled_function.Synthesizable
      )
;;

let rec compile indent (body : Ocaml_optcomp.Flambda.Expr.t) =
  let open Ocaml_optcomp in
  let descr = Flambda.Expr.descr body in
  match descr with
  | Let_symbol let_symbol_expr ->
    let bound_symbols =
      Flambda.Let_symbol_expr.bound_symbols let_symbol_expr
    in
    begin match bound_symbols with
      | Singleton symbol ->
        ()
      | Sets_of_closures sets_of_closures ->
        List.iter sets_of_closures ~f:(fun set_of_closure ->
            let module C =
              Flambda.Let_symbol_expr.Bound_symbols.Code_and_set_of_closures
            in
            let closure_symbols = set_of_closure.closure_symbols in
            ()
          )
    end;
    let static_const =
      Flambda.Let_symbol_expr.defining_expr let_symbol_expr
    in
    begin match static_const with
      | Sets_of_closures sets_of_closures ->
        List.iter sets_of_closures ~f:(fun set_of_closures ->
            let code = set_of_closures.code in
            let set_of_closures = set_of_closures.set_of_closures in
            let function_declarations = 
              Flambda.Set_of_closures.function_decls set_of_closures
            in
            let module M = Flambda2_basic.Code_id.Map in
            Flambda2_basic.Closure_id.Map.iter
              (fun closure_id function_decl ->
                 let code_id = Function_declaration.code_id function_decl in
                 ()
              )
              (Function_declarations.funs function_declarations)
          )
      | _ -> ()
    end;
    Format.printf "%s====================\n" indent;
    Format.printf "%s   bound symbols:\n" indent;
    Format.printf "%s====================\n" indent;
    Format.printf "%s%a" indent Flambda.Let_symbol_expr.Bound_symbols.print bound_symbols;
    Format.printf "%s\n\n" indent;
    Format.printf "%s====================\n"indent ;
    Format.printf "%s   body:\n" indent;
    Format.printf "%s====================\n"indent ;
    Format.printf "%s%a" indent Flambda.Expr.print expr;
    Format.printf "\n\n";
    compile (indent ^ "  ") expr
  | _ -> ()
;;
   *)

let compile program =
  let _hlambda = Un_cps.of_flambda_unit program in
  ()
;;

let command =
  Command.basic
    ~summary:"Systemcaml Compiler"
    [%map_open.Command
      let source_file = anon ("filename" %: string) in
      fun () ->
        let module Common = Ocaml_common in
        let module Optcomp = Ocaml_optcomp in
        let backend =
          let open Common in
          let open Optcomp in
          let cmx (i : Compile_common.info) = i.output_prefix ^ ".cmx" in
          let _cmx = cmx in
          let (|>>) (x, y) f = (x, f y) in
          let module Clflags = Ocaml_common.Clflags in
          let flambda2 (i : Compile_common.info) typed =
            if !Clflags.classic_inlining then begin
              Clflags.default_simplify_rounds := 1;
              Clflags.use_inlining_arguments_set Clflags.classic_arguments;
              Clflags.unbox_free_vars_of_closures := false;
              Clflags.unbox_specialised_args := false
            end;
            typed
            |> Profile.(record transl)
              (Translmod.transl_implementation_flambda i.module_name)
            |> Profile.(record generate)
              (fun {Lambda.module_ident; main_module_block_size;
                    required_globals = _; code; } ->
                ((module_ident, main_module_block_size), code)
                |>> Ocaml_common.Misc.print_if i.ppf_dump Clflags.dump_rawlambda Printlambda.lambda
                |>> Simplif.simplify_lambda
                |>> Ocaml_common.Misc.print_if i.ppf_dump Clflags.dump_lambda Printlambda.lambda
                |> (fun ((module_ident, main_module_block_size), code) ->
                    let translated_program =
                      Flambda2_middle_end.middle_end
                        ~backend:(module Asmgen.Flambda2_backend)
                        ~module_block_size_in_words:main_module_block_size
                        ~filename:i.source_file
                        ~prefixname:i.output_prefix
                        ~ppf_dump:i.ppf_dump
                        ~module_ident
                        ~module_initializer:code
                    in
                    (* Now, with [translated_program], go nuts. *)
                    compile translated_program))
          in
          flambda2
        in
        let output_prefix = Core.Filename.chop_extension source_file in
        Optcomp.Compilenv.reset source_file;
        Common.Compile_common.with_info
          ~native:true
          ~tool_name:"systemcaml"
          ~source_file
          ~output_prefix
          ~dump_ext:"cmx"
          (fun info ->
             Stdio.printf "source file = %s\n" info.source_file;
             Ocaml_common.Compile_common.implementation info ~backend
          )]
;;
