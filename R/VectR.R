VectR <- function(server,port=443,username=NULL, password=NULL){
  #' VectR
  #'
  #' Create a connection to an Vecter server
  #' @param server Server address
  #' @param port Server port. Default is 443 (https)
  #' @param username Username. Default is NULL
  #' @param passowrd Password Default is NULL
  #' @keywords connection
  #' @examples
  #' VectR("https://vecter.org")

  library(httr)

  if(is.null(username) || is.null(password)){
    print("Authentification required!")
  }
  if(is.null(username)){
    username <- readline(prompt="Username:")
  }
  if(is.null(password)){

    if (rstudioapi::hasFun("askForPassword")) {
      password <- rstudioapi::askForPassword()
    } else {
      password <- readline(prompt="Password:")
    }

  }

  #create url for token
  url=paste(server,":",as.character(port),"/api/1.0/token",sep="")

  #get access token from server
  token_response <- httr::GET(url,authenticate(username, password))

  if(httr::status_code(token_response)==200){
    token <-httr::content(token_response)[["token"]]
    vecter_connection <- list()
    vecter_connection[["server"]] <- server
    vecter_connection[["port"]] <- port
    vecter_connection[["token"]] <- token
    vecter_connection[["username"]] <- username

    vecter_connection<<- vecter_connection
    print("Connected")
  }else{
    print("Error",str(httr::status_code(token_response)))
  }
}
