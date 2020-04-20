(*

type t =
  | Declare_component of
      { component_id : Component_id.t
      ; inputs : Signal_id.t 
      ; latency : latency
      }
  | Instantiate_component 
      { component ; Component_id.t
      ; input_assignments : t Map.M(Signal_id).t
      }
  | Let of
      { name : Var_id.t
      ; value : let_expression
      ; body : t
      }

and input_specification =
  { bit_width : int
  }

and let_value =
  | Input of input
  | Output of output
  | Value of let_expression

and input =
  { name : string
  ; bit_width : int
  }
and output =
  { name : string
  ; bit_width : int
  }

and op =
  { op : op
  ; arguments : Var_id.t list
  }

   *)
