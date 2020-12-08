type credentials =
  { user: string
  ; password: string
  }

type t =
  { credentials: credentials option
  ; host: string
  ; port: int
  }

val validate : string -> t option

val to_string : ?blur_password:bool -> t -> string
