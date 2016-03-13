#' Return listMarketCatalogue data
#'
#' \code{listMarketCatalogue} returns in-depth market data.
#'
#' \code{listMarketCatalogue} returns in-depth market data and can be filtered
#' via the API-NG based on a number of arguments. Using Horse Racing as an
#' example, complete race cards are returned for the specified markets. No
#' pricing data is returned via \code{listMarketCatalogue}. By default,
#' \code{listMarketCatalogue} returns are limited to the forthcoming 24-hour
#' period. However, this can be changed by user specified date/time stamps.
#'
#' The output of \code{listMarketCatalogue} is complex and contains all data
#' about the requested markets, apart from price. A full description of this
#' output may be found here:
#'
#' \url{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Betting+Type+Definitions#BettingTypeDefinitions-MarketCatalogue}
#'
#' @seealso \code{\link{loginBF}}, which must be executed first.
#'
#' @param eventTypeIds vector <String>. Restrict markets by event type
#'   associated with the market. (i.e., Football, Horse Racing, etc). Accepts
#'   multiple IDs (See examples). IDs can be obtained via
#'   \code{\link{listEventTypes}}. Required. No default.
#'
#' @param marketTypeCodes vector <String>. Restrict to markets that match the
#'   type of the market (i.e. MATCH_ODDS, HALF_TIME_SCORE). You should use this
#'   instead of relying on the market name as the market type codes are the same
#'   in all locales. Accepts multiple market type codes (See examples). Market
#'   codes can be obtained via \code{\link{listMarketTypes}}, Required. No
#'   default.
#'
#' @param maxResults Integer. Limit on the total number of results returned,
#'   must be greater than 0 and less than or equal to 1000. Optional. If not
#'   defined, defaults to 200.
#'
#' @param fromDate The start date from which to return matching events. Format
#'   is \%Y-\%m-\%dT\%TZ. Optional. If not defined defaults to current system
#'   date and time minus 2 hours (to allow searching of all in-play football
#'   matches).
#'
#' @param toDate The end date to stop returning matching events. Format is
#'   \%Y-\%m-\%dT\%TZ. Optional. If not defined defaults to the current system
#'   date and time plus 24 hours.
#'
#' @param eventIds vector <String>. Restrict to markets that are associated with
#'   the specified eventIDs (e.g. "27675602"). Optional. Default is NULL.
#'
#' @param competitionIds vector <String>. Restrict to markets that are
#'   associated with the specified competition IDs (e.g. EPL = "31", La Liga =
#'   "117"). Optional. Default is NULL.
#'
#' @param marketIds vector <String>. Restrict to markets that are associated
#'   with the specified marketIDs (e.g. "1.122958246"). Optional. Default is
#'   NULL.
#'
#' @param marketCountries vector <String>. Restrict to markets that are in the
#'   specified country or countries. Accepts multiple country codes (See
#'   examples). Codes can be obtained via \code{\link{listCountries}}. Optional.
#'   Default is NULL.
#'
#' @param venues vector <String>. Restrict markets by the venue associated with
#'   the market. This functionality is currently only available for horse racing
#'   markets (e.g.venues=c("Exeter","Navan")). Optional. Default is NULL.
#'
#' @param bspOnly Boolean. Restrict to betfair staring price (bsp) markets only,
#'   if TRUE or non-bsp markets if FALSE. Optional. Default is NULL, which means
#'   that both bsp and non-bsp markets are returned.
#'
#' @param turnInPlayEnabled Boolean. Restrict to markets that will turn in play
#'   if TRUE or will not turn in play if FALSE. Optional. Default is NULL, which
#'   means that both market types are returned.
#'
#' @param inPlayOnly Boolean. Restrict to markets that are currently in play if
#'   TRUE or not inplay if FALSE. Optional. Default is NULL, which means that
#'   both inplay and non-inplay markets are returned.
#'
#' @param marketBettingTypes vector <String>. Restrict to markets that match the
#'   betting type of the market (i.e. Odds, Asian Handicap Singles, or Asian
#'   Handicap Doubles). Optional. Default is NULL. See
#'   \url{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Betting+Enums#BettingEnums-MarketBettingType}
#'    for a full list (and description) of viable parameter values.
#'
#' @param withOrders String. Restrict to markets in which the user has bets of a
#'   specified status. The two viable values are "EXECUTION_COMPLETE" (an order
#'   that does not have any remaining unmatched portion) and "EXECUTABLE" (an
#'   order that has a remaining unmatched portion). Optional. Default is NULL.
#'
#' @param marketSort String. Determines the order of the results. Optional.
#'   Default value is NULL, which Betfair converts to "RANK". "RANK" is an
#'   assigned priority that is determined by the Betfair Market Operations team
#'   in their back-end system. A result's overall rank is derived from the
#'   ranking given to the following attributes for the result: EventType,
#'   Competition, StartTime, MarketType, MarketId. For example, EventType is
#'   ranked by the most popular sports types and marketTypes are ranked in the
#'   following order: ODDS ASIAN LINE RANGE If all other dimensions of the
#'   result are equal, then the results are ranked in MarketId order. See
#'   \url{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Betting+Enums#BettingEnums-MarketSort}
#'    for a full list (and description) of viable parameter values.
#'
#' @param marketProjection vector <String>. Determines the type and amount of
#'   data returned about the market. By default all data, except "MARKET
#'   DESCRIPTION", is included. See
#'   \url{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Betting+Enums#BettingEnums-MarketProjection}
#'    for a full list (and description) of all parameter values.
#'
#' @param textQuery String. Restrict markets by any text associated with the
#'   market such as the Name, Event, Competition, etc. The string can include a
#'   wildcard (*) character as long as it is not the first character. Optional.
#'   Default is NULL.
#'
#' @param sslVerify Boolean. This argument defaults to TRUE and is optional. In
#'   some cases, where users have a self signed SSL Certificate, for example
#'   they may be behind a proxy server, Betfair will fail login with "SSL
#'   certificate problem: self signed certificate in certificate chain". If this
#'   error occurs you may set sslVerify to FALSE. This does open a small
#'   security risk of a man-in-the-middle intercepting your login credentials.
#'
#' @return Response from Betfair is stored in listMarketCatalogue variable,
#'   which is then parsed from JSON as a list. Only the first item of this list
#'   contains the required event type identification details.
#'
#' @section Note on \code{listMarketCatalogueOps} variable: The
#'   \code{listMarketCatalogueOps} variable is used to firstly build an R data
#'   frame containing all the data to be passed to Betfair, in order for the
#'   function to execute successfully. The data frame is then converted to JSON
#'   and included in the HTTP POST request.
#'
#' @examples
#' \dontrun{
#' # Return market catalogues for the Horse Racing event type, in both Great
#' Britain and Ireland and Win markets only.
#' listMarketCatalogue(eventTypeIds = "7", marketCountries = c("GB", "IE"),
#'                    marketTypeCodes = "WIN")
#'
#' # Return market catalogues for the Horse Racing event type, in only Great
#' Britain, but both Win and Place markets.
#' listMarketCatalogue(eventTypeIds = "7", marketCountries = "GB",
#'                    marketTypeCodes = c("WIN", "PLACE")
#'                    )
#'
#' # Return market catalogues for both Horse Racing and Football event types, in
#' Great Britain only and for both Win and Match Odds market types.
#' listMarketCatalogue(eventTypeIds = c("7","1"),
#'                     marketCountries = "GB",
#'                     marketTypeCodes = c("WIN", "MATCH_ODDS")
#'                     )
#'
#' # Return market catalogues for all football matches currently inplay,
#' restricted to Match Odds market types and sorted by the amount traded.
#' listMarketCatalogue(eventTypeIds = c("1"),marketTypeCodes = c("MATCH_ODDS"),
#'                    inPlayOnly = TRUE, MarketSort = "MAXIMUM_TRADED")
#' }
#'

listMarketCatalogue <-
  function(eventTypeIds, marketTypeCodes, maxResults = "200", fromDate = (format(Sys.time() -
                                                                                   7200, "%Y-%m-%dT%TZ")), toDate = (format(Sys.time() + 86400, "%Y-%m-%dT%TZ")),
           eventIds = NULL,competitionIds = NULL,marketIds =
             NULL,marketCountries = NULL,venues = NULL,bspOnly = NULL,turnInPlayEnabled =
             NULL,inPlayOnly = NULL,marketBettingTypes = NULL,
           withOrders = NULL,marketSort = NULL,marketProjection =
             c(
               "COMPETITION", "EVENT", "EVENT_TYPE", "RUNNER_DESCRIPTION", "RUNNER_METADATA", "MARKET_START_TIME"
             ),textQuery = NULL,sslVerify = TRUE) {
    options(stringsAsFactors = FALSE)

    listMarketCatalogueOps <-
      data.frame(jsonrpc = "2.0", method = "SportsAPING/v1.0/listMarketCatalogue", id = "1")

    listMarketCatalogueOps$params <-
      data.frame(filter = c(""), maxResults = c(maxResults))
    listMarketCatalogueOps$params$filter <-
      data.frame(marketStartTime = c(""))
    listMarketCatalogueOps$params$sort = marketSort

    if (!is.null(eventIds)) {
      listMarketCatalogueOps$params$filter$eventTypeIds <- list(eventIds)
    }

    if (!is.null(eventTypeIds)) {
      listMarketCatalogueOps$params$filter$eventTypeIds <-
        list(eventTypeIds)
    }

    if (!is.null(competitionIds)) {
      listMarketCatalogueOps$params$filter$competitionIds <-
        list(competitionIds)
    }

    if (!is.null(marketIds)) {
      listMarketCatalogueOps$params$filter$marketIds <- list(marketIds)
    }

    if (!is.null(venues)) {
      listMarketCatalogueOps$params$filter$venues <- list(venues)
    }

    if (!is.null(marketCountries)) {
      listMarketCatalogueOps$params$filter$marketCountries <-
        list(marketCountries)
    }

    if (!is.null(marketTypeCodes)) {
      listMarketCatalogueOps$params$filter$marketTypeCodes <-
        list(marketTypeCodes)
    }

    listMarketCatalogueOps$params$filter$bspOnly <- bspOnly
    listMarketCatalogueOps$params$filter$turnInPlayEnabled <-
      turnInPlayEnabled
    listMarketCatalogueOps$params$filter$inPlayOnly <- inPlayOnly
    listMarketCatalogueOps$params$filter$textQuery <- textQuery

    if (!is.null(marketBettingTypes)) {
      listMarketCatalogueOps$params$filter$marketBettingTypes <-
        list(marketBettingTypes)
    }

    if (!is.null(withOrders)) {
      listMarketCatalogueOps$params$filter$withOrders <- list(withOrders)
    }

    listMarketCatalogueOps$params$filter$marketStartTime <-
      data.frame(from = fromDate, to = toDate)

    if (!is.null(marketProjection))  {
      listMarketCatalogueOps$params$marketProjection <-
        list(marketProjection)
    }

    listMarketCatalogueOps <-
      listMarketCatalogueOps[c("jsonrpc", "method", "params", "id")]

    listMarketCatalogueOps <-
      jsonlite::toJSON(listMarketCatalogueOps, pretty = TRUE)

    # Read Environment variables for authorisation details
    product <- Sys.getenv('product')
    token <- Sys.getenv('token')

    headers <- list(
      'Accept' = 'application/json', 'X-Application' = product, 'X-Authentication' = token, 'Content-Type' = 'application/json'
    )

    listMarketCatalogue <-
      as.list(jsonlite::fromJSON(
        RCurl::postForm(
          "https://api.betfair.com/exchange/betting/json-rpc/v1", .opts = list(
            postfields = listMarketCatalogueOps, httpheader = headers, ssl.verifypeer = sslVerify
          )
        )
      ))

    as.data.frame(listMarketCatalogue$result[1])
  }
