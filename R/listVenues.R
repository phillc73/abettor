#' Return listVenues data
#' 
#' \code{listVenues} simply lists all venues associated with the selected 
#' parameters (e.g. horse racing venues with markets closing in the next 24 hours). 
#' Note: Currently, only horse racing markets are associated with a venue.
#' 
#' @seealso \code{\link{loginBF}}, which must be executed first.
#'   
#' @param eventTypeIds vector <String>. Restrict venues by event type 
#'   associated with the market. (e.g., Football = 1, Horse Racing = 7, etc). 
#'   Accepts multiple IDs. IDs can be obtained via 
#'   \code{\link{listEventTypes}}. Optional. Default is 7 (Horse Racing).
#'   
#' @param marketTypeCodes vector <String>. Restrict to venues that match the 
#'   type of the market (i.e. MATCH_ODDS, HALF_TIME_SCORE). You should use this 
#'   instead of relying on the market name as the market type codes are the same
#'   in all locales. Accepts multiple market type codes. Market type codes can be 
#'   obtained via \code{\link{listMarketTypes}}. Optional. Default is NULL.
#'   
#' @param fromDate The start date from which to return matching venues. 
#'   Format is \%Y-\%m-\%dT\%TZ. Optional. If not defined, it defaults to 
#'   current system date and time minus 2 hours (to allow searching of all 
#'   in-play football matches).
#'   
#' @param toDate The end date to stop returning matching venues. Format is 
#'   \%Y-\%m-\%dT\%TZ. Optional. If not defined defaults to the current system 
#'   date and time plus 24 hours.
#'   
#' @param eventIds vector <String>. Restrict to venues that are associated 
#'   with the specified eventIDs (e.g. "27675602"). Optional. Default is NULL.
#'   
#' @param competitionIds vector <String>. Restrict to market types that are 
#'   associated with the specified competition IDs (e.g. EPL = "31", La Liga = 
#'   "117"). Competition IDs can obtained via \code{\link{listCompetitions}}. 
#'   Optional. Default is NULL.
#'   
#' @param marketIds vector <String>. Restrict to venues that are associated 
#'   with the specified marketIDs (e.g. "1.122958246"). Optional. Default is 
#'   NULL.
#'   
#' @param marketCountries vector <String>. Restrict to venues that are in the
#'   specified country or venues. Accepts multiple country codes. Codes can 
#'   be obtained via \code{\link{listCountries}}. Optional. Default is NULL.
#'   
#' @param venues vector <String>. Restrict venues by the venue associated 
#'   with the market. This functionality is currently only available for horse 
#'   racing markets (e.g.venues=c("Exeter","Navan")). Optional. Default is NULL.
#'   
#' @param bspOnly Boolean. Restrict to betfair staring price (bsp) venues 
#'   only if TRUE or non-bsp events if FALSE. Optional. Default is NULL, which 
#'   means that both bsp and non-bsp venues are returned.
#'   
#' @param turnInPlayEnabled Boolean. Restrict to venues that will turn in 
#'   play if TRUE or will not turn in play if FALSE. Optional. Default is NULL, 
#'   which means that both venues are returned.
#'   
#' @param inPlayOnly Boolean. Restrict to venues that are currently in play 
#'   if TRUE or not inplay if FALSE. Optional. Default is NULL, which means that
#'   both inplay and non-inplay venues are returned.
#'   
#' @param marketBettingTypes vector <String>. Restrict to venues that match 
#'   the betting type of the market (i.e. Odds, Asian Handicap Singles, or Asian
#'   Handicap Doubles). Optional. Default is NULL. See 
#'   \url{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Betting+Enums#BettingEnums-MarketBettingType}
#'    for a full list (and description) of viable parameter values.
#'   
#' @param withOrders String. Restrict to venues in which the user has bets of
#'   a specified status. The two viable values are "EXECUTION_COMPLETE" (an 
#'   order that does not have any remaining unmatched portion) and "EXECUTABLE" 
#'   (an order that has a remaining unmatched portion). Optional. Default is 
#'   NULL.
#'   
#' @param textQuery String. Restrict venues by any text associated with the 
#'   event type, such as the Name, Event, Competition, etc. The string can 
#'   include a wildcard (*) character as long as it is not the first character. 
#'   Optional. Default is NULL.
#'   
#' @param suppress Boolean. By default, this parameter is set to FALSE, meaning 
#'   that a warning is posted when the listVenues call throws an error. 
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
#' @return Response from Betfair is stored in the listVenues variable, which 
#'   is then parsed from JSON as a list. Only the first item of this list 
#'   contains the required event type identification details. If the 
#'   listVenues call throws an error, a data frame containing error 
#'   information is returned.
#'   
#' @section Note on \code{listVenuesOps} variable: The 
#'   \code{listVenuesOps} variable is used to firstly build an R data frame 
#'   containing all the data to be passed to Betfair, in order for the function 
#'   to execute successfully. The data frame is then converted to JSON and 
#'   included in the HTTP POST request.
#'   
#' @examples
#' \dontrun{
#' # Return all horse racing venues (and number of 
#' corresponding markets) for the upcoming day.
#' listVenues()
#' 
#' # Return upcoming horse racing venues in Great Britain.
#' listVenues(marketCountries=("GB"))
#' 
#' # Return upcoming venues that allow Betfair starting prices (BSPs) on
#' specific horse racing markets.
#' listVenues(bspOnly=TRUE)
#' }
#' 

listVenues <-
  function(eventTypeIds = c("7") , marketTypeCodes=NULL,
           fromDate = (format(Sys.time() -7200, "%Y-%m-%dT%TZ")),
           toDate = (format(Sys.time() + 86400, "%Y-%m-%dT%TZ")),
           eventIds = NULL, competitionIds = NULL, marketIds =NULL,
           marketCountries = NULL, venues = NULL, bspOnly = NULL,
           turnInPlayEnabled = NULL, inPlayOnly = NULL, marketBettingTypes = NULL,
           withOrders = NULL, textQuery = NULL, suppress = FALSE, sslVerify = TRUE) {
    options(stringsAsFactors = FALSE)
    
    listVenuesOps <-
      data.frame(jsonrpc = "2.0", method = "SportsAPING/v1.0/listVenues", id = "1")
    
    listVenuesOps$params <-
      data.frame(filter = c(""))
    listVenuesOps$params$filter <-
      data.frame(marketStartTime = c(""))
    
    if (!is.null(eventIds)) {
      listVenuesOps$params$filter$eventIds <- list(eventIds)
    }
    
    if (!is.null(eventTypeIds)) {
      listVenuesOps$params$filter$eventTypeIds <-
        list(eventTypeIds)
    }
    
    if (!is.null(competitionIds)) {
      listVenuesOps$params$filter$competitionIds <-
        list(competitionIds)
    }
    
    if (!is.null(marketIds)) {
      listVenuesOps$params$filter$marketIds <- list(marketIds)
    }
    
    if (!is.null(venues)) {
      listVenuesOps$params$filter$venues <- list(venues)
    }
    
    if (!is.null(marketCountries)) {
      listVenuesOps$params$filter$marketCountries <-
        list(marketCountries)
    }
    
    if (!is.null(marketTypeCodes)) {
      listVenuesOps$params$filter$marketTypeCodes <-
        list(marketTypeCodes)
    }
    
    listVenuesOps$params$filter$bspOnly <- bspOnly
    listVenuesOps$params$filter$turnInPlayEnabled <-
      turnInPlayEnabled
    listVenuesOps$params$filter$inPlayOnly <- inPlayOnly
    listVenuesOps$params$filter$textQuery <- textQuery
    
    if (!is.null(marketBettingTypes)) {
      listVenuesOps$params$filter$marketBettingTypes <-
        list(marketBettingTypes)
    }
    
    if (!is.null(withOrders)) {
      listVenuesOps$params$filter$withOrders <- list(withOrders)
    }
    
    listVenuesOps$params$filter$marketStartTime <-
      data.frame(from = fromDate, to = toDate)
    
    
    listVenuesOps <-
      listVenuesOps[c("jsonrpc", "method", "params", "id")]
    
    listVenuesOps <-
      jsonlite::toJSON(listVenuesOps, pretty = TRUE)
    
    # Read Environment variables for authorisation details
    product <- Sys.getenv('product')
    token <- Sys.getenv('token')
    
    
    headers <- list(
      'Accept' = 'application/json', 'X-Application' = product, 'X-Authentication' = token, 'Content-Type' = 'application/json'
    )
    
    listVenues <-
      as.list(jsonlite::fromJSON(
        RCurl::postForm(
          "https://api.betfair.com/exchange/betting/json-rpc/v1", .opts = list(
            postfields = listVenuesOps, httpheader = headers, ssl.verifypeer = sslVerify
          )
        )
      ))
    
    if(is.null(listVenues$error))
      as.data.frame(listVenues$result[1])
    else({
      if(!suppress)
        warning("Error- See output for details")
      as.data.frame(listVenues$error)})
  }
