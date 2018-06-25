library(vectR)

source("_credentials.R")
VectR(SERVER,PORT,USERNAME,PASSWORD)
#VectR("httP://localhost",3000,"admin","pass")

start_time <- Sys.time()
tweets <- getTweets("Listenkandidaten", start_date = "2018-01-01")
#tweets <- getTweets("test",start_date = "2017-01-01", limit = 200)
end_time <- Sys.time()
end_time - start_time

library(devtools)
document()
?VectR()
?getTweets()
