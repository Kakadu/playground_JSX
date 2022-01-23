open Pcaml
open Format

EXTEND
  GLOBAL: expr ;
  expr: BEFORE "expr1"
    [ [ x = html_start -> x ] ] ;
  html_start:
    [ [ "<"; cname = component_name; end_of_attrs
         ->
        printf "Tag %s finished: %d\n%!" cname __LINE__;
        <:expr< "wtf" >> ]
    ];
  end_of_attrs:
    [ [ "></"; cname = component_name; ">" ->
      printf "Closing %s parsed: %d\n%!" cname __LINE__;
      () ]
    | [ ">"; body = OPT html_start; "</"; cname = component_name; ">" ->
        printf "Closing %s parsed: %d. body = %s\n%!" cname __LINE__
          (match body with None -> "None" | Some _ -> "Some");
        ()]
    ];

  component_name: [[ x = LIDENT ->
    Format.printf "name '%s' parsed\n%!" x;
    x
     ]];
END;
(*
EXTEND
  GLOBAL: expr ;
  expr: BEFORE "expr1"
    [ [ "sum";
        e =
        FOLD0 (fun e1 e2 -> <:expr< $e2$ + $e1$ >>) <:expr< 0 >>
          expr LEVEL "expr1" SEP ";";
        "end" -> e ]
    | [ "<"; cname = component_name;
        (* LIST0 myattr;  *)
        body = OPT expr; "</"; cname2 = component_name; ">" ->
        let head = match cname with
        | `Standart s -> <:expr< $lid:s$ >>
        | `Custom s -> <:expr< $uid:s$ . createComponent >>
        in
        let tail = <:expr< "wtf" >> in
        <:expr< $head$ $tail$ >> ]

    | [ "<"; cname = component_name;
        (* LIST0 myattr;  *)
        "/>" ->
        let head = match cname with
        | `Standart s -> <:expr< $lid:s$ >>
        | `Custom s -> <:expr< $uid:s$ . createComponent >>
        in
        let tail = <:expr< "wtf" >> in
        <:expr< $head$ $tail$ >> ]
    ];
  component_name:
    [ [ n = LIDENT  -> `Standart n ]
    | [ n = UIDENT  -> `Custom n ]
    ];
  myattr: [ [ LIDENT; "="; expr ]];
END;
 *)
