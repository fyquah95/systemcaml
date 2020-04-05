(lang dune 2.4)
(name ocaml-fpga-hls)
(version 0.0.0)
(formatting (enabled_for ocaml))

(generate_opam_files true)

(package
 (name ocaml-fpga-hls)
 (depends
  (ocaml (= 4.10.0))
  (base (= v0.14-preview.122.15+227))
  (core (= v0.14-preview.122.15+227))
  (hardcaml (= v0.14-preview.122.15+227))))
