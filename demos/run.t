
  $ camlp5o ../camlp5/pa_JSX.cma pr_o.cmo demo1.ml
  [@@@ocamlformat "disable"]
  
  (* let%test "something" = true *)
  (* let%test "something" =  4 = (let x = 1 in sum x ; x ; 2 end);; *)
  
  let div _ = ()
  module MyComponent = struct let createComponent _ = () end
  
  (* let _ = <MyComponent foo={bar} /> *)
  let _ = div []
  let _ = div []
  (* let _ = <div class_="class1"> <img src=""/> </div> *)
