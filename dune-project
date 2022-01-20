(lang dune 2.7)

(cram enable)

(generate_opam_files true)

(name pa_JSX)

(package
 (version 0.1.0)
 (name pa_JSX)
 (depends
  (ocaml
   (>= 4.12.1))
  ppxlib
  (ppx_inline_test :with-test)
  camlp5))
