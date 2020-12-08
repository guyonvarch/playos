type credentials =
  { user: string
  ; password: string
  }

type t =
  { credentials: credentials option
  ; host: string
  ; port: int
  }

let validate str =
  let regexp = Str.regexp "^http://\\(\\([^:]+\\):\\([^@]+\\)@\\)?\\([^\\:]+\\):\\([0-9]+\\)$" in
  if Str.string_match regexp str 0 then
    let port =
      try
        Some (int_of_string (Str.matched_group 5 str))
      with
      | Failure _ -> None
    in
    port |> Option.map (fun p ->
      { credentials =
        (try
          Some
            { user = Str.matched_group 2 str
            ; password = Str.matched_group 3 str
            }
        with
        | Not_found -> None)
      ; host = Str.matched_group 4 str
      ; port = p
      })
  else
    None;;

let to_string ?(blur_password = false) t =
  [ "http://"
  ; (match t.credentials with
    | Some credentials ->
        [ credentials.user
        ; ":"
        ; if blur_password then "******" else credentials.password
        ; "@"
        ]
        |> String.concat ""
    | None -> "")
  ; t.host
  ; ":"
  ; string_of_int t.port
  ]
  |> String.concat ""
