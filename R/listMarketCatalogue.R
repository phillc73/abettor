#' Return listMarketCatalogue data
#'
#' \code{listMarketCatalogue} returns in-depth market data.
#'
#' \code{listMarketCatalogue} returns in-depth market data and can be filtered
#' via the API-NG based on a number of arguments. Using Horse Racing as an
#' example, complete race cards are returned for the specified markets. No
#' pricing data is returned via \code{listMarketCatalogue}. While there are many
#' potential arguments available via the Betfair API-NG, in order to limit
#' returns, only minimal options are provided in this function. Instead, the
#' user is expected to filter the resultant data frame directly in their R
#' development environment, using tools and terms with which they are familiar.
#' By default \code{listMarketCatalogue} returns are limited to the forthcoming
#' 24-hour period. However, this can be changed by user specified date/time
#' stamps.
#'
#' The output of \code{listMarketCatalogue} is complex and contains all data
#' about the requested markets, apart from price. A full description of this
#' output may be found here:
#'
#' \url{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Betting+Type+Definitions#BettingTypeDefinitions-MarketCatalogue}
#'
#' @seealso \code{\link{loginBF}}, which must be executed first.
#'
#' @param eventTypeIds String. Restrict markets by event type associated with
#'   the market. (i.e., Football, Horse Racing, etc). Accepts multiple IDs (See
#'   examples). IDs can be obtained via \code{\link{listEventTypes}}. Required.
#'   No default.
#' @param marketCountries String. Restrict to markets that are in the specified
#'   country or countries. Accepts multiple country codes (See examples). Codes
#'   can be obtained via \code{\link{listCountries}}, Required. No default.
#' @param marketTypeCodes String. Restrict to markets that match the type of the
#'   market (i.e. MATCH_ODDS, HALF_TIME_SCORE). You should use this instead of
#'   relying on the market name as the market type codes are the same in all
#'   locales. Accepts multiple market type codes (See examples). Market codes
#'   can be obtained via \code{\link{listMarketTypes}}, Required. No default.
#' @param maxResults Integer. Limit on the total number of results returned,
#'   must be greater than 0 and less than or equal to 1000. Optional. If not
#'   defined, defaults to 200.
#' @param fromDate The start date from which to return matching events. Format
#'   is \%Y-\%m-\%dT\%TZ. Optional. If not defined defaults to current system
#'   date and time.
#' @param toDate The end date to stop returning matching events. Format is
#'   \%Y-\%m-\%dT\%TZ. Optional. If not defined defaults to current system
#'   date and time plus 24 hours.
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
#' listMarketCatalogue(eventTypeIds = "7", marketCountries = c("GB", "IE"), marketTypeCodes = "WIN")
#'
#' # Return market catalogues for the Horse Racing event type, in only Great
#' Britain, but both Win and Place markets.
#' listMarketCatalogue(eventTypeIds = "7", marketCountries = "GB", marketTypeCodes = c("WIN", "PLACE"))
#'
#' # Return market catalogues for both Horse Racing and Football event types, in
#' Great Britain only and for both Win and Match Odds market types.
#' listMarketCatalogue(eventTypeIds = c("7","1"),
#'                     marketCountries = "GB",
#'                     marketTypeCodes = c("WIN", "MATCH_ODDS")
#'                     )
#' }
#'

listMarketCatalogue <- function(eventTypeIds, marketCountries, marketTypeCodes, maxResults = "200", fromDate = (format(Sys.time(), "%Y-%m-%dT%TZ")), toDate = (format(Sys.time() + 86400, "%Y-%m-%dT%TZ"))){

  options(stringsAsFactors=FALSE)
  listMarketCatalogueOps <- data.frame(jsonrpc = "2.0", method = "SportsAPING/v1.0/listMarketCatalogue", id = "1")

  listMarketCatalogueOps$params <- data.frame(filter = c(""), maxResults = c(maxResults), marketProjection = c(""))
  listMarketCatalogueOps$params$filter <- data.frame(eventTypeIds = c(""), marketCountries = c(""), marketTypeCodes = c(""), marketStartTime = c(""))

  listMarketCatalogueOps$params$filter$eventTypeIds <- list(eventTypeIds)
  listMarketCatalogueOps$params$filter$marketCountries <- list(marketCountries)
  listMarketCatalogueOps$params$filter$marketTypeCodes <- list(marketTypeCodes)
  listMarketCatalogueOps$params$filter$marketStartTime <- data.frame(from = fromDate, to = toDate)
  listMarketCatalogueOps$params$marketProjection <- list(c("COMPETITION", "EVENT", "EVENT_TYPE", "RUNNER_DESCRIPTION", "RUNNER_METADATA", "MARKET_START_TIME"))

  listMarketCatalogueOps <- listMarketCatalogueOps[c("jsonrpc", "method", "params", "id")]

  listMarketCatalogueOps <- jsonlite::toJSON(listMarketCatalogueOps, pretty = TRUE)

  listMarketCatalogue <- as.list(jsonlite::fromJSON(RCurl::postForm("https://api.betfair.com/exchange/betting/json-rpc/v1", .opts=list(postfields=listMarketCatalogueOps, httpheader=headersPostLogin))))

  as.data.frame(listMarketCatalogue$result[1])

}
