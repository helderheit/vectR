library(vectR)

source("_credentials.R")
httr::set_config(config(ssl_verifypeer = 0L, ssl_verifyhost = 0L))
VectR(SERVER,PORT,USERNAME,PASSWORD)

start_time <- Sys.time()
tweets <- getTweets("Listenkandidaten",chunk_size=90000)
end_time <- Sys.time()

end_time - start_time
