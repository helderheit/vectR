getCollections <- function(){
  #' getCollections
  #'
  #' get all collections for an user
  #' @examples
  #' getCollections()
  #create url for collections
  url=paste(vecter_connection[["server"]],":",
            as.character(vecter_connection[["port"]]),
            "/api/1.0/collections",sep="")
  response <- httr::GET(url,authenticate(vecter_connection[["token"]], ""))
  if(httr::status_code(response) == 200){
    return(httr::content(response))
  }
}
