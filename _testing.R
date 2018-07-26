library(vectR)


SERVER = "http:///localhost"
USERNAME <- "admin"
PASSWORD <- "pass"
PORT <- 3000


source("_credentials.R")

VectR(SERVER,PORT,USERNAME,PASSWORD)


start_time <- Sys.time()
#tweets <- getTweets("Bundestagsmitglieder",start_date = "2017-01-01",end_date="2018-01-01",chunksize = 10, debug=TRUE)
tweets <- getTweets("Listenkandidaten", start_date="2018-07-20", chunksize = 10, debug = TRUE)
end_time <- Sys.time()
end_time - start_time
runtime_plot

library(devtools)
document()
?VectR()
?getTweets()

library(ggplot2)
process <- c("dataframe-creation","vector-creation","transmission","additional","conversion","db-query","preparation")
time <- c(1,2,3,4,5,6,7)
runtime <- data.frame(process, time,stringsAsFactors = FALSE)

runtime$process <-as.character(process)
runtime$process <- factor(runtime$process, levels=unique(runtime$process))

ggplot() + geom_bar(aes(y = time,x =1, fill = process), data = runtime,
                    stat="identity") +coord_flip() +theme(axis.title.y=element_blank(),
                                                          axis.text.y=element_blank(),
                                                          axis.ticks.y=element_blank())
runtime_plot
