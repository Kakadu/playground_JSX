open Pcaml
open Format



let check_tag_without_body =
  let is_ending_tag_f strm =
    Stream.npeek 1 strm = [("","></")] ||
    match Stream.npeek 2 strm with
      | [("", ">"); ("", "</")] -> true
      | xs ->
        let open Format in
        (* Format.printf "is_ending_tag_f says false: %a\n%!"
          (pp_print_list (fun ppf (a,b) -> fprintf ppf "(%S,%S)" a b ) ~pp_sep:pp_print_space)
          xs; *)
        false
  in
  Grammar.Entry.of_parser gram "check_closes_no_body"
    (fun strm -> if is_ending_tag_f strm then () else raise Stream.Failure)


EXTEND
  GLOBAL: expr ;
  expr: BEFORE "expr1"
    [ [ x = html -> x ] ] ;
  html:
    [ [ "<"; cname = component_name; attrs = attrs; rhs =
        [ [ check_tag_without_body; [ "></" | ">"; "</"] ; cname2 = component_name; ">" ->
              Some cname2, [] ]
        | [ ">"; body = LIST0 html; "</"; cname2 = component_name; ">" ->
              Some cname2, body ]
        | [ "/>"  -> None, [] ]
        ]
         ->
          let cname2, body = rhs in
          let () = match cname2 with
          | None -> ()
          | Some cname2 when cname2 <> cname -> raise Stream.Failure
          | Some _ -> ()
          in
          let head = match cname with
          | `Standard s -> <:expr< $lid:s$ >>
          | `Custom s -> <:expr< $uid:s$ . createComponent >>
          in
          let args = List.fold_left (fun acc x -> <:expr< [ $x$ :: $acc$ ] >>) <:expr< [] >> body in
          <:expr< $head$ $args$ >>
      ]
    ];
  component_name:
    [ [ x = LIDENT ->
        (* Format.printf "name '%s' parsed\n%!" x; *)
        `Standard x
      ]
    | [ x = UIDENT -> `Custom x ]
    ];
    myattr:
      [ [ name = LIDENT; "="; "{"; v = expr; "}" -> (name, v) ]
      (* | [ name = LIDENT; "="; v = expr  -> (name, v) ] *)
      ];
    attrs: [ [ LIST0 myattr ] ];
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
