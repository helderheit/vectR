
getTweets <- function(collection_title, collection_id = NULL,chunk_size=100){
  #' getTweets
  #'
  #' get all tweets for a collections
  #' @param collection_title Title of the collection
  #' @param collection_is Id of the collection. Default is NULL

  #' @examples
  #' getTweets("testcollection")

  #create url for collections
  #collection_id = NULL
  #collection_title = "Listenkandidaten"
  #chunk_size=10

  collecions = getCollections()
  collection = NULL
  if(is.null(collection_id)){

    for(item in collecions){
      if(item[["title"]] == collection_title){
        if(is.null(collection_id)){
          collection_id <-item[["collection_id"]]
          collection <-  item
        }else{
          print(paste("Collection ",collection_title," not found.",sep=""))
          return()
        }
      }
    }
    if(is.null(collection_id)){
      print(paste("There is no collection with title: ",collection_title,sep=""))
      return()
    }
  }else{

  }
  # fetch tweets for collection
  #create url
  print(collection_id)

  url=paste(vecter_connection[["server"]],":",
            as.character(vecter_connection[["port"]]),
            "/api/1.0/tweets/",collection_id,"?limit=",as.character(chunk_size),sep="")

  response <- httr::GET(url,authenticate(vecter_connection[["token"]], ""),
                        verbose(data_out = TRUE, data_in = FALSE, info = FALSE, ssl = FALSE))
  #content(response)
  dataframe <- data.frame(id = rep(character(),chunk_size),stringsAsFactors = FALSE)
  for(field in names(collection[["schema"]])){
    type <- collection[["schema"]][[field]]
    if(type == "text" || type =="screen_name"){
      dataframe[,field] = character()
    }
    if(type == "numeric"){
      dataframe[,field] = numeric()
    }
    if(type == "boolean"){
      dataframe[,field] = logical()
    }
  }
  dataframe$text = character()
  dataframe$created_at = character()
  dataframe$date = as.Date(character())
  dataframe$hashtags = character()
  dataframe$retweet_screen_name= character()


  locale <- Sys.getlocale("LC_TIME")
  Sys.setlocale("LC_TIME", "C")
  if(status_code(response) == 200){
    tweets_raw <-content(response)[["rows"]]

    for(i in seq_along(tweets_raw)){
      item <- tweets_raw[[i]]
      tweet <-list()
      tweet[["id"]] <-item[["id_str"]]
      for(field in names(collection[["schema"]])){
        type <- collection[["schema"]][[field]]
        if(type == "text" || type =="screen_name"){
          tweet[[field]] <- item[[field]]
        }
        if(type == "numeric"){
          tweet[[field]]  <- as.numeric(as.character(item[[field]]))
        }
        if(type == "boolean"){
          tweet[[field]]  <-as.logical(toupper(as.character(item[[field]])))
        }
      }

      tweet[["text"]] <- item[["text"]]
      tweet[["created_at"]] <- item[["created_at"]]
      tweet[["date"]] <- as.Date(as.POSIXct(strptime(item[["created_at"]], "%a %b %d %H:%M:%S %z %Y", tz = "GMT"),tz = "GMT"))

      tweet[["hashtags"]]  <- as.character(toString(unlist(item[["entities"]][["hashtags"]])))
      if(is.null(item[["retweeted_status"]])){
        tweet[["retweet_screen_name"]] <- ""
      }else{
        tweet[["retweet_screen_name"]] <- item[["retweeted_status"]][["user"]][["screen_name"]]
      }

      dataframe[i,] <-tweet
    }
  }
  Sys.setlocale("LC_TIME", locale)

  return(dataframe)
}
