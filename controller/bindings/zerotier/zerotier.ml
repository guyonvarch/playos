open Lwt

let base_url =
  Uri.make
    ~scheme:"http"
    ~host:"localhost"
    ~port:9993
    ()

let get_authtoken () =
  let%lwt ic =
    Lwt_io.(open_file ~mode:Lwt_io.Input)
      "/var/lib/zerotier-one/authtoken.secret"
  in
  let%lwt authtoken = Lwt_io.read ic in
  let%lwt () = Lwt_io.close ic in
  return (String.trim authtoken)

type status = {
  address: string
}

let get_status ~proxy =
  (let%lwt authtoken = get_authtoken () in
  match%lwt
    Curl.request
      ?proxy
      ~headers:[("X-ZT1-Auth", authtoken)]
      (Uri.with_path base_url "status")
  with
  | RequestSuccess (_, body) ->
      let open Ezjsonm in
      from_string body
      |> get_dict
      |> List.assoc "address"
      |> get_string
      |> fun address -> return {address}
  | RequestFailure error ->
      Lwt.fail_with (Printf.sprintf "could not get zerotier status (%s)" (Curl.pretty_print_error error)))
  |> Lwt_result.catch
