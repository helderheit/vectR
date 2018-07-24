library(vectR)


SERVER = "http:///localhost"
USERNAME <- "admin"
PASSWORD <- "pass"
PORT <- 3000


source("_credentials.R")

VectR(SERVER,PORT,USERNAME,PASSWORD)


start_time <- Sys.time()
tweets <- getTweets("Bundestagsmitglieder",start_date = "2017-01-01",chunksize = 10)
#tweets <- getTweets("test",start_date = "2017-01-01", limit = 200)
end_time <- Sys.time()
end_time - start_time

library(devtools)
document()
?VectR()
?getTweets()
