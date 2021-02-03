#' Return listTimeRanges data
#'
#' \code{listTimeRanges} returns the number of events by time range.
#'
#' \code{listTimeRanges} returns a list of time ranges in the granularity specified
#' in the request (i.e. 3PM to 4PM, Aug 14th to Aug 15th) and the number of markets
#' selected by the \code{MarketFilter}.
#' A full description of the function output may be found here:
#' \url{https://docs.developer.betfair.com/display/1smk3cen4v3lu3yomq5qye0ni/Betting+Type+Definitions#BettingTypeDefinitions-TimeRangeResult}
#'
#' @seealso \code{\link{loginBF}}, which must be executed first.
#'
#' @param textQuery String. Restrict events by any text associated with the
#'   event such as the Name, Event, Competition, etc. The string can include a
#'   wildcard (*) character as long as it is not the first character. Optional.
#'   Default is NULL.
#'
#' @param eventTypeIds vector <String>. Restrict events by event type associated
#'   with the market. (i.e., Football, Horse Racing, etc). Accepts multiple IDs
#'   (See examples). IDs can be obtained via \code{\link{listEventTypes}}.
#'   Optional. Default is NULL.
#'
#' @param eventIds vector <String>. Restrict to events that are associated with
#'   the specified eventIDs (e.g. "27675602"). IDs can be obtained via
#'   \code{\link{listEvents}}.Optional. Default is NULL.
#'
#' @param competitionIds vector <String>. Restrict to events that are associated
#'   with the specified competition IDs (e.g. EPL = "31", La Liga = "117"). IDs
#'   can be obtained via \code{\link{listCompetitions}}. Optional. Default is NULL.
#'
#' @param marketIds vector <String>. Restrict to events that are associated with
#'   the specified marketIDs (e.g. "1.122958246"). Optional. Default is NULL.
#'
#' @param venues vector <String>. Restrict events by the venue associated with
#'   the market. This functionality is currently only available for horse racing
#'   markets (e.g.venues=c("Exeter","Navan")). Venue names can be obtained via
#'   \code{\link{listVenues}}. Optional. Default is NULL.
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
#' @param marketCountries vector <String>. Restrict to events that are in the
#'   specified country or countries. Accepts multiple country codes (See
#'   examples). Codes can be obtained via \code{\link{listCountries}}. Optional.
#'   Default is NULL.
#'
#' @param marketTypeCodes vector <String>. Restrict to events that match the
#'   type of the market (i.e. MATCH_ODDS, HALF_TIME_SCORE). You should use this
#'   instead of relying on the market name as the market type codes are the same
#'   in all locales. Accepts multiple market type codes (See examples). Market
#'   codes can be obtained via \code{\link{listMarketTypes}}. Optional. Default
#'   is NULL.
#'
#' @param fromDate The start date from which to return matching events. Format
#'   is \%Y-\%m-\%dT\%TZ, tz = "UTC". Times must be submitted in UTC as this is what is used
#'   by Betfair. Optional. Default is NULL.
#'
#' @param toDate The end date to stop returning matching events. Format is
#'   \%Y-\%m-\%dT\%TZ, tz = "UTC". Times must be submitted in UTC as this is what is used
#'   by Betfair. Optional. Default is NULL.
#'
#' @param withOrders String. Restrict to events in which the user has bets of a
#'   specified status. The two viable values are "EXECUTION_COMPLETE" (an order
#'   that does not have any remaining unmatched portion) and "EXECUTABLE" (an
#'   order that has a remaining unmatched portion). Optional. Default is NULL.
#'
#' @param raceTypes vector <String>. Restrict by race type (i.e. Hurdle, Flat,
#'   Bumper, Harness, Chase). These don't appear to be clearly and consistently
#'   defined in Betfair's documentation. Optional. Default is NULL.
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
#' @return Response from Betfair is stored in the listTimeRanges variable, which
#'   is then parsed from JSON as a list. If the listTimeRanges call throws an
#'   error, a data frame containing error information is returned.
#'
#' @section Note on \code{listTimeRangesOps} variable: The \code{listTimeRangesOps}
#'   variable is used to firstly build an R data frame containing all the data
#'   to be passed to Betfair, in order for the function to execute successfully.
#'   The data frame is then converted to JSON and included in the HTTP POST
#'   request.
#'
#' @examples
#' \dontrun{
#' # Return TimeRanges data for the Horse Racing event type, in both Great
#' Britain and Ireland and Win markets only.
#' listTimeRanges(eventTypeIds = "7", marketCountries = c("GB", "IE"),
#'                    marketTypeCodes = "WIN")
#'
#'

listTimeRanges <- function(textQuery = NULL, eventTypeIds = NULL, eventIds = NULL,
                           competitionIds = NULL, marketIds = NULL, venues = NULL,
                           bspOnly = NULL, turnInPlayEnabled = NULL,
                           inPlayOnly = NULL, marketBettingTypes = NULL,
                           marketCountries = NULL, marketTypeCodes = NULL,
                           fromDate = NULL, toDate = NULL,
                           withOrders = NULL, raceTypes = NULL,
                           timeGranularity = "HOURS",
                           suppress = FALSE, sslVerify = TRUE) {
  options(stringsAsFactors = FALSE)

  listTimeRangesOps <-
    data.frame(jsonrpc = "2.0", method = "SportsAPING/v1.0/listTimeRanges", id = "1")

  listTimeRangesOps$params <-
    data.frame(filter = c(""))
  listTimeRangesOps$params$filter <-
    data.frame(marketStartTime = c(""))

  listTimeRangesOps$params$filter <- data.frame(textQuery = c(""))
  listTimeRangesOps$params$filter$textQuery = textQuery

  if(!is.null(eventTypeIds)){
    listTimeRangesOps$params$filter$eventTypeIds = list(eventTypeIds)
  }
  if(!is.null(eventIds)){
    listTimeRangesOps$params$filter$eventIds = list(eventIds)
  }
  if(!is.null(competitionIds)){
    listTimeRangesOps$params$filter$competitionIds = list(competitionIds)
  }
  if(!is.null(marketIds)){
    listTimeRangesOps$params$filter$marketIds = list(marketIds)
  }
  if(!is.null(venues)){
    listTimeRangesOps$params$filter$venues = list(venues)
  }

  listTimeRangesOps$params$filter$bspOnly = bspOnly
  listTimeRangesOps$params$filter$turnInPlayEnabled = turnInPlayEnabled
  listTimeRangesOps$params$filter$inPlayOnly = inPlayOnly

  if(!is.null(marketBettingTypes)){
    listTimeRangesOps$params$filter$marketBettingTypes = list(marketBettingTypes)
  }
  if(!is.null(marketCountries)){
    listTimeRangesOps$params$filter$marketCountries = list(marketCountries)
  }
  if(!is.null(marketTypeCodes)){
    listTimeRangesOps$params$filter$marketTypeCodes = list(marketTypeCodes)
  }

  if(!is.null(fromDate) && !is.null(toDate)){
    listTimeRangesOps$params$filter$marketStartTime <-
      data.frame(from = fromDate, to = toDate)
  }

  if(!is.null(withOrders)){
    listTimeRangesOps$params$filter$withOrders = list(withOrders)
  }
  if(!is.null(raceTypes)){
    listTimeRangesOps$params$filter$raceTypes = list(raceTypes)
  }

  listTimeRangesOps$params$granularity <- timeGranularity

  listTimeRangesOps <-
    listTimeRangesOps[c("jsonrpc", "method", "params", "id")]


  show(listTimeRangesOps)

  listTimeRangesOps <-
    jsonlite::toJSON(jsonlite::unbox(listTimeRangesOps))

  # Read Environment variables for authorisation details
  product <- Sys.getenv('product')
  token <- Sys.getenv('token')

  listTimeRanges <- httr::content(
    httr::POST(url = "https://api.betfair.com/exchange/betting/json-rpc/v1",
               config = httr::config(ssl_verifypeer = sslVerify),
               body = listTimeRangesOps,
               httr::add_headers(Accept = "application/json",
                                 "X-Application" = product,
                                 "X-Authentication" = token)), as = "text", encoding = "UTF-8")

  listTimeRanges <- jsonlite::fromJSON(listTimeRanges)

  if(is.null(listTimeRanges$error))
    as.data.frame(listTimeRanges$result)
  else({
    if(!suppress)
      warning("Error- See output for details")
    as.data.frame(listTimeRanges$error)})
}

