plotActivityBars = function(tweets, plotly = FALSE){
  #' plotActivityBars
  #'
  #' Creates a barplot that shows the frequency of tweets per day.
  #' @param tweets A `tweets` dataframe.
  #' @param plotly Create interactive plot using plotly. Default is FALSE.
  #' @keywords activity
  #' @return A plot. 
  #' @examples
  #' plotActivityBars(tweets, plotly=TRUE)
  
  
  require(dplyr)
  require(ggplot2)
  
  by_day <- tweets %>% group_by(date) %>% summarise(tweets = n())
  
  activityPlot <- ggplot(by_day, aes(x = date, y = tweets)) +
    geom_bar(stat = "identity", fill = "#07b17d")
  
  if(plotly == TRUE){
    require(plotly)
    activityPlot <- ggplotly(activityPlot)
  }
  return(activityPlot)
}
 
