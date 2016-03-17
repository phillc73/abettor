#' Return listMarketTypes data
#' 
#' \code{listMarketTypes} simply lists all available market types on the Betfair
#' exchange (e.g. number of Correct Score soccer markets closing in the next 24
#' hours). This data is useful for finding specific event identifiers, which are
#' then usually passed to further functions. By default, \code{listMarketTypes}
#' returns are limited to the forthcoming 24-hour period. However, this can be
#' changed by user specified date/time stamps.
#' 
#' @seealso \code{\link{loginBF}}, which must be executed first.
#'   
#' @param eventTypeIds vector <String>. Restrict market types by the event type
#'   associated with the market type. (e.g., Football = 1, Horse Racing = 7,
#'   etc). Accepts multiple IDs (See examples). IDs can be obtained via
#'   \code{\link{listEventTypes}}. Required. No default.
#'   
#' @param marketTypeCodes vector <String>. Restrict to market types that match
#'   the type of the market (i.e. MATCH_ODDS, HALF_TIME_SCORE). You should use
#'   this instead of relying on the market name as the market type codes are the
#'   same in all locales. Accepts multiple market type codes (See examples).
#'   Market type codes can be obtained via \code{\link{listMarketTypes}}.
#'   Optional. Default is NULL.
#'   
#' @param fromDate The start date from which to return matching market types.
#'   Format is \%Y-\%m-\%dT\%TZ. Optional. If not defined, it defaults to
#'   current system date and time minus 2 hours (to allow searching of all
#'   in-play football matches).
#'   
#' @param toDate The end date to stop returning matching market types. Format is
#'   \%Y-\%m-\%dT\%TZ. Optional. If not defined defaults to the current system 
#'   date and time plus 24 hours.
#'   
#' @param eventIds vector <String>. Restrict to market types that are associated
#'   with the specified eventIDs (e.g. "27675602"). Optional. Default is NULL.
#'   
#' @param competitionIds vector <String>. Restrict to market types that are
#'   associated with the specified competition IDs (e.g. EPL = "31", La Liga =
#'   "117"). Competition IDs can obtained via \code{\link{listCompetitions}}.
#'   Optional. Default is NULL.
#'   
#' @param marketIds vector <String>. Restrict to market types that are
#'   associated with the specified marketIDs (e.g. "1.122958246"). Optional.
#'   Default is NULL.
#'   
#' @param marketCountries vector <String>. Restrict to market types that are in
#'   the specified country or countries. Accepts multiple country codes (See 
#'   examples). Codes can be obtained via \code{\link{listCountries}}. Optional.
#'   Default is NULL.
#'   
#' @param venues vector <String>. Restrict market types by the venue associated
#'   with the market. This functionality is currently only available for horse
#'   racing markets (e.g.venues=c("Exeter","Navan")). Codes can be obtained 
#'   via \code{\link{listCountries}}  Optional. Default is NULL.
#'   
#' @param bspOnly Boolean. Restrict to betfair staring price (bsp) market types
#'   only if TRUE or non-bsp events if FALSE. Optional. Default is NULL, which
#'   means that both bsp and non-bsp events are returned.
#'   
#' @param turnInPlayEnabled Boolean. Restrict to market types that will turn in
#'   play if TRUE or will not turn in play if FALSE. Optional. Default is NULL,
#'   which means that both market types are returned.
#'   
#' @param inPlayOnly Boolean. Restrict to market types that are currently in
#'   play if TRUE or not inplay if FALSE. Optional. Default is NULL, which means
#'   that both inplay and non-inplay market types are returned.
#'   
#' @param marketBettingTypes vector <String>. Restrict to market types that
#'   match the betting type of the market (i.e. Odds, Asian Handicap Singles, or
#'   Asian Handicap Doubles). Optional. Default is NULL. See 
#'   \url{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Betting+Enums#BettingEnums-MarketBettingType}
#'    for a full list (and description) of viable parameter values.
#'   
#' @param withOrders String. Restrict to market types in which the user has bets
#'   of a specified status. The two viable values are "EXECUTION_COMPLETE" (an
#'   order that does not have any remaining unmatched portion) and "EXECUTABLE"
#'   (an order that has a remaining unmatched portion). Optional. Default is
#'   NULL.
#'   
#' @param textQuery String. Restrict market types by any text associated with
#'   the event type, such as the Name, Event, Competition, etc. The string can
#'   include a wildcard (*) character as long as it is not the first character.
#'   Optional. Default is NULL.
#'   
#' @param suppress Boolean. By default, this parameter is set to FALSE, meaning 
#'   that a warning is posted when the listMarketTypes call throws an error.
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
#' @return Response from Betfair is stored in the listMarketTypes variable,
#'   which is then parsed from JSON as a list. Only the first item of this list
#'   contains the required event type identification details. If the
#'   listMarketTypes call throws an error, a data frame containing error
#'   information is returned.
#'   
#' @section Note on \code{listMarketTypesOps} variable: The
#'   \code{listMarketTypesOps} variable is used to firstly build an R data frame
#'   containing all the data to be passed to Betfair, in order for the function
#'   to execute successfully. The data frame is then converted to JSON and
#'   included in the HTTP POST request.
#'   
#' @examples
#' \dontrun{
#' # Return all football and horse racing market types (and number of
#' corresponding markets) for the upcoming day.
#' listMarketTypes(eventTypeIds = c("1","7"))
#' 
#' # Return football market types that currently have at least one event inplay.
#' listMarketTypes(eventTypeIds = c("1"),inPlayOnly=TRUE)
#' 
#' # Return upcoming football market types that allow Betfair starting prices (BSPs).
#' listMarketTypes(eventTypeIds = c("1"),bspOnly=TRUE)
#' }
#' 

listMarketTypes <-
  function(eventTypeIds , marketTypeCodes=NULL,
           fromDate = (format(Sys.time() -7200, "%Y-%m-%dT%TZ")),
           toDate = (format(Sys.time() + 86400, "%Y-%m-%dT%TZ")),
           eventIds = NULL, competitionIds = NULL, marketIds =NULL,
           marketCountries = NULL, venues = NULL, bspOnly = NULL,
           turnInPlayEnabled = NULL, inPlayOnly = NULL, marketBettingTypes = NULL,
           withOrders = NULL, textQuery = NULL, suppress = FALSE, sslVerify = TRUE) {
    options(stringsAsFactors = FALSE)
    
    listMarketTypesOps <-
      data.frame(jsonrpc = "2.0", method = "SportsAPING/v1.0/listMarketTypes", id = "1")
    
    listMarketTypesOps$params <-
      data.frame(filter = c(""))
    listMarketTypesOps$params$filter <-
      data.frame(marketStartTime = c(""))
    
    if (!is.null(eventIds)) {
      listMarketTypesOps$params$filter$eventIds <- list(eventIds)
    }
    
    if (!is.null(eventTypeIds)) {
      listMarketTypesOps$params$filter$eventTypeIds <-
        list(eventTypeIds)
    }
    
    if (!is.null(competitionIds)) {
      listMarketTypesOps$params$filter$competitionIds <-
        list(competitionIds)
    }
    
    if (!is.null(marketIds)) {
      listMarketTypesOps$params$filter$marketIds <- list(marketIds)
    }
    
    if (!is.null(venues)) {
      listMarketTypesOps$params$filter$venues <- list(venues)
    }
    
    if (!is.null(marketCountries)) {
      listMarketTypesOps$params$filter$marketCountries <-
        list(marketCountries)
    }
    
    if (!is.null(marketTypeCodes)) {
      listMarketTypesOps$params$filter$marketTypeCodes <-
        list(marketTypeCodes)
    }
    
    listMarketTypesOps$params$filter$bspOnly <- bspOnly
    listMarketTypesOps$params$filter$turnInPlayEnabled <-
      turnInPlayEnabled
    listMarketTypesOps$params$filter$inPlayOnly <- inPlayOnly
    listMarketTypesOps$params$filter$textQuery <- textQuery
    
    if (!is.null(marketBettingTypes)) {
      listMarketTypesOps$params$filter$marketBettingTypes <-
        list(marketBettingTypes)
    }
    
    if (!is.null(withOrders)) {
      listMarketTypesOps$params$filter$withOrders <- list(withOrders)
    }
    
    listMarketTypesOps$params$filter$marketStartTime <-
      data.frame(from = fromDate, to = toDate)
    
    
    listMarketTypesOps <-
      listMarketTypesOps[c("jsonrpc", "method", "params", "id")]
    
    listMarketTypesOps <-
      jsonlite::toJSON(listMarketTypesOps, pretty = TRUE)
    
    # Read Environment variables for authorisation details
    product <- Sys.getenv('product')
    token <- Sys.getenv('token')
    
    
    headers <- list(
      'Accept' = 'application/json', 'X-Application' = product, 'X-Authentication' = token, 'Content-Type' = 'application/json'
    )
    
    listMarketTypes <-
      as.list(jsonlite::fromJSON(
        RCurl::postForm(
          "https://api.betfair.com/exchange/betting/json-rpc/v1", .opts = list(
            postfields = listMarketTypesOps, httpheader = headers, ssl.verifypeer = sslVerify
          )
        )
      ))
    
    if(is.null(listMarketTypes$error))
      as.data.frame(listMarketTypes$result[1])
    else({
      if(!suppress)
        warning("Error- See output for details")
      as.data.frame(listMarketTypes$error)})
  }
