#' Return listEventTypes data
#'
#' \code{listEventTypes} simply lists all available event types on the Betfair
#' exchange.
#'
#' Useful for finding the relevant event type identification number, which is
#' then usually passed to further functions.
#'
#' @seealso \code{\link{loginBF}}, which must be executed first.
#'
#' @param sslVerify Boolean. This argument defaults to TRUE and is optional. In
#'   some cases, where users have a self signed SSL Certificate, for example
#'   they may be behind a proxy server, Betfair will fail login with "SSL
#'   certificate problem: self signed certificate in certificate chain". If this
#'   error occurs you may set sslVerify to FALSE. This does open a small
#'   security risk of a man-in-the-middle intercepting your login credentials.
#'
#' @return Response from Betfair is stored in listEventTypes variable, which
#'   when parsed from JSON as a list. Only the first item of this list contains
#'   the required event type identification details.
#'
#' @section Note on \code{listEventTypeOps} variable: The
#'   \code{listEventTypeOps} variable is used to firstly build an R data frame
#'   containing all the data to be passed to Betfair, in order for the function
#'   to execute successfully. The data frame is then converted to JSON and
#'   included in the HTTP POST request.
#'
#' @examples
#' \dontrun{
#' listEventTypes()
#' }
#'

listEventTypes <- function(sslVerify = TRUE) {
  options(stringsAsFactors = FALSE)
  listEventTypesOps <-
    data.frame(jsonrpc = "2.0", method = "SportsAPING/v1.0/listEventTypes", id = "1")

  listEventTypesOps$params <- data.frame(filter = "")
  listEventTypesOps$params$filter <- data.frame(NA)

  listEventTypesOps <-
    listEventTypesOps[c("jsonrpc", "method", "params", "id")]

  listEventTypesOps <-
    jsonlite::toJSON(listEventTypesOps, pretty = TRUE)

  listEventsTypes <-
    as.list(jsonlite::fromJSON(
      RCurl::postForm(
        "https://api.betfair.com/exchange/betting/json-rpc/v1", .opts = list(
          postfields = listEventTypesOps, httpheader = headersPostLogin, ssl.verifypeer = sslVerify
        )
      )
    ))

  as.data.frame(listEventsTypes$result[1])

}
