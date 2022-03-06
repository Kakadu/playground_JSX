$ cat <<EOF > test1.ml
> let x = 1 in sum x ; x ; 2 end;;
> EOF
$ camlp5o ./pa_JSX.cma pr_o.cmo test1.ml
let _ = let x = 1 in 2 + (x + (x + 0))

$ ./pp5+pa_JSX+o.exe test1.ml
let _ = let x = 1 in 2 + (x + (x + 0))

  $ cat <<EOF > html1.ml
  > <div> <a href={""} > <b/> </a> </div>;;
  > <div> <a> <b></b> </a> </div>;;
  > <div> <a> <b> </b> <b/> </a> </div>;;
  > (* <a><img/> </a>  (* bug *) *)
  > EOF
$ CAMLP5PARAM='b t' camlp5o ./pa_JSX.cma pr_o.cmo html1.ml
  $ camlp5o ./pa_JSX.cma pr_o.cmo html1.ml
  let _ = div [a [b []]]
  let _ = div [a [b []]]
  let _ = div [a [b []; b []]]
  (* <a><img/> </a>  (* bug *) *)
