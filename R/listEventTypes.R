#' Return Event Types data
#'
#' \code{listEventTypes} simply lists all available event types on the Betfair
#' exchange (e.g. number of soccer markets available in the next 24 hours). This
#' data is  Useful for finding specific event identification numbers (e.g. sport
#' IDs), which are then usually passed to further functions. By default,
#' \code{listEventTypes} returns are limited to the forthcoming 24-hour period.
#' However, this can be changed by user specified date/time stamps.
#'
#' @seealso \code{\link{loginBF}}, which must be executed first.
#'
#' @param eventTypeIds vector <String>. Restrict events by event type associated
#'   with the market. (i.e., Football = 1, Horse Racing = 7, etc). Optional.
#'   Default is NULL.
#'
#' @param marketTypeCodes vector <String>. Restrict to event types that match
#'   the type of the market (i.e. MATCH_ODDS, HALF_TIME_SCORE). You should use
#'   this instead of relying on the market name as the market type codes are the
#'   same in all locales. Accepts multiple market type codes (See examples).
#'   Market codes can be obtained via \code{\link{listMarketTypes}}. Optional.
#'   Default is NULL.
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
#' @param eventIds vector <String>. Restrict to event types that are associated
#'   with the specified eventIDs (e.g. "27675602"). Optional. Default is NULL.
#'
#' @param competitionIds vector <String>. Restrict to market types that are
#'   associated with the specified competition IDs (e.g. EPL = "31", La Liga =
#'   "117"). Competition IDs can obtained via \code{\link{listCompetitions}}.
#'   Optional. Default is NULL.
#'
#' @param marketIds vector <String>. Restrict to event types that are associated
#'   with the specified marketIDs (e.g. "1.122958246"). Optional. Default is
#'   NULL.
#'
#' @param marketCountries vector <String>. Restrict to event types that are in
#'   the specified country or countries. Accepts multiple country codes. Codes
#'   can be obtained via \code{\link{listCountries}}. Optional. Default is NULL.
#'
#' @param venues vector <String>. Restrict event types by the venue associated
#'   with the market. This functionality is currently only available for horse
#'   racing markets (e.g.venues=c("Exeter","Navan")).  Codes can be obtained via
#'   \code{\link{listVenues}}. Optional. Default is NULL.
#'
#' @param bspOnly Boolean. Restrict to betfair staring price (bsp) event types
#'   only if TRUE or non-bsp events if FALSE. Optional. Default is NULL, which
#'   means that both bsp and non-bsp events are returned.
#'
#' @param turnInPlayEnabled Boolean. Restrict to event types that will turn in
#'   play if TRUE or will not turn in play if FALSE. Optional. Default is NULL,
#'   which means that both event types are returned.
#'
#' @param inPlayOnly Boolean. Restrict to event types that are currently in play
#'   if TRUE or not inplay if FALSE. Optional. Default is NULL, which means that
#'   both inplay and non-inplay event types are returned.
#'
#' @param marketBettingTypes vector <String>. Restrict to event types that match
#'   the betting type of the market (i.e. Odds, Asian Handicap Singles, or Asian
#'   Handicap Doubles). Optional. Default is NULL. See
#'   \url{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Betting+Enums#BettingEnums-MarketBettingType}
#'    for a full list (and description) of viable parameter values.
#'
#' @param withOrders String. Restrict to event types in which the user has bets
#'   of a specified status. The two viable values are "EXECUTION_COMPLETE" (an
#'   order that does not have any remaining unmatched portion) and "EXECUTABLE"
#'   (an order that has a remaining unmatched portion). Optional. Default is
#'   NULL.
#'
#' @param textQuery String. Restrict event types by any text associated with the
#'   event type, such as the Name, Event, Competition, etc. The string can
#'   include a wildcard (*) character as long as it is not the first character.
#'   Optional. Default is NULL.
#'
#' @param suppress Boolean. By default, this parameter is set to FALSE, meaning
#'   that a warning is posted when the listEventTypes call throws an error.
#'   Changing this parameter to TRUE will suppress this warning.
#'
#' @param sslVerify Boolean. This argument defaults to TRUE and is optional. In
#'   some cases, where users have a self signed SSL Certificate, for example
#'   they may be behind a proxy server, Betfair will fail login with "SSL
#'   certificate problem: self signed certificate in certificate chain". If this
#'   error occurs you may set sslVerify to FALSE. This does open a small
#'   security risk of a man-in-the-middle intercepting your login credentials.
#'
#' @return Response from Betfair is stored in the listEventTypes variable, which
#'   is then parsed from JSON as a list. Only the first item of this list
#'   contains the required event type identification details. If the
#'   listEventTypes call throws an error, a data frame containing error
#'   information is returned.
#'
#' @section Note on \code{listEventTypesOps} variable: The
#'   \code{listEventTypesOps} variable is used to firstly build an R data frame
#'   containing all the data to be passed to Betfair, in order for the function
#'   to execute successfully. The data frame is then converted to JSON and
#'   included in the HTTP POST request.
#'
#' @examples
#' \dontrun{
#' #Return all event types (and number of corresponding markets) for the
#' upcoming day.
#' listEventTypes()
#'
#' # Return event types that currently have at least one event inplay.
#' listEventTypes(inPlayOnly=TRUE)
#'
#' # Return event types that allow Betfair starting prices (BSPs).
#' listEventTypes(bspOnly=TRUE)
#' }
#'

listEventTypes <-
  function(eventTypeIds = NULL, marketTypeCodes=NULL,
           fromDate = (format(Sys.time() -7200, "%Y-%m-%dT%TZ")),
           toDate = (format(Sys.time() + 86400, "%Y-%m-%dT%TZ")),
           eventIds = NULL, competitionIds = NULL, marketIds =NULL,
           marketCountries = NULL, venues = NULL, bspOnly = NULL,
           turnInPlayEnabled = NULL, inPlayOnly = NULL, marketBettingTypes = NULL,
           withOrders = NULL, textQuery = NULL, suppress = FALSE, sslVerify = TRUE) {
    options(stringsAsFactors = FALSE)

    listEventTypesOps <-
      data.frame(jsonrpc = "2.0", method = "SportsAPING/v1.0/listEventTypes", id = "1")

    listEventTypesOps$params <-
      data.frame(filter = c(""))
    listEventTypesOps$params$filter <-
      data.frame(marketStartTime = c(""))

    if (!is.null(eventIds)) {
      listEventTypesOps$params$filter$eventIds <- list(eventIds)
    }

    if (!is.null(eventTypeIds)) {
      listEventTypesOps$params$filter$eventTypeIds <-
        list(eventTypeIds)
    }

    if (!is.null(competitionIds)) {
      listEventTypesOps$params$filter$competitionIds <-
        list(competitionIds)
    }

    if (!is.null(marketIds)) {
      listEventTypesOps$params$filter$marketIds <- list(marketIds)
    }

    if (!is.null(venues)) {
      listEventTypesOps$params$filter$venues <- list(venues)
    }

    if (!is.null(marketCountries)) {
      listEventTypesOps$params$filter$marketCountries <-
        list(marketCountries)
    }

    if (!is.null(marketTypeCodes)) {
      listEventTypesOps$params$filter$marketTypeCodes <-
        list(marketTypeCodes)
    }

    listEventTypesOps$params$filter$bspOnly <- bspOnly
    listEventTypesOps$params$filter$turnInPlayEnabled <-
      turnInPlayEnabled
    listEventTypesOps$params$filter$inPlayOnly <- inPlayOnly
    listEventTypesOps$params$filter$textQuery <- textQuery

    if (!is.null(marketBettingTypes)) {
      listEventTypesOps$params$filter$marketBettingTypes <-
        list(marketBettingTypes)
    }

    if (!is.null(withOrders)) {
      listEventTypesOps$params$filter$withOrders <- list(withOrders)
    }

    listEventTypesOps$params$filter$marketStartTime <-
      data.frame(from = fromDate, to = toDate)


    listEventTypesOps <-
      listEventTypesOps[c("jsonrpc", "method", "params", "id")]

    listEventTypesOps <-
      jsonlite::toJSON(jsonlite::unbox(listEventTypesOps))

    # Read Environment variables for authorisation details
    product <- Sys.getenv('product')
    token <- Sys.getenv('token')

    listEventTypes <- httr::content(
      httr::POST(url = "https://api.betfair.com/exchange/betting/json-rpc/v1",
                 config = httr::config(ssl_verifypeer = sslVerify),
                 body = listEventTypesOps,
                 httr::add_headers(Accept = "application/json",
                                   "X-Application" = product,
                                   "X-Authentication" = token)), as = "text")

    listEventTypes <- jsonlite::fromJSON(listEventTypes)

    if(is.null(listEventTypes$error))
      as.data.frame(listEventTypes$result[1])
    else({
      if(!suppress)
        warning("Error- See output for details")
      as.data.frame(listEventTypes$error)})
  }
