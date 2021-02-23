upload_to_connect <- function(path, NAME) {
  client <- connectapi::connect(
    host = Sys.getenv("CONNECT_SERVER"),
    api_key = Sys.getenv("CONNECT_API_KEY")
  )
  connectapi::deploy(client,
                     name = NAME,
                     bundle = connectapi::bundle_static(path)
  )
}
