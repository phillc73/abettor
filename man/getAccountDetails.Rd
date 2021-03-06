% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getAccountDetails.R
\name{getAccountDetails}
\alias{getAccountDetails}
\title{Checks account details on Betfair.}
\usage{
getAccountDetails(suppress = FALSE, sslVerify = TRUE)
}
\arguments{
\item{suppress}{Boolean. By default, this parameter is set to FALSE, meaning
that a warning is posted when the getAccountDetails call throws an error. Changing
this parameter to TRUE will suppress this warning.}

\item{sslVerify}{Boolean. This argument defaults to TRUE and is optional. In
some cases, where users have a self signed SSL Certificate, for example
they may be behind a proxy server, Betfair will fail login with "SSL
certificate problem: self signed certificate in certificate chain". If this
error occurs you may set sslVerify to FALSE. This does open a small
security risk of a man-in-the-middle intercepting your login credentials.}
}
\value{
Response from Betfair is stored in AccountDetailsResponse variable,
  which is then parsed from JSON as a data frame of 1 row and 9 columns.
}
\description{
\code{getAccountDetails} allows you to see your Betfair account details.
Unlike other Betfair API calls, there are no betting dangers associated
with this function, it simply returns account information such as balance,
exposure, etc.
}
\section{Note on \code{detailsOps} variable}{
 The \code{detailsOps} variable
  is used to firstly build an R data frame containing all the data to be
  passed to Betfair, in order for the function to execute successfully. The
  data frame is then converted to JSON and included in the HTTP POST request.
  If the getAccountDetails call throws an error, a data frame containing error
  information is returned.
}

\examples{
\dontrun{
getAccountDetails() # without any arguments will return details as a data frame
# e.g. getAccountDetails()$pointsBalance gives your points balance.

}

}
\seealso{
\url{https://docs.developer.betfair.com/display/1smk3cen4v3lu3yomq5qye0ni/getAccountDetails}
for general information on calling getAccountDetails via the Betfair API.

\code{\link{loginBF}}, which must be executed first, as this
  function requires a valid session token
}
