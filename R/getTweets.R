
getTweets <- function(collection_title, collection_id = NULL,start_date="",limit = 1000000,profile="vectR"){
  #' getTweets
  #'
  #' get all tweets for a collections
  #' @param collection_title Title of the collection
  #' @param collection_is Id of the collection. Default is NULL
  #' @param start_date Tweets created before this date "YYYY-MM-DD" are ignored. Default is ""
  #' @param limit max. number of tweets fetched
  #' @param profile Default is vectR
  #' @return A dataframe with following coloums
  #'
  #'  \code{id} id of the tweet
  #'
  #'  \code{screen_name} of the twitteruser
  #'
  #'  \code{name} of the twitteruser
  #'
  #'  \code{text} tweettext
  #'
  #'  \code{created_at} date in raw twitter api format
  #'
  #'  \code{created_at} date in Date() format
  #'
  #'  \code{hashtags} hastags, separated by ,
  #'
  #'  \code{user_mentions} screen_names of mentioned users, separated by ,
  #'
  #'  \code{retweet_screen_name} screenname of the retweeted user, if the tweet is a retweet.
  #'
  #'  Additional coloumns for annotated values
  #' @examples
  #' getTweets("testcollection")

  #create url for collections
  #collection_id = NULL
  #collection_title = "Listenkandidaten"
  limit <- format(limit, scientific = FALSE)
  chunk_size=limit

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
            "/api/1.0/tweets/",collection_id,"?limit=",toString(chunk_size),
            "&profile=",profile,
            "&start-date=",start_date,sep="")
  start_time <- Sys.time()
  response <- httr::GET(url,authenticate(vecter_connection[["token"]], ""))
  end_time <- Sys.time()
  time <- end_time - start_time

  #print(paste("fetched",toString(headers(response)[["content-length"]]),"in",toString(time)," Seconds",sep=" "))

  dataframe <- data.frame(id = character(),stringsAsFactors = FALSE)
  tweets <-list()
  for(field in names(collection[["schema"]])){
    type <- collection[["schema"]][[field]]
    if(type == "text" || type =="screen_name"){
      tweets[[field]] = character()
    }
    if(type == "numeric"){
      tweets[[field]] = numeric()
    }
    if(type == "boolean"){
      tweets[[field]] = logical()
    }
  }
  tweets[["text"]] = character()
  tweets[["created_at"]] = character()
  tweets[["date"]] = as.Date(character())
  tweets[["hashtags"]] = character()
  tweets[["retweet_screen_name"]]= character()
  tweets[["hashtags"]]= character()
  tweets[["user_mentions"]]= character()

  locale <- Sys.getlocale("LC_TIME")
  Sys.setlocale("LC_TIME", "C")
  if(httr::status_code(response) == 200){
    tweets_raw <-httr::content(response)[["rows"]]
    print(paste("fetched",toString(length(tweets_raw)) ,"tweets in",toString(time)," seconds, creating dataframe...",sep=" "))


    for(i in seq_along(tweets_raw)){
      item <- tweets_raw[[i]]
      tweets[["id"]][i] <-item[["id_str"]]
      for(field in names(collection[["schema"]])){
        type <- collection[["schema"]][[field]]
        if(type == "text" || type =="screen_name"){
          tweets[[field]][i] <- item[[field]]
        }
        if(type == "numeric"){
          tweets[[field]][i]  <- as.numeric(as.character(item[[field]]))
        }
        if(type == "boolean"){
          tweets[[field]][i]  <-as.logical(toupper(as.character(item[[field]])))
        }
      }

      tweets[["text"]][i] <- item[["text"]]
      tweets[["created_at"]][i] <- item[["created_at"]]
      tweets[["date"]][i] <- as.Date(as.POSIXct(strptime(item[["created_at"]], "%a %b %d %H:%M:%S %z %Y", tz = "GMT"),tz = "GMT"))

      hashtags_string <- ""
      for(hashtag in item[["hashtags"]]){

        if(hashtags_string == ""){
          hashtags_string <- hashtag[["text"]]
        }else{
          hashtags_string <- paste(hashtags_string,hashtag[["text"]],sep=",")
        }
      }
      tweets[["hashtags"]][i]  <- hashtags_string

      mentions_string <- ""
      for(mention in item[["user_mentions"]]){
        if(mentions_string == ""){
          mentions_string <- mention[["screen_name"]]
        }else{
          mentions_string <- paste(mentions_string,mention[["screen_name"]],sep=",")
        }
      }
      tweets[["user_mentions"]][i]  <- mentions_string


      if(is.null(item[["retweeted_status"]])){
        tweets[["retweet_screen_name"]][i] <- ""
      }else{
        tweets[["retweet_screen_name"]][i] <- item[["retweeted_status"]][["user"]][["screen_name"]]
      }
    }
    dataframe <- data.frame(id = tweets[["id"]])
    for(field in names(tweets)){
      dataframe[,field]  <- tweets[[field]]
    }

  }
  Sys.setlocale("LC_TIME", locale)

  return(dataframe)
}
