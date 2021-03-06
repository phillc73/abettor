#' Returns status details for horse and greyhound races
#'
#' \code{listRaceDetails}returns status details for horse and greyhound races
#'
#' \code{listRaceDetails} returns status details for horse and greyhound
#' races in the UK, Ireland and South Africa, based upon meeting and race
#' filters. Unlike some other Betfair API calls, there are no dangers
#' associated with this function, it simply returns status details.
#'
#' @seealso
#' \url{https://docs.developer.betfair.com/display/1smk3cen4v3lu3yomq5qye0ni/Race+Status+API}
#'    this page lists error messages and status enums associated with
#'    this Betfair API call
#'
#' @seealso \code{\link{loginBF}}, which must be executed first, as this
#'   function requires a valid session token
#'
#' @param meetingIds String. The unique Id for the meeting equivalent to the
#'   eventId for that specific race as returned by  \code{\link{listEvents}}.
#'   Optionally restricts the results to the specified meeting IDs. A single
#'   meeting ID or list of meeting IDs may be specified. See examples.
#'   Optional. Default is NULL
#'
#' @param raceIds String. The unique Id for the race in the format
#'   meetingid.raceTime (hhmm). Optionally restricts the results to the
#'   specified race IDs. A single race ID or list of race IDs may be specified.
#'   See examples. Optional. Default is NULL
#'
#' @param suppress Boolean. By default, this parameter is set to FALSE, meaning
#'   that a warning is posted when the listRaceDetails call throws an error.
#'   Changing this parameter to TRUE will suppress this warning.
#'
#' @param sslVerify Boolean. This argument defaults to TRUE and is optional. In
#'   some cases, where users have a self signed SSL Certificate, for example
#'   they may be behind a proxy server, Betfair will fail login with "SSL
#'   certificate problem: self signed certificate in certificate chain". If this
#'   error occurs you may set sslVerify to FALSE. This does open a small
#'   security risk of a man-in-the-middle intercepting your login credentials.
#'
#' @return Response from Betfair is parsed from JSON into a data frame of
#'   6 columns.
#'
#' @section Note on \code{raceDetailOps} variable: The \code{raceDetailOps}
#'   variable is used to firstly build an R data frame containing all the data
#'   to be passed to Betfair, in order for the function to execute
#'   successfully. The data frame is then converted to JSON and included in the
#'   HTTP POST request. If the listRaceDetails call throws an error, a data
#'   frame containing error information is returned.
#'
#' @examples
#' \dontrun{
#' listRaceDetails() # without any arguments will return results from all available
#' # meetingIds.
#' }
#' \dontrun{
#' istRaceDetails(meetingIds = "30279213", raceIds = c("30280942.1328", "30280942.1313"))
#' # returns results from one meetingId and two races from a different meeting.
#' }
#'

listRaceDetails <- function(meetingIds = NULL,
                       raceIds = NULL,
                       suppress = FALSE,
                       sslVerify = TRUE) {

  raceDetailsOps <- data.frame(jsonrpc = "2.0", 
                                method = "ScoresAPING/v1.0/listRaceDetails",
                                params = "",
                                id = "1")

  raceDetailsOps$params <- data.frame(meetingIds = c(""))

  if (!is.null(meetingIds)) {
      raceDetailsOps$params$meetingIds <- list(meetingIds)
    }

    if (!is.null(raceIds)) {
      raceDetailsOps$params$raceIds <- list(raceIds)
    }

  raceDetailsOps <- raceDetailsOps[c("jsonrpc", "method", "params", "id")]

  raceDetailsOps <- jsonlite::toJSON(jsonlite::unbox(raceDetailsOps), pretty = TRUE)

  # Read Environment variables for authorisation details
  product <- Sys.getenv('product')
  token <- Sys.getenv('token')

  details <- httr::content(
    httr::POST(url = "https://api.betfair.com/exchange/scores/json-rpc/v1",
                 config = httr::config(ssl_verifypeer = sslVerify),
                 body = raceDetailsOps,
                 httr::add_headers(Accept = "application/json",
                                  `X-Application` = product,
                                  `X-Authentication` = token,
                                  as = "text",
                                  encoding = "UTF-8")
               )
    )

  if(is.null(details$error))
    as.data.frame(do.call(rbind, details$result))
  else({
    if(!suppress)
      warning("Error- See output for details")
    as.data.frame(details$error)})

}
