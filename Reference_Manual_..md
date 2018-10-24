

<!-- toc -->

Oktober 24, 2018

# DESCRIPTION

```
Package: vectR
Type: Package
Title: Accessing Vecter API
Version: 0.2.2
Author: Felix Albrecht
Maintainer: Felix Albrecht <info@vecter.org>
Description: Accessing the Vecter API.
License: What license is it under?
Encoding: UTF-8
LazyData: true
RoxygenNote: 6.1.0```


# `getCollections`: getCollections

## Description


 get all collections for an user


## Usage

```r
getCollections()
```


## Examples

```r 
 getCollections()
 ``` 

# `getTweets`: getTweets

## Description


 Get all tweets for a collection.


## Usage

```r
getTweets(collection_title, collection_id = NULL, start_date = "",
  end_date = "", chunksize = 10, profile = "vectR", debug = FALSE)
```


## Arguments

Argument      |Description
------------- |----------------
```collection_title```     |     Title of the collection
```start_date```     |     Tweets created before this date "YYYY-MM-DD" are ignored. Default is ""
```end_date```     |     Tweets created after this date "YYYY-MM-DD" are ignored. Default is ""
```profile```     |     Default is vectR
```collection_is```     |     Id of the collection. Default is NULL
```limit```     |     max. number of tweets fetched

## Value


 A dataframe with following coloums
 
 `id` id of the tweet
 
 `screen_name` of the twitteruser
 
 `name` of the twitteruser
 
 `text` tweettext
 
 `created_at` date in raw twitter api format
 
 `created_at` date in Date() format
 
 `hashtags` hastags, separated by ,
 
 `user_mentions` screen_names of mentioned users, separated by ,
 
 `retweet_screen_name` screenname of the retweeted user, if the tweet is a retweet.
 
 Additional coloumns for annotated values


## Examples

```r 
 getTweets("testcollection")
 ``` 

# `plotActivityBars`: plotActivityBars

## Description


 Creates a barplot that shows the frequency of tweets per day.


## Usage

```r
plotActivityBars(tweets, plotly = FALSE)
```


## Arguments

Argument      |Description
------------- |----------------
```tweets```     |     A `tweets` dataframe.
```plotly```     |     Create interactive plot using plotly. Default is FALSE.

## Value


 A plot.


## Examples

```r 
 plotActivityBars(tweets, plotly=TRUE)
 ``` 

# `plotActivitySmooth`: plotActivitySmooth
 Creates a smooth lineplot that shows the frequency of tweets per day.

## Description


 plotActivitySmooth
 Creates a smooth lineplot that shows the frequency of tweets per day.


## Usage

```r
plotActivitySmooth(tweets, span = 0.1, plotly = FALSE)
```


## Arguments

Argument      |Description
------------- |----------------
```tweets```     |     A `tweets` dataframe.
```span```     |     Defines the smoothness of the plot. Default is 0.1.
```plotly```     |     Create interactive plot using plotly. Default is FALSE.

## Value


 A plot.


## Examples

```r 
 plotActivitySmooth(tweets, span = 0.2, plotly=TRUE)
 ``` 

# `VectR`: VectR

## Description


 Create a connection to an Vecter server


## Usage

```r
VectR(server, port = 443, username = NULL, password = NULL)
```


## Arguments

Argument      |Description
------------- |----------------
```server```     |     Server address
```port```     |     Server port. Default is 443 (https)
```username```     |     Username. Default is NULL
```passowrd```     |     Password Default is NULL

## Examples

```r 
 VectR("https://vecter.org")
 ``` 

