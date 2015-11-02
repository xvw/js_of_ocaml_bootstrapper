open BootPervasives


let load file =
  let open XmlHttpRequest in
  get file >>= (fun frame ->
      let code = frame.code
      and message = frame.content in 
      if code = 0 || code = 200
      then Lwt.return (Some message)
      else Lwt.return None
    ) 
    
