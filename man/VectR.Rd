% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/VectR.R
\name{VectR}
\alias{VectR}
\title{VectR}
\usage{
VectR(server, port = 443, username = NULL, password = NULL)
}
\arguments{
\item{server}{Server address}

\item{port}{Server port. Default is 443 (https)}

\item{username}{Username. Default is NULL}

\item{passowrd}{Password Default is NULL}
}
\description{
Create a connection to an Vecter server
}
\examples{
VectR("https://vecter.org")
}
\keyword{connection}
