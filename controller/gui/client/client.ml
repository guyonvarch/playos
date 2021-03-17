open Js_of_ocaml
module H = Dom_html

let document = H.window##.document
let pathname = H.window##.location##.pathname

let by_id id =
  Js.Opt.get
    (document##getElementById (Js.string id))
    (fun () -> raise Not_found)

let by_id_coerce s f =
  Js.Opt.get (f (Dom_html.getElementById s)) (fun () -> raise Not_found)

let () =
  if pathname##substring 0 9 = Js.string "/network/" then
    let passphrase = Js.Unsafe.coerce (by_id "d-Passphrase") in
    let checkbox = by_id_coerce "d-Checkbox" H.CoerceTo.input in
    checkbox##.onclick := H.handler (fun evt ->
      if checkbox##.checked = Js._true then
        passphrase##._type := Js.string "text"
      else
        passphrase##._type := Js.string "password";
      Js._true)
