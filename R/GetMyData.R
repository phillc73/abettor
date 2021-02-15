#' GetMyData function from Historic API
#'
#' The GetMyData function returns a data frame of all Betfair historic data
#' available to download for the logged in user. The user must first 'purchase'
#' such historic data from Betfair. The Basic Plan offers many options at no
#' cost.
#'
#' @seealso
#'   \url{https://historicdata.betfair.com/#/home}
#'
#' @seealso
#'   \url{https://historicdata.betfair.com/#/apidocs}
#'
#' @seealso \code{\link{loginBF}}, which must be executed first, as this
#'   function requires a valid session token.
#'
#' @param sslVerify Boolean. This argument defaults to TRUE and is optional. In
#'   some cases, where users have a self signed SSL Certificate, for example
#'   they may be behind a proxy server, Betfair will fail login with "SSL
#'   certificate problem: self signed certificate in certificate chain". If this
#'   error occurs you may set sslVerify to FALSE. This does open a small
#'   security risk of a man-in-the-middle intercepting your login credentials.
#'
#' @return Response from Betfair will be stored in a four column dataframe.
#'
#' @examples
#'   \dontrun{
#'   # Retrieve a list of all Betfair historic data available to download
#'   # for the logged in user.
#'
#'   GetMyData()
#'  }

GetMyData <- function(sslVerify = TRUE) {

  # Read Environment variables for authorisation details
  token <- Sys.getenv("token")

  details <- httr::content(
    httr::POST(url = "https://historicdata.betfair.com/api/GetMyData",
                 config = httr::config(ssl_verifypeer = sslVerify),
                 httr::add_headers(ssoid = token,
                                   Accept = "application/json",
                                   as = "text",
                                   encoding = "UTF-8")
              )
        )

  if(is.null(details$doc))
    as.data.frame(do.call(rbind, details))
  else({
      warning("Error- Something went wrong.
      Unable to return data.
      Check session token.")
      })

}
