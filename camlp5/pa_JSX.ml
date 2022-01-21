open Pcaml

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
