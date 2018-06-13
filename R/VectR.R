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

VectR <- function(server,port=80,username=NULL, password=NULL){
  #' Electric
  #'
  #' Created a connection to an Electric-Dataland server
  #' @param server Server address
  #' @param port Server port. Default is 80
  #' @param username Username. Default is NULL
  #' @param passowrd Password Default is NULL
  #' @keywords connection
  #' @export
  #' @examples
  #' Electric("https://electric-dataland.org",3000)

  library(httr)

  if(is.null(username) || is.null(password)){
    print("Authentification required!")
  }
  if(is.null(username)){
    username <- readline(prompt="Username:")
  }
  if(is.null(password)){
    password <- readline(prompt="Password:")
  }

  #create url for token
  url=paste(server,":",as.character(port),"/api/1.0/token",sep="")

  #TODO remove next line if certiface is valid
  httr::set_config(config(ssl_verifypeer = 0L))

  #get access token from server
  token_response <- httr::GET(url,authenticate(username, password))

  if(status_code(token_response)==200){
    token <-content(token_response)[["token"]]
    electric_dataland_connection <- list()
    electric_dataland_connection[["server"]] <- server
    electric_dataland_connection[["port"]] <- port
    electric_dataland_connection[["token"]] <- token
    electric_dataland_connection[["username"]] <- username

    electric_dataland_connection<<- electric_dataland_connection
    print("Connected")
  }else{
    print("Error",as.character(status_code(token_response)))
  }
}
