# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'

VectR <- function(server,port=443,username=NULL, password=NULL){
  #' VectR
  #'
  #' Created a connection to an Vecter server
  #' @param server Server address
  #' @param port Server port. Default is 443 (https)
  #' @param username Username. Default is NULL
  #' @param passowrd Password Default is NULL
  #' @keywords connection
  #' @export vecter_connection
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

  #TODO remove next line if certiface is valid
  httr::set_config(config(ssl_verifypeer = 0L))

  #get access token from server
  token_response <- httr::GET(url,authenticate(username, password))

  if(status_code(token_response)==200){
    token <-content(token_response)[["token"]]
    vecter_connection <- list()
    vecter_connection[["server"]] <- server
    vecter_connection[["port"]] <- port
    vecter_connection[["token"]] <- token
    vecter_connection[["username"]] <- username

    vecter_connection<<- vecter_connection
    print("Connected")
  }else{
    print("Error",str(status_code(token_response)))
  }
}
