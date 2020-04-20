type t =
  | Deleted (** The function was deleted from the flambda IR in the first
                place.  *)
  | Unsynthesizable (** The function is not synthesizable in hardware. This
                        refers to function with high order functions. *)
  | Synthesizable
