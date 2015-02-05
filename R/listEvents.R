#' Return listEvents data
#'
#' \code{listEvents} returns data corresponding to a specific event type.
#'
#' \code{listEvents} returns data corresponding to a specific event type, e.g.
#' Horse Racing, between two date and time stamps. Useful for finding specific
#' event identification numbers, which are then usually passed to further
#' functions. Additional returned data includes event name, event country code,
#' event timezone, event venue (only Horse Racing markets have venues), market
#' opening date and market count.
#'
#' @seealso \code{\link{loginBF}}, which must be executed first.
#'
#' @param eventTypeIds eventTypeIds String. Restrict markets by event type
#'   associated with the market. (i.e., Football, Horse Racing, etc). Accepts
#'   multiple IDs (See examples). IDs can be obtained via
#'   \code{\link{listEventTypes}}, Required. No default.
#' @param fromDate The start date from which to return matching events. Format
#'   is \%Y-\%m-\%dT\%TZ. Optional. If not defined defaults to current system
#'   date and time.
#' @param toDate The end date to stop returning matching events. Format is
#'   \%Y-\%m-\%dT\%TZ. Optional. If not defined defaults to current system
#'   date and time plus 24 hours.
#' @param sslVerify Boolean. This argument defaults to TRUE and is optional. In
#'   some cases, where users have a self signed SSL Certificate, for example
#'   they may be behind a proxy server, Betfair will fail login with "SSL
#'   certificate problem: self signed certificate in certificate chain". If this
#'   error occurs you may set sslVerify to FALSE. This does open a small
#'   security risk of a man-in-the-middle intercepting your login credentials.
#'
#' @return Response from Betfair is stored in listEvents variable, which is then
#'   parsed from JSON as a list. Only the first item of this list contains the
#'   required event type identification details.
#'
#' @section Note on \code{listEventsOps} variable: The \code{listEventsOps}
#'   variable is used to firstly build an R data frame containing all the data
#'   to be passed to Betfair, in order for the function to execute successfully.
#'   The data frame is then converted to JSON and included in the HTTP POST
#'   request.
#'
#' @examples
#' \dontrun{
#' # Return all Horse Racing events, between the current date & time and 11pm on December 10th, 2014
#' listEvents(eventTypeIds = 7,
#'            fromDate = format(Sys.time(), "%Y-%m-%dT%TZ"),
#'            toDate = "2014-12-15T23:00:00Z"
#'           )
#'
#' # Return all Horse Racing events, using the default from and to datestamps.
#' listEvents(eventTypeIds = 7)
#'
#' # Return all Horse Racing and Football events, using the default from and to datestamps.
#' listEvents(eventTypeIds = c("1","7"))
#' }
#'

listEvents <- function(eventTypeIds, fromDate = (format(Sys.time(), "%Y-%m-%dT%TZ")), toDate = (format(Sys.time() + 86400, "%Y-%m-%dT%TZ")), sslVerify = TRUE){

  options(stringsAsFactors=FALSE)
  listEventsOps <- data.frame(jsonrpc = "2.0", method = "SportsAPING/v1.0/listEvents", id = "1")

  listEventsOps$params <- data.frame(filter = c(""))
  listEventsOps$params$filter <- data.frame(eventTypeIds = c(""))
  listEventsOps$params$filter$eventTypeIds <- list(c(eventTypeIds))
  listEventsOps$params$filter$marketStartTime <- data.frame(from = fromDate, to = toDate)

  listEventsOps <- listEventsOps[c("jsonrpc", "method", "params", "id")]

  listEventsOps <- jsonlite::toJSON(listEventsOps, pretty = TRUE)

  listEvents <- as.list(jsonlite::fromJSON(RCurl::postForm("https://api.betfair.com/exchange/betting/json-rpc/v1", .opts=list(postfields=listEventsOps, httpheader=headersPostLogin, ssl.verifypeer = sslVerify))))

  as.data.frame(listEvents$result[1])

}

