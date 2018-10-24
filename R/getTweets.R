
getTweets <- function(collection_title, collection_id = NULL,start_date="",end_date="",chunksize=10,profile="vectR", debug=FALSE){
  #' getTweets
  #'
  #' Get all tweets for a collection.
  #' @param collection_title Title of the collection
  #' @param collection_is Id of the collection. Default is NULL
  #' @param start_date Tweets created before this date "YYYY-MM-DD" are ignored. Default is ""
  #' @param end_date Tweets created after this date "YYYY-MM-DD" are ignored. Default is ""
  #' @param limit max. number of tweets fetched
  #' @param profile Default is vectR
  #' @return A dataframe with following coloums
  #'
  #'  `id` id of the tweet
  #'
  #'  `screen_name` of the twitteruser
  #'
  #'  `name` of the twitteruser
  #'
  #'  `text` tweettext
  #'
  #'  `created_at` date in raw twitter api format
  #'
  #'  `created_at` date in Date() format
  #'
  #'  `hashtags` hastags, separated by ,
  #'
  #'  `user_mentions` screen_names of mentioned users, separated by ,
  #'
  #'  `retweet_screen_name` screenname of the retweeted user, if the tweet is a retweet.
  #'
  #'  Additional coloumns for annotated values
  #' @examples
  #' getTweets("testcollection")

  #collection_id = NULL
  #collection_title = "Bundestagsmitglieder"
  #chunksize=10
  #start_date = "2017-01-01"
  #end_date = "2018-01-01"


  profile = "vectR"

  preparation_start = Sys.time()
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
 #

  dataframe <- NULL

  query_time = 0
  conversion_time = 0
  execution_time = 0

  preperation_time = Sys.time() - preparation_start
  fetch_time = 0
  vector_time = 0
  dataframe_time = 0

  chunks = ceiling(collection[["number_of_accounts"]]/chunksize)
  for(chunk in 0:chunks){

    url=paste(vecter_connection[["server"]],":",
              as.character(vecter_connection[["port"]]),
              "/api/1.0/tweets/",collection_id,"?limit=",toString(chunksize),
              "&skip=",toString(chunksize*chunk),
              "&profile=",profile,
              "&format=vectorized",
              "&start-date=",start_date,
              "&end-date=",end_date,sep="")
    fetch_start <- Sys.time()
    response <- httr::GET(url,authenticate(vecter_connection[["token"]], ""))
    fetch_time <- fetch_time +(Sys.time()-fetch_start)

    #print(paste("fetched",toString(headers(response)[["content-length"]]),"in",toString(time)," Seconds",sep=" "))

    chunk_dataframe <- data.frame(id = character(),stringsAsFactors = FALSE)
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
      query_time = query_time + httr::content(response)[["meta"]][["query_time"]]
      conversion_time = conversion_time + httr::content(response)[["meta"]][["conversion_time"]]
      execution_time = execution_time + httr::content(response)[["meta"]][["execution_time"]]

      vector_start <- Sys.time()
      tweets_raw <-httr::content(response)[["rows"]]
      #print(paste("fetched",toString(length(tweets_raw)) ,"tweets in",toString(time)," seconds, creating dataframe...",sep=" "))

      tweets[["id"]] <- unlist(tweets_raw[["id_str"]],use.names=FALSE)
      tweets[["text"]] <- unlist(tweets_raw[["text"]],use.names=FALSE)
      tweets[["created_at"]] <- unlist(tweets_raw[["created_at"]],use.names=FALSE)
      tweets[["retweet_screen_name"]] <- unlist(tweets_raw[["retweeted_status"]][["user"]][["screen_name"]],use.names=FALSE)

      tweets[["date"]] <-as.Date(as.POSIXct(strptime(unlist(tweets_raw[["created_at"]],use.names=FALSE), "%a %b %d %H:%M:%S %z %Y", tz = "GMT"),tz = "GMT"))

      parseHashtags <- function(hashtags){

        hashtags_string <- ""
        for(hashtag in hashtags){
          if(hashtags_string == ""){
            hashtags_string <- hashtag[["text"]]
          }else{
            hashtags_string <- paste(hashtags_string,hashtag[["text"]],sep=",")
          }
        }
        return(hashtags_string)

      }
      tweets[["hashtags"]] <- unlist(lapply(tweets_raw[["hashtags"]], parseHashtags),use.names = FALSE, recursive=FALSE)
      parseUserMentions <- function(user_mentions){
        mentions_string <- ""
        for(mention in user_mentions){
          if(mentions_string == ""){
            mentions_string <- mention[["screen_name"]]
          }else{
            mentions_string <- paste(mentions_string,mention[["screen_name"]],sep=",")
          }
        }
        return(mentions_string)
      }
      tweets[["user_mentions"]] <- unlist(lapply(tweets_raw[["user_mentions"]], parseUserMentions),use.names = FALSE,recursive=FALSE)


      for(field in names(collection[["schema"]])){
        type <- collection[["schema"]][[field]]
        if(type == "text" || type =="screen_name"){
          tweets[[field]] <- unlist(tweets_raw[["annotations"]][[field]],use.names=FALSE)
        }
        if(type == "numeric"){
          tweets[[field]]  <- as.numeric(as.character(unlist(tweets_raw[["annotations"]][[field]],use.names=FALSE)))
        }
        if(type == "boolean"){
          tweets[[field]]  <-as.logical(toupper(as.character(unlist(tweets_raw[["annotations"]][[field]],use.names=FALSE))))
        }
      }

      vector_time <- vector_time + (Sys.time() - vector_start)
      dataframe_start <- Sys.time()
      chunk_dataframe <- data.frame(id = tweets[["id"]])
      for(field in names(tweets)){
        chunk_dataframe[,field]  <- tweets[[field]]
      }
      if(is.null(dataframe)){
        dataframe <- chunk_dataframe
      }else{
        dataframe <- rbind(dataframe, chunk_dataframe)
      }
      dataframe_time <- dataframe_time + (Sys.time() - dataframe_start)


    }
    progress = paste(paste(replicate(floor(40*(chunk/chunks)),"="),collapse="",sep=""),">",sep="")
    pending = paste(replicate(floor(40 -40*(chunk/chunks))," "),collapse="")
    cat("\r getting Tweets ","[",progress,pending,"] chunk ",as.character(chunk)," of ",as.character(chunks)," (",toString(nrow(dataframe))," tweets)","          ",sep="")
    flush.console()
  }

  Sys.setlocale("LC_TIME", locale)
  print("")

  if(debug){
    print(paste("preparation:",toString(preperation_time)))
    print(paste("fetch:",toString(fetch_time)))
    print(paste("    transmission:",toString(fetch_time-execution_time)))
    print(paste("vector-creation:",toString(vector_time)))
    print(paste("dataframe-creation:",toString(dataframe_time)))

    print("Server")
    print(paste("    query:",toString(query_time)))
    print(paste("    conversion:",toString(conversion_time)))
    print(paste("    additional:",toString(execution_time-conversion_time-query_time)))
    process <- c("dataframe-creation","vector-creation","transmission","additional","conversion","db-query","preparation")
    time <- c(dataframe_time,vector_time,fetch_time-execution_time,execution_time-conversion_time-query_time, conversion_time,query_time,preperation_time)
    runtime <- data.frame(process, time,stringsAsFactors = FALSE)
    runtime$process <-as.character(process)
    runtime$process <- factor(runtime$process, levels=unique(runtime$process))
    runtime_plot <<- ggplot() + geom_bar(aes(y = time,x =1, fill = process), data = runtime,
                        stat="identity") +coord_flip() +theme(axis.title.y=element_blank(),
                                                              axis.text.y=element_blank(),
                                                              axis.ticks.y=element_blank())

  }

  return(dataframe)
}
