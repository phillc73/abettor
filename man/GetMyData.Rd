% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/GetMyData.R
\name{GetMyData}
\alias{GetMyData}
\title{GetMyData function from Historic API}
\usage{
GetMyData(sslVerify = TRUE)
}
\arguments{
\item{sslVerify}{Boolean. This argument defaults to TRUE and is optional. In
some cases, where users have a self signed SSL Certificate, for example
they may be behind a proxy server, Betfair will fail login with "SSL
certificate problem: self signed certificate in certificate chain". If this
error occurs you may set sslVerify to FALSE. This does open a small
security risk of a man-in-the-middle intercepting your login credentials.}
}
\value{
Response from Betfair will be stored in a four column dataframe.
}
\description{
The GetMyData function returns a data frame of all Betfair historic data
available to download for the logged in user. The user must first 'purchase'
such historic data from Betfair. The Basic Plan offers many options at no
cost.
}
\examples{
  \dontrun{
  # Retrieve a list of all Betfair historic data available to download
  # for the logged in user.

  GetMyData()
 }
}
\seealso{
\url{https://historicdata.betfair.com/#/home}

\url{https://historicdata.betfair.com/#/apidocs}

\code{\link{loginBF}}, which must be executed first, as this
  function requires a valid session token.
}
