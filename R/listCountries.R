#' Return listCountries data
#'
#' \code{listCountries} simply lists all countries associated with the selected
#' parameters (e.g. number of Argentinian soccer markets closing in the next 24
#' hours). This data is useful for finding specific event identifiers, which are
#' then usually passed to further functions. By default, \code{listCountries}
#' returns are limited to the forthcoming 24-hour period. However, this can be
#' changed by user specified date/time stamps. Note: The output includes country
#' codes in the ISO-2 code fomat. A list of ISO-2 codes is available here:
#' \url{http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2}. Also, note that this
#' function will not return markets associated with international competitions
#' (e.g UEFA Champions League). Such events are assigned the country code
#' "International".
#'
#'
#' @seealso \code{\link{loginBF}}, which must be executed first.
#'
#' @param eventTypeIds vector <String>. Restrict countries by event type
#'   associated with the market. (e.g., Football = 1, Horse Racing = 7, etc).
#'   Accepts multiple IDs (See examples). IDs can be obtained via
#'   \code{\link{listEventTypes}}. Required. No default.
#'
#' @param marketTypeCodes vector <String>. Restrict to countries that match the
#'   type of the market (i.e. MATCH_ODDS, HALF_TIME_SCORE). You should use this
#'   instead of relying on the market name as the market type codes are the same
#'   in all locales. Accepts multiple market type codes (See examples).
#'   Market type codes can be obtained via \code{\link{listMarketTypes}}.
#'   Optional. Default is NULL.
#'
#' @param fromDate The start date from which to return matching countries.
#'   Format is \%Y-\%m-\%dT\%TZ. Optional. If not defined, it defaults to
#'   current system date and time minus 2 hours (to allow searching of all
#'   in-play football matches).
#'
#' @param toDate The end date to stop returning matching countries. Format is
#'   \%Y-\%m-\%dT\%TZ. Optional. If not defined defaults to the current system
#'   date and time plus 24 hours.
#'
#' @param eventIds vector <String>. Restrict to countries that are associated
#'   with the specified eventIDs (e.g. "27675602"). Optional. Default is NULL.
#'
#' @param competitionIds vector <String>. Restrict to market types that are
#'   associated with the specified competition IDs (e.g. EPL = "31", La Liga =
#'   "117"). Competition IDs can obtained via \code{\link{listCompetitions}}.
#'   Optional. Default is NULL.
#'
#' @param marketIds vector <String>. Restrict to countries that are associated
#'   with the specified marketIDs (e.g. "1.122958246"). Optional. Default is
#'   NULL.
#'
#' @param marketCountries vector <String>. Restrict to countries that are in the
#'   specified country or countries. Accepts multiple country codes. Optional.
#'   Default is NULL.
#'
#' @param venues vector <String>. Restrict countries by the venue associated
#'   with the market. This functionality is currently only available for horse
#'   racing markets (e.g.venues=c("Exeter","Navan")).  Codes can be obtained
#'   via \code{\link{listVenues}}. Optional. Default is NULL.
#'
#' @param bspOnly Boolean. Restrict to betfair staring price (bsp) countries
#'   only if TRUE or non-bsp events if FALSE. Optional. Default is NULL, which
#'   means that both bsp and non-bsp countries are returned.
#'
#' @param turnInPlayEnabled Boolean. Restrict to countries that will turn in
#'   play if TRUE or will not turn in play if FALSE. Optional. Default is NULL,
#'   which means that both countries are returned.
#'
#' @param inPlayOnly Boolean. Restrict to countries that are currently in play
#'   if TRUE or not inplay if FALSE. Optional. Default is NULL, which means that
#'   both inplay and non-inplay countries are returned.
#'
#' @param marketBettingTypes vector <String>. Restrict to countries that match
#'   the betting type of the market (i.e. Odds, Asian Handicap Singles, or Asian
#'   Handicap Doubles). Optional. Default is NULL. See
#'   \url{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Betting+Enums#BettingEnums-MarketBettingType}
#'    for a full list (and description) of viable parameter values.
#'
#' @param withOrders String. Restrict to countries in which the user has bets of
#'   a specified status. The two viable values are "EXECUTION_COMPLETE" (an
#'   order that does not have any remaining unmatched portion) and "EXECUTABLE"
#'   (an order that has a remaining unmatched portion). Optional. Default is
#'   NULL.
#'
#' @param textQuery String. Restrict countries by any text associated with the
#'   event type, such as the Name, Event, Competition, etc. The string can
#'   include a wildcard (*) character as long as it is not the first character.
#'   Optional. Default is NULL.
#'
#' @param suppress Boolean. By default, this parameter is set to FALSE, meaning
#'   that a warning is posted when the listCountries call throws an error.
#'   Changing this parameter to TRUE will suppress this warning.
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
#' @return Response from Betfair is stored in the listCountries variable, which
#'   is then parsed from JSON as a list. Only the first item of this list
#'   contains the required event type identification details. If the
#'   listCountries call throws an error, a data frame containing error
#'   information is returned.
#'
#' @section Note on \code{listCountriesOps} variable: The
#'   \code{listCountriesOps} variable is used to firstly build an R data frame
#'   containing all the data to be passed to Betfair, in order for the function
#'   to execute successfully. The data frame is then converted to JSON and
#'   included in the HTTP POST request.
#'
#' @examples
#' \dontrun{
#' # Return all football and horse racing countries (and number of
#' corresponding markets) for the upcoming day.
#' listCountries(eventTypeIds = c("1","7"))
#'
#' # Return countries that currently have at least one football market inplay.
#' listCountries(eventTypeIds = c("1"),inPlayOnly=TRUE)
#'
#' # Return upcoming countries that allow Betfair starting prices (BSPs) on
#' specific football markets.
#' listCountries(eventTypeIds = c("1"),bspOnly=TRUE)
#' }
#'

<<<<<<< HEAD
listCountries <- function(eventTypeIds, sslVerify = TRUE) {
  listCountriesOps <-
    data.frame(jsonrpc = "2.0", method = "SportsAPING/v1.0/listCountries", id = "1")

  listCountriesOps$params <- data.frame(filter = c(""))

  listCountriesOps$params$filter <- data.frame(eventTypeIds = c(""))

  listCountriesOps$params$filter$eventTypeIds <- list(eventTypeIds)

  listCountriesOps <-
    listCountriesOps[c("jsonrpc", "method", "params", "id")]

  listCountriesOps <-
    jsonlite::toJSON(listCountriesOps, pretty = TRUE)

  # Read Environment variables for authorisation details
  product <- Sys.getenv('product')
  token <- Sys.getenv('token')

  headers <- list(
    'Accept' = 'application/json', 'X-Application' = product, 'X-Authentication' = token, 'Content-Type' = 'application/json'
  )

  listCountries <-
    as.list(jsonlite::fromJSON(
      RCurl::postForm(
        "https://api.betfair.com/exchange/betting/json-rpc/v1", .opts = list(
          postfields = listCountriesOps, httpheader = headers, ssl.verifypeer = sslVerify
        )
      )
    ))

  as.data.frame(listCountries$result[1])

}
=======
listCountries <-
  function(eventTypeIds , marketTypeCodes=NULL,
           fromDate = (format(Sys.time() -7200, "%Y-%m-%dT%TZ")),
           toDate = (format(Sys.time() + 86400, "%Y-%m-%dT%TZ")),
           eventIds = NULL, competitionIds = NULL, marketIds =NULL,
           marketCountries = NULL, venues = NULL, bspOnly = NULL,
           turnInPlayEnabled = NULL, inPlayOnly = NULL, marketBettingTypes = NULL,
           withOrders = NULL, textQuery = NULL, suppress = FALSE, sslVerify = TRUE) {
    options(stringsAsFactors = FALSE)

    listCountriesOps <-
      data.frame(jsonrpc = "2.0", method = "SportsAPING/v1.0/listCountries", id = "1")

    listCountriesOps$params <-
      data.frame(filter = c(""))
    listCountriesOps$params$filter <-
      data.frame(marketStartTime = c(""))

    if (!is.null(eventIds)) {
      listCountriesOps$params$filter$eventIds <- list(eventIds)
    }

    if (!is.null(eventTypeIds)) {
      listCountriesOps$params$filter$eventTypeIds <-
        list(eventTypeIds)
    }

    if (!is.null(competitionIds)) {
      listCountriesOps$params$filter$competitionIds <-
        list(competitionIds)
    }

    if (!is.null(marketIds)) {
      listCountriesOps$params$filter$marketIds <- list(marketIds)
    }

    if (!is.null(venues)) {
      listCountriesOps$params$filter$venues <- list(venues)
    }

    if (!is.null(marketCountries)) {
      listCountriesOps$params$filter$marketCountries <-
        list(marketCountries)
    }

    if (!is.null(marketTypeCodes)) {
      listCountriesOps$params$filter$marketTypeCodes <-
        list(marketTypeCodes)
    }

    listCountriesOps$params$filter$bspOnly <- bspOnly
    listCountriesOps$params$filter$turnInPlayEnabled <-
      turnInPlayEnabled
    listCountriesOps$params$filter$inPlayOnly <- inPlayOnly
    listCountriesOps$params$filter$textQuery <- textQuery

    if (!is.null(marketBettingTypes)) {
      listCountriesOps$params$filter$marketBettingTypes <-
        list(marketBettingTypes)
    }

    if (!is.null(withOrders)) {
      listCountriesOps$params$filter$withOrders <- list(withOrders)
    }

    listCountriesOps$params$filter$marketStartTime <-
      data.frame(from = fromDate, to = toDate)


    listCountriesOps <-
      listCountriesOps[c("jsonrpc", "method", "params", "id")]

    listCountriesOps <-
      jsonlite::toJSON(listCountriesOps, pretty = TRUE)

    # Read Environment variables for authorisation details
    product <- Sys.getenv('product')
    token <- Sys.getenv('token')


    headers <- list(
      'Accept' = 'application/json', 'X-Application' = product, 'X-Authentication' = token, 'Content-Type' = 'application/json'
    )

    listCountries <-
      as.list(jsonlite::fromJSON(
        RCurl::postForm(
          "https://api.betfair.com/exchange/betting/json-rpc/v1", .opts = list(
            postfields = listCountriesOps, httpheader = headers, ssl.verifypeer = sslVerify
          )
        )
      ))

    if(is.null(listCountries$error))
      as.data.frame(listCountries$result[1])
    else({
      if(!suppress)
        warning("Error- See output for details")
      as.data.frame(listCountries$error)})
  }
>>>>>>> 7451ad6998a636ce832895f4ee78b0ef73b4630c
