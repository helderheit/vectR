plotActivitySmooth = function(tweets,span = 0.1,plotly  = FALSE){
  #' plotActivitySmooth
  #' Creates a smooth lineplot that shows the frequency of tweets per day.
  #' @param tweets A `tweets` dataframe.
  #' @param span Defines the smoothness of the plot. Default is 0.1.
  #' @param plotly Create interactive plot using plotly. Default is FALSE.
  #' @keywords activity
  #' @return A plot.
  #' @examples
  #' plotActivitySmooth(tweets, span = 0.2, plotly=TRUE)


  require(dplyr)
  require(ggplot2)

  by_day <- tweets %>% group_by(date) %>% summarise(tweets = n())

  activityPlot <- ggplot(by_day, aes(x = date, y = tweets)) +
    geom_smooth(size=1.0,span=span,color = "#07b17d")

  if(plotly == TRUE){
    require(plotly)
    activityPlot <- ggplotly(activityPlot)
  }
  return(activityPlot)
}
