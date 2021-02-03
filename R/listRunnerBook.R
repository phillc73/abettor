#' Return listRunnerBook data
#'
#' \code{listRunnerBook} returns a list of dynamic data about a market and a
#' specified runner. Dynamic data includes prices, the status of the market,
#' the status of selections, the traded volume, and the status of any orders
#' you have placed in the market.
#'
#' \code{listRunnerBook} only takes one marketId and one selectionId in that
#' market per request. If the selectionId being passed in is not a valid one
#' or doesn’t belong in that market then the call will still work but only the
#' market data is returned.
#'
#' @seealso \code{\link{loginBF}}, which must be executed first. Do NOT use the
#'   DELAY application key. The DELAY application key does not support price
#'   data.
#'
#' @param marketId String. The market identification number of the required
#'   event. IDs can be obtained via \code{\link{listMarketCatalogue}}. Required.
#'   No default.
#'
#' @param selectionId String. The selection (runner) identification number of
#'   the required event. IDs can be obtained via \code{\link{listMarketCatalogue}}.
#'   Required. No default.
#'
#' @param handicap double. The handicap applied to the selection, if on an
#'  asian-style market. Optional. Defaults to 0, meaning no handicap.
#'  \code{handicap} must only be manually specified if betting on an Asian-style
#'  market.
#'
#' @param priceData String. Supports five price data types, one of which must be
#'   specified. Valid price data types are SP_AVAILABLE, SP_TRADED,
#'   EX_BEST_OFFERS, EX_ALL_OFFERS and EX_TRADED. Must be upper case. See note
#'   below explaining each of these options. Required. no default.
#'
#' @param bestPricesDepth integer. The maximum number of prices to return on
#'   each side for each runner. The default value is 3.
#'
#' @param rollupModel string. Determines the model to use when rolling up
#'   available sizes. The viable parameter values are "STAKE" (the volumes will
#'   be rolled up to the minimum value, which is >= rollupLimit); "PAYOUT" (the
#'   volumes will be rolled up to the minimum value, where the payout( price *
#'   volume ) is >= rollupLimit); "MANAGED_LIABILITY" (the volumes will be
#'   rolled up to the minimum value which is >= rollupLimit, until a lay price
#'   threshold. There after, the volumes will be rolled up to the minimum value
#'   such that the liability >= a minimum liability. Not supported as yet);
#'   "NONE" (No rollup will be applied. However the volumes will be filtered by
#'   currency specific minimum stake unless overridden specifically for the
#'   channel). The default value is NULL, which Betfair interprets as "STAKE".
#'
#' @param rollupLimit integer. The volume limit to use when rolling up returned
#'   sizes. The exact definition of the limit depends on the rollupModel.
#'   Ignored if no rollup model is specified. Optional. Default is NULL, which
#'   means it will use minimum stake as the default value.
#'
#' @param virtualise boolean. Indicates if the returned prices should include
#'   virtual prices. This is only applicable to EX_BEST_OFFERS and EX_ALL_OFFERS
#'   priceData selections. Default value is FALSE. Note that prices on website
#'   include virtual bets, so setting this parameter to FALSE may produce
#'   different results to manually checking the website. More information on
#'   virtual bets can be found here:
#'   \url{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Virtual+Bets}
#'
#' @param rolloverStakes boolean. Indicates if the volume returned at each price
#'   point should be the absolute value or a cumulative sum of volumes available
#'   at the price and all better prices. It is only applicable to EX_BEST_OFFERS
#'   and EX_ALL_OFFERS price projections. Optional. Default is FALSE. According
#'   to Betfair online documentation, this paramter is not supported as yet.
#'
#' @param orderProjection string. Restricts the results to the specified order
#'   status. Possible values are: "EXECUTABLE" (An order that has a remaining
#'   unmatched portion); "EXECUTION_COMPLETE" (An order that does not have any
#'   remaining unmatched portion); "ALL" (EXECUTABLE and EXECUTION_COMPLETE
#'   orders). Default value is NULL, which Betfair interprets as "ALL".
#'   Optional.
#'
#' @param matchProjection string. If orders are requested (see orderProjection),
#'   this specifies the representation of the matches. The three options are:
#'   "NO_ROLLUP" (no rollup, return raw fragments), "ROLLUP_BY_PRICE" (rollup
#'   matched amounts by distinct matched prices per side) and
#'   "ROLLED_UP_BY_AVG_PRICE" (rollup matched amounts by average matched price
#'   per side). Optional. Default is NULL.
#'
#' @param includeOverallPosition boolean. If you ask for orders, returns
#'   matches for each selection. Defaults to TRUE if unspecified.
#'
#' @param partitionMatchedByStrategyRef boolean. If you ask for orders, returns
#'   the breakdown of matches by strategy for each selection. Defaults to FALSE
#'   if unspecified.
#'
#' @param customerStrategyRefs vector String. If you ask for orders, restricts
#'   the results to orders matching any of the specified set of customer defined
#'   strategies. Also filters which matches by strategy for selections are
#'   returned, if partitionMatchedByStrategyRef is TRUE. An empty set will
#'   be treated as if the parameter has been omitted (or NULL passed).
#'
#' @param currencyCode String. A Betfair standard currency code. If not
#'   specified, the default currency code is used. Default is NULL.
#'   Optional.
#'
#' @param locale String. The language to be used where applicable. If not
#'   specified, the customer account default is returned. Default is NULL.
#'   Optional.
#'
#' @param matchedSince Date. If you ask for orders, restricts the results
#'   to orders that have at least one fragment matched since the specified
#'   date (all matched fragments of such an order will be returned even if
#'   some were matched before the specified date). All EXECUTABLE orders will
#'   be returned regardless of matched date. Default is 24 hours prior to
#'   current time. Format is \%Y-\%m-\%dT\%TZ, tz = "UTC". Times must be
#'   submitted in UTC as this is what is used by Betfair.
#'
#' @param betIds vector String. If you ask for orders, restricts the results
#'   to orders with the specified bet IDs. Omitting this parameter means that
#'   all bets will be included in the response. Please note: A maximum of 250
#'   betIds can be  provided at a time.
#'
#' @param suppress Boolean. By default, this parameter is set to FALSE, meaning
#'   that a warning is posted when the listRunnerBook call throws an error.
#'   Changing this parameter to TRUE will suppress this warning.
#'
#' @param sslVerify Boolean. This argument defaults to TRUE and is optional. In
#'   some cases, where users have a self signed SSL Certificate, for example
#'   they may be behind a proxy server, Betfair will fail login with "SSL
#'   certificate problem: self signed certificate in certificate chain". If this
#'   error occurs you may set sslVerify to FALSE. This does open a small
#'   security risk of a man-in-the-middle intercepting your login credentials.
#'
#' @return Response from Betfair is stored in listRunnerBook variable, which is
#'   then parsed from JSON as a list. Only the first item of this list contains
#'   the required event type identification details. The runners column includes
#'   various lists of price information, which may need to be reformatted (e.g.
#'   converted to data frames) depending on the user's circumstances. If the
#'   listRunnerBook call throws an error, a data frame containing error
#'   information is returned.
#'
#' @section Notes on \code{priceData} options: There are three options for this
#'   argument and one of them must be specified. All upper case letters must be
#'   used. \describe{ \item{SP_AVAILABLE}{Amount available for the Betfair
#'   Starting Price (BSP) auction.} \item{SP_TRADED}{Amount traded in the
#'   Betfair Starting Price (BSP) auction. Zero returns if the event has not yet
#'   started.} \item{EX_BEST_OFFERS}{Only the best prices available for each
#'   runner.} \item{EX_ALL_OFFERS}{EX_ALL_OFFERS trumps EX_BEST_OFFERS if both
#'   settings are present} \item{EX_TRADED}{Amount traded in this market on the
#'   Betfair exchange.}}
#'
#' @section Note on \code{listRunnerBookOps} variable: The
#'   \code{listRunnerBookOps} variable is used to firstly build an R data frame
#'   containing all the data to be passed to Betfair, in order for the function
#'   to execute successfully. The data frame is then converted to JSON and
#'   included in the HTTP POST request.
#'
#' @examples
#' \dontrun{
#' # Return all data on the requested runner This actual market and
#' selection ID is unlikely to work and is just for demonstration purposes.
#' listRunnerBook(marketId = "1.178523057", selectionId = 48470)
#' }
#'

listRunnerBook <- function(marketId, selectionId, handicap = NULL,
                           priceProjection = NULL, priceData = NULL,
                           bestPricesDepth = 3, rollupModel = NULL,
                           rollupLimit = NULL, virtualise = FALSE,
                           rolloverStakes = FALSE, orderProjection = NULL,
                           matchProjection = NULL, includeOverallPosition = TRUE,
                           partitionMatchedByStrategyRef = FALSE,
                           customerStrategyRefs = NULL, currencyCode = NULL,
                           locale = NULL,
                           matchedSince = (format(Sys.time() -86400, "%Y-%m-%dT%TZ", tz = "UTC")),
                           betIds = NULL, suppress = FALSE, sslVerify = TRUE) {
  options(stringsAsFactors = FALSE)

  listRunnerBookOps <-
    data.frame(jsonrpc = "2.0", method = "SportsAPING/v1.0/listRunnerBook", id = "1")

  listRunnerBookOps$params <-
    data.frame(
      marketId = c("")
    )
  listRunnerBookOps$params$marketId = marketId
  listRunnerBookOps$params$selectionId = selectionId
  listRunnerBookOps$params$priceProjection <-
    data.frame(
      virtualise = virtualise, rolloverStakes = rolloverStakes
    )
  if (!is.null(priceData)) {
    listRunnerBookOps$params$priceProjection$priceData <-
      list(priceData)
  }

  listRunnerBookOps$params$handicap <- handicap
  listRunnerBookOps$params$priceProjection$exBestOfferOverRides <-
    data.frame(
      bestPricesDepth = bestPricesDepth
    )
  if (!is.null(rollupModel)) {
    listRunnerBookOps$params$priceProjection$exBestOfferOverRides$rollupModel <- rollupModel
  }
  if (!is.null(orderProjection)) {
    listRunnerBookOps$params$OrderProjection <- list(orderProjection)
  }
  if (!is.null(matchProjection)) {
    listRunnerBookOps$params$MatchProjection <- list(matchProjection)
  }
  listRunnerBookOps$params$includeOverallPosition <- includeOverallPosition
  listRunnerBookOps$params$partitionMatchedByStrategyRef <- partitionMatchedByStrategyRef
  if (!is.null(customerStrategyRefs)) {
    listRunnerBookOps$params$customerStrategyRefs <- customerStrategyRefs
  }
  if (!is.null(locale)) {
    listRunnerBookOps$params$locale <- locale
  }
  if (!is.null(matchedSince)) {
    listRunnerBookOps$params$matchedSince <- matchedSince
  }

  if (!is.null(betIds)) {
    listRunnerBookOps$params$betIds <- betIds
  }

  listRunnerBookOps <-
    listRunnerBookOps[c("jsonrpc", "method", "params", "id")]

  listRunnerBookOps <-
    jsonlite::toJSON(jsonlite::unbox(listRunnerBookOps))

  # Read Environment variables for authorisation details
  product <- Sys.getenv('product')
  token <- Sys.getenv('token')

  listRunnerBook <- httr::content(
    httr::POST(url = "https://api.betfair.com/exchange/betting/json-rpc/v1",
               config = httr::config(ssl_verifypeer = sslVerify),
               body = listRunnerBookOps,
               httr::add_headers(Accept = "application/json",
                                 "X-Application" = product,
                                 "X-Authentication" = token)), as = "text", encoding = "UTF-8")

  listRunnerBook <- jsonlite::fromJSON(listRunnerBook)

  if(is.null(listRunnerBook$error))
    as.data.frame(listRunnerBook$result)
  else({
    if(!suppress)
      warning("Error- See output for details")
    as.data.frame(listRunnerBook$error)})
}

