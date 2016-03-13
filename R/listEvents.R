#' Return listEvents data
#'
#' \code{listEvents} returns top-level event data.
#'
#' \code{listEvents} returns top-level event data (e.g. id, name, number of
#' associated markets) and can be filtered via the API-NG based on a number of
#' arguments. This data is  Useful for finding specific event identification
#' numbers, which are then usually passed to further functions.
#' By default, \code{listEvents} returns are limited to the forthcoming 24-hour
#' period. However, this can be changed by user specified date/time stamps.
#' A full description of the function output may be found here:
#' \url{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Betting+Type+Definitions#BettingTypeDefinitions-EventResult}
#'
#' @seealso \code{\link{loginBF}}, which must be executed first.
#'
#' @param eventTypeIds vector <String>. Restrict events by event type associated
#'   with the market. (i.e., Football, Horse Racing, etc). Accepts multiple IDs
#'   (See examples). IDs can be obtained via \code{\link{listEventTypes}}.
#'   Required. No default.
#'
#' @param marketTypeCodes vector <String>. Restrict to events that match the
#'   type of the market (i.e. MATCH_ODDS, HALF_TIME_SCORE). You should use this
#'   instead of relying on the market name as the market type codes are the same
#'   in all locales. Accepts multiple market type codes (See examples). Market
#'   codes can be obtained via \code{\link{listMarketTypes}}. Optional. Default
#'   is NULL.
#'
#' @param fromDate The start date from which to return matching events. Format
#'   is \%Y-\%m-\%dT\%TZ. Optional. If not defined, it defaults to current
#'   system date and time minus 2 hours (to allow searching of all in-play
#'   football matches).
#'
#' @param toDate The end date to stop returning matching events. Format is
#'   \%Y-\%m-\%dT\%TZ. Optional. If not defined defaults to the current system
#'   date and time plus 24 hours.
#'
#' @param eventIds vector <String>. Restrict to events that are associated with
#'   the specified eventIDs (e.g. "27675602"). Optional. Default is NULL.
#'
#' @param competitionIds vector <String>. Restrict to events that are associated
#'   with the specified competition IDs (e.g. EPL = "31", La Liga = "117").
#'   Optional. Default is NULL.
#'
#' @param marketIds vector <String>. Restrict to events that are associated with
#'   the specified marketIDs (e.g. "1.122958246"). Optional. Default is NULL.
#'
#' @param marketCountries vector <String>. Restrict to events that are in the
#'   specified country or countries. Accepts multiple country codes (See
#'   examples). Codes can be obtained via \code{\link{listCountries}}. Optional.
#'   Default is NULL.
#'
#' @param venues vector <String>. Restrict events by the venue associated with
#'   the market. This functionality is currently only available for horse racing
#'   markets (e.g.venues=c("Exeter","Navan")). Optional. Default is NULL.
#'
#' @param bspOnly Boolean. Restrict to betfair staring price (bsp) events only
#'   if TRUE or non-bsp events if FALSE. Optional. Default is NULL, which means
#'   that both bsp and non-bsp events are returned.
#'
#' @param turnInPlayEnabled Boolean. Restrict to events that will turn in play
#'   if TRUE or will not turn in play if FALSE. Optional. Default is NULL, which
#'   means that both event types are returned.
#'
#' @param inPlayOnly Boolean. Restrict to events that are currently in play if
#'   TRUE or not inplay if FALSE. Optional. Default is NULL, which means that
#'   both inplay and non-inplay events are returned.
#'
#' @param marketBettingTypes vector <String>. Restrict to events that match the
#'   betting type of the market (i.e. Odds, Asian Handicap Singles, or Asian
#'   Handicap Doubles). Optional. Default is NULL. See
#'   \url{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Betting+Enums#BettingEnums-MarketBettingType}
#'    for a full list (and description) of viable parameter values.
#'
#' @param withOrders String. Restrict to events in which the user has bets of a
#'   specified status. The two viable values are "EXECUTION_COMPLETE" (an order
#'   that does not have any remaining unmatched portion) and "EXECUTABLE" (an
#'   order that has a remaining unmatched portion). Optional. Default is NULL.
#'
#' @param textQuery String. Restrict events by any text associated with the
#'   event such as the Name, Event, Competition, etc. The string can include a
#'   wildcard (*) character as long as it is not the first character. Optional.
#'   Default is NULL.
#'
#' @param suppress Boolean. By default, this parameter is set to FALSE, meaning
#'   that a warning is posted when the listEvents call throws an error. Changing
#'   this parameter to TRUE will suppress this warning.
#'
#' @param sslVerify Boolean. This argument defaults to TRUE and is optional. In
#'   some cases, where users have a self signed SSL Certificate, for example
#'   they may be behind a proxy server, Betfair will fail login with "SSL
#'   certificate problem: self signed certificate in certificate chain". If this
#'   error occurs you may set sslVerify to FALSE. This does open a small
#'   security risk of a man-in-the-middle intercepting your login credentials.
#'
#'
#'
#' @return Response from Betfair is stored in the listEvents variable, which is
#'   then parsed from JSON as a list. Only the first item of this list contains
#'   the required event type identification details. If the listEvents call
#'   throws an error, a data frame containing error information is returned.
#'
#' @section Note on \code{listEventsOps} variable: The \code{listEventsOps}
#'   variable is used to firstly build an R data frame containing all the data
#'   to be passed to Betfair, in order for the function to execute successfully.
#'   The data frame is then converted to JSON and included in the HTTP POST
#'   request.
#'
#' @examples
#' \dontrun{
#' # Return event data for the Horse Racing event type, in both Great
#' Britain and Ireland and Win markets only.
#' listEvents(eventTypeIds = "7", marketCountries = c("GB", "IE"),
#'                    marketTypeCodes = "WIN")
#'
#' # Return event data for the Horse Racing event type, in only Great
#' Britain, but both Win and Place markets.
#' listEvents(eventTypeIds = "7", marketCountries = "GB",
#'                    marketTypeCodes = c("WIN", "PLACE")
#'                    )
#'
#' # Return event data for both Horse Racing and Football event types, in
#' Great Britain only and for both Win and Match Odds market types.
#' listEvents(eventTypeIds = c("7","1"),
#'                     marketCountries = "GB",
#'                     marketTypeCodes = c("WIN", "MATCH_ODDS")
#'                     )
#'
#' # Return event data for all football matches currently inplay,
#' restricted to events with Match Odds market types.
#' listEvents(eventTypeIds = c("1"),marketTypeCodes = c("MATCH_ODDS"),
#'                    inPlayOnly = TRUE, MarketSort = "MAXIMUM_TRADED")
#' }
#'

listEvents <-
  function(eventTypeIds, marketTypeCodes=NULL,
           fromDate = (format(Sys.time() -7200, "%Y-%m-%dT%TZ")),
           toDate = (format(Sys.time() + 86400, "%Y-%m-%dT%TZ")),
           eventIds = NULL, competitionIds = NULL, marketIds =NULL,
           marketCountries = NULL, venues = NULL, bspOnly = NULL,
           turnInPlayEnabled = NULL, inPlayOnly = NULL, marketBettingTypes = NULL,
           withOrders = NULL, textQuery = NULL, suppress = FALSE, sslVerify = TRUE) {
    options(stringsAsFactors = FALSE)

    listEventsOps <-
      data.frame(jsonrpc = "2.0", method = "SportsAPING/v1.0/listEvents", id = "1")

    listEventsOps$params <-
      data.frame(filter = c(""))
    listEventsOps$params$filter <-
      data.frame(marketStartTime = c(""))

    if (!is.null(eventIds)) {
      listEventsOps$params$filter$eventIds <- list(eventIds)
    }

    if (!is.null(eventTypeIds)) {
      listEventsOps$params$filter$eventTypeIds <-
        list(eventTypeIds)
    }

    if (!is.null(competitionIds)) {
      listEventsOps$params$filter$competitionIds <-
        list(competitionIds)
    }

    if (!is.null(marketIds)) {
      listEventsOps$params$filter$marketIds <- list(marketIds)
    }

    if (!is.null(venues)) {
      listEventsOps$params$filter$venues <- list(venues)
    }

    if (!is.null(marketCountries)) {
      listEventsOps$params$filter$marketCountries <-
        list(marketCountries)
    }

    if (!is.null(marketTypeCodes)) {
      listEventsOps$params$filter$marketTypeCodes <-
        list(marketTypeCodes)
    }

    listEventsOps$params$filter$bspOnly <- bspOnly
    listEventsOps$params$filter$turnInPlayEnabled <-
      turnInPlayEnabled
    listEventsOps$params$filter$inPlayOnly <- inPlayOnly
    listEventsOps$params$filter$textQuery <- textQuery

    if (!is.null(marketBettingTypes)) {
      listEventsOps$params$filter$marketBettingTypes <-
        list(marketBettingTypes)
    }

    if (!is.null(withOrders)) {
      listEventsOps$params$filter$withOrders <- list(withOrders)
    }

    listEventsOps$params$filter$marketStartTime <-
      data.frame(from = fromDate, to = toDate)


    listEventsOps <-
      listEventsOps[c("jsonrpc", "method", "params", "id")]

    listEventsOps <-
      jsonlite::toJSON(listEventsOps, pretty = TRUE)

    # Read Environment variables for authorisation details
    product <- Sys.getenv('product')
    token <- Sys.getenv('token')


    headers <- list(
      'Accept' = 'application/json', 'X-Application' = product, 'X-Authentication' = token, 'Content-Type' = 'application/json'
    )

    listEvents <-
      as.list(jsonlite::fromJSON(
        RCurl::postForm(
          "https://api.betfair.com/exchange/betting/json-rpc/v1", .opts = list(
            postfields = listEventsOps, httpheader = headers, ssl.verifypeer = sslVerify
          )
        )
      ))

    if(is.null(listEvents$error))
      as.data.frame(listEvents$result[1])
    else({
      if(!suppress)
        warning("Error- See output for details")
      as.data.frame(listEvents$error)})
  }
