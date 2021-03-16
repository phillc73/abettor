#'Places an order on the Betfair exchange.
#'
#'\code{placeOrders} places an order (single bet or multiple bets) on the
#'Betfair betting exchange.
#'
#'\code{placeOrders} places an order (bet) on the Betfair betting exchange. When
#'using this function, be careful not to have logged in with your "DELAY"
#'application key. It is not possible to place bets with the DELAY application
#'key. Executing this function, after a successful login, will place real money
#'bets on the Betfair betting exchange. You do this at your own risk. The author
#'of this package accepts no responsibility if things go wrong. Be careful!
#'Running tests, by placing small bets, is not only a good idea to begin with,
#'it will also probably save you money.
#'
#'\code{placeOrders can only place bets on a single market per call. Variable
#'  relating to the market are single values. All other variables relate to the
#'  orders and are vectors which must all be the same length.}
#'
#'@seealso \code{\link{loginBF}}, which must be executed first. Do NOT use the
#'  DELAY application key. The DELAY application key does not support placing
#'  bets.
#'
#'@param marketId String. The market ID these orders are to be placed on. Can
#'  currently only accept a single market ID. IDs can be obtained via
#'  \code{\link{listMarketCatalogue}}. Required. No default.
#'@param selectionId List<Integer>. A list containing the selection ids of the
#'  desired item to bet on. If betting on a Horse Race, this will be a single
#'  number to identify a horse. In a Football match, this will be a single ID
#'  for one team. IDs can be obtained via \code{\link{listMarketCatalogue}}.
#'  Required. No default.
#'@param betSide List<String>. Each item in the list must specify whether the
#'  bet is BACK or LAY. Must be upper case. See note below explaining each of
#'  these options. Required. No default.
#'@param betType List<String>. Supports three order types, one of which must be
#'  specified for each element of the list. Valid order types are LIMIT,
#'  LIMIT_ON_CLOSE and MARKET_ON_CLOSE. Must be upper case. See note below
#'  explaining each of these options. Required. Default is set to LIMIT. Required.
#'  No default.
#'@param betSize List<String>. The size of the bet in the currency of your account.
#'  Generally, the minimum size for GB accounts is 2 Pounds. Required. No default.
#'  Minimum bet and liability sizes can be found at:
#'  \url{https://docs.developer.betfair.com/display/1smk3cen4v3lu3yomq5qye0ni/Additional+Information#AdditionalInformation-CurrencyParameters}
#'@param reqPrice List<String>. The lowest price at which you wish to place your bet
#'  for each element of the list. If unmatched higher prices are available on the
#'  opposite side of the bet, your order will be matched at those higher prices.
#'  Required if any of your bets are LIMIT and LIMIT_ON_CLOSE bets. No default.
#'@param persistenceType List<String>. What to do with the order, when the market
#'  turns in-play for each element in the list. Supports three persistence types,
#'  one of which must be specified. Valid persistence types are LAPSE, PERSIST and
#'  MARKET_ON_CLOSE. Must be upper case. See note below explaining each of these
#'  options. Required. Default is set to LAPSE.
#'@param handicap List<String>. The handicap applied to the selection, if on an
#'  asian-style market. Optional. Defaults to 0, meaning no handicap.
#'  \code{handicap} must only be manually specified if betting on an asian-style
#'  market.
#'@param customerRef String. Optional parameter allowing the client to pass a
#'  unique string (up to 32 chars) that is used to de-dupe mistaken
#'  re-submissions. CustomerRef can contain: upper/lower chars, digits, chars :
#'  - . _ + * : ; ~ only. Optional. Defaults to current system date and time.
#'@param marketVersion Integer. Optional parameter allowing the client to specify
#'  which version of the market the orders should be placed on. If the current
#'  market version is higher than that sent on an order, the bet will be lapsed.
#'@param customerStrategyRef String. An optional reference customers can use
#'  to specify which strategy has sent the order. The reference will be returned
#'  on order change messages through the stream API. The string is limited to
#'  15 characters. If an empty string is provided it will be treated as \code{NULL}.
#'@param async Boolean. An optional flag (not setting equates to \code{FALSE}) which
#'  specifies if the orders should be placed asynchronously. Where this is set to
#'  \code{TRUE}, orders can be tracked via the Exchange Stream API or or the API-NG
#'  by providing a \code{customerOrderRef} for each place order. An order's status
#'  will be \code{PENDING} and no \code{betId} will be returned. This functionality
#'  is available for all bet types - including MARKET_ON_CLOSE and LIMIT_ON_CLOSE.
#'@param customerOrderRef List<String>. An optional reference customers can set to
#'  identify inndividual orders within the instruction list. No validation will be
#'  done on uniqueness and the string is limited to 32 characters. If an empty
#'  string is provided it will be treated as NULL.
#'@param timeInForce List<String>. Optional field for LIMIT orders. The type of
#'  \code{TimeInForce} value to use. This value takes precedence over any
#'  \code{persistenceType} value chosen. If this attribute is populated along
#'  with the \code{persistenceType} field, then the \code{persistenceType} will be
#'  ignored. When using \code{FILL_OR_KILL} for a LINE market the Volume Weighted
#'  Average Price (VWAP) functionality is disabled. Optional.
#'@param minFillSize List<Sring>. An optional field used for LIMIT orders if the
#'  \code{timeInForce} attribute is populated. If specified without
#'  \code{timeInForce} then this field is ignored. If no \code{minFillSize} is
#'  specified, the order is killed unless the entire size can be matched. If
#'  \code{minFillSize} is specified, the order is killed unless at least the
#'  \code{minFillSize} can be matched. The \code{minFillSize} cannot be greater
#'  than the order's \code{size}. If specified for a BetTargetType and
#'  FILL_OR_KILL order, then this value will be ignored. Optional.
#'@param betTargetType List <String>. An optional field for LIMIT orders to allow
#'  betting to a targeted \code{PAYOUT} or \code{BACKERS_PROFIT} level. It's
#'  invalid to specify both a \code{size} and \code{betTargetType}. Matching
#'  provides best execution at the requested price or better up to the payout or
#'  profit. If the bet is not matched completely and immediately, the remaining
#'  portion enters the unmatched pool of bets on the exchange. \code{betTargetType}
#'  bets are invalid for LINE markets. Optional.
#'@param betTargetSize List <String>. An optional field for LIMIT order which must
#'  be specified if \code{betTargetType} is specified for this order. The requested
#'  outcome size of either the payout or profit. This is named from the backer's
#'  perspective. For Lay bets the profit represents the bet's liability. Optional.
#'@param suppress Boolean. By default, this parameter is set to FALSE, meaning
#'  that a warning is posted when the placeOrders call throws an error. Changing
#'  this parameter to TRUE will suppress this warning.
#'@param sslVerify Boolean. This argument defaults to TRUE and is optional. In
#'  some cases, where users have a self signed SSL Certificate, for example they
#'  may be behind a proxy server, Betfair will fail login with "SSL certificate
#'  problem: self signed certificate in certificate chain". If this error occurs
#'  you may set sslVerify to FALSE. This does open a small security risk of a
#'  man-in-the-middle intercepting your login credentials.
#'
#'@return Response from Betfair is stored in listMarketCatalogue variable, which
#'  is then parsed from JSON as a list. Only the first item of this list
#'  contains the required event type identification details.
#'
#'@section Notes on \code{betType} options: There are three options for this
#'  argument and one of them must be specified. All upper case letters must be
#'  used. \describe{ \item{LIMIT}{A normal exchange limit order for immediate
#'  execution. Essentially a bet which will be either matched immediately if
#'  possible, or will wait unmatched until the event begins. It will then either
#'  remain open in play or expire, depending on \code{persistenceType}}
#'  \item{LIMIT_ON_CLOSE}{Limit order for the auction (SP). If the Starting
#'  Price (SP) is greater than the value specified in \code{reqPrice} and there
#'  is enough market volume, the bet will be matched when the event begins.}
#'  \item{MARKET_ON_CLOSE}{Market order for the auction (SP). The bet amount, as
#'  specified in \code{betSize}, will be matched at the Starting Price,
#'  regardless of price, assuming there is enough market volume.} }
#'
#'@section Notes on \code{betSide} options: There are just two options for this
#'  argument and one of them must be specified. All upper case letters must be
#'  used. \describe{ \item{BACK}{To back a team, horse or outcome is to bet on
#'  the selection to win.} \item{LAY}{To lay a team, horse, or outcome is to bet
#'  on the selection to lose.} }
#'
#'@section Notes on \code{persistenceType} options: There are three options for
#'  this argument and one of them must be specified. All upper case letters must
#'  be used. \describe{ \item{LAPSE}{Lapse the order when the market is turned
#'  in-play. Order is canceled if not matched prior to the market turning
#'  in-play.} \item{PERSIST}{Persist the order to in-play. The bet will be place
#'  automatically into the in-play market at the start of the event.}
#'  \item{MARKET_ON_CLOSE}{Put the order into the auction (SP) at turn-in-play.
#'  The bet amount, as specified in \code{betSize}, will be matched at the
#'  Starting Price, regardless of price, assuming there is enough market
#'  volume.} }
#'
#'@section Note on \code{listPlaceOrdersOps} variable: The
#'  \code{listPlaceOrdersOps} variable is used to firstly build an R data frame
#'  containing all the data to be passed to Betfair, in order for the function
#'  to execute successfully. The data frame is then converted to JSON and
#'  included in the httr::POST request. If the placeOrders call throws an error,
#'  a data frame containing error information is returned.
#'
#' @examples
#' \dontrun{
#' placeOrders(marketId = "yourMarketId",
#'             selectionId = "yourSelectionId",
#'             betSide = "BACKORLAY",
#'             betType = "LIMITORONCLOSE",
#'             betSize = "2",
#'             reqPrice = "yourRequestedPrice",
#'             persistenceType = "LAPSEORPERSIST")
#'
#' # Note: The following call should be applied carefully, as incorrect indexing of the
#' # betSide vector (i.e. mixing up the "BACK" and "LAY" positions) will lead to
#' # mismatching of size, price and type fields.

#' # Placing orders across the three order types with a single instruction:
#' placeOrders(marketId = "1.179179402",
#'             selectionId = c(36621856, 22370218, 38465945),
#'             betSide = c("BACK", "LAY", "LAY"),
#'             betType = c("LIMIT", "LIMIT_ON_CLOSE", "MARKET_ON_CLOSE"),
#'             betSize = c(5, 10, 10),
#'             reqPrice = c(4,5, 5, 0),
#'             persistenceType = c("LAPSE", "LAPSE", "LAPSE"))
#'
#' # Place a LIMIT_ON_CLOSE lay bet on a selection on a horse racing market (note that
#' # LIMIT_ON_CLOSE orders only work on markets with Betfair Starting Price (BSP)
#' # enabled):
#'
#' placeOrders(marketId = "1.124156004",
#'             selectionId = "8877720", betType = "LIMIT_ON_CLOSE",
#'             betSide="LAY",
#'             betSize ="10",
#'             reqPrice = "1.1")
#'
#' # Place a MARKET_ON_CLOSE lay bet on a selection on a horse racing market (note that
#' # LIMIT_ON_CLOSE orders only work on markets with Betfair Starting Price (BSP)
#' # enabled):
#'
#' placeOrders(marketId = "1.124156004",
#'             selectionId = "8877720",
#'             betType = "MARKET_ON_CLOSE",
#'             betSide="LAY",
#'             betSize ="10")
#'
#' # Note that in both MARKET_ON_CLOSE and LIMIT_ON_CLOSE orders, the betSize parameter
#' # specifies the liability of the order. For example, a LIMIT_ON_CLOSE order of betSize=2
#' # and reqPrice = 1.1 is equivalent to a lay bet of 100 at 1.1 (i.e. max liability of
#' # 10 and a minimum profit of 100 if the selection doesn't win).
#'
#' # Place one single lay LIMIT bet on a specific selection on a specific market,
#' # which is set to LAPSE:
#'
#' placeOrders(marketId = "1.123982139",
#'             selectionId = "58805",
#'             betSide  = "LAY",
#'             betSize = "2",
#'             reqPrice = "1.1")
#'
#' # Place two lay bet at different prices on the same selection in the same market:
#'
#' placeOrders(marketId = "1.123982139",
#'             selectionId = "58805",
#'             betSide  = "LAY",
#'             betSize = "2",
#'             reqPrice = c("1.1","1.2"))
#'
#' # Place two lay bets of different sizes and at different prices on the same seleciton
#' # in the same market:
#'
#' placeOrders(marketId = "1.123982139",
#'             selectionId = "58805",
#'             betSide  = "LAY",
#'             betSize = c("2","3"),
#'             reqPrice = c("1.1","1.2"))
#'
#' # Place two lay bets of different sizes and at different prices on different
#' # selections on the same market:
#'
#' placeOrders(marketId = "1.123982139",
#'             selectionId = c("58805","68244"),
#'             betSide  = "LAY",
#'             betSize = c("2","3"),
#'             reqPrice = c("1.1","1.2"))
#'
#' # Place two lay bets (the first is set to "LAPSE", while the other will "PERSIST") of
#' # different sizes and at different prices on different selections on the same market:
#'
#' placeOrders(marketId = "1.123982139",
#'             selectionId = c("58805","68244"),
#'             betSide  = "LAY",
#'             betSize = c("2","3"),
#'             reqPrice = c("1.1","1.2"),
#'             persistenceType = c("LAPSE","PERSIST"))
#'
#' # Note: The following call should be applied carefully, as incorrect indexing of the
#' # betSide vector (i.e. mixing up the "BACK" and "LAY" positions) could cause
#' # significant problems
#'
#' # Place one back and one lay bet (the back is set to "LAPSE", while lay will "PERSIST") of
#' # different sizes and at different prices on different selections on the same market:
#'
#' placeOrders(marketId = "1.123982139",
#'             selectionId = c("58805","68244"),
#'             betSide  = c("BACK","LAY"), betSize = c("2","3"),
#'             reqPrice = c("10","1.2"),
#'             persistenceType = c("LAPSE","PERSIST"))
#'
#' }
#'

placeOrders <-
  function(marketId, selectionId, betSide, betSize, reqPrice,
           betType = "LIMIT",
           customerRef = (format(Sys.time(), "%Y-%m-%dT%TZ")),
           marketVersion = NULL, customerStrategyRef = NULL, async = FALSE,
           handicap = 0, customerOrderRef = NULL,
           timeInForce = NULL, minFillSize = 0,
           betTargetType = NULL, betTargetSize = 0,
           persistenceType = "LAPSE",
           suppress = FALSE, sslVerify = TRUE) {
    options(stringsAsFactors = FALSE)

    placeOrdersOps <-
      data.frame(jsonrpc = "2.0", method = "SportsAPING/v1.0/placeOrders", id = 1)

    #required fields
    placeOrdersOps$params <-
      data.frame(
        marketId = marketId,
        customerRef = customerRef
      )
    #optional fields
    if(!is.null(marketVersion)){
      placeOrdersOps$params$marketVersion <- marketVersion
    }
    if(!is.null(customerStrategyRef)){
      placeOrdersOps$params$customerStrategyRef <- customerStrategyRef
    }
    if(async){
      placeOrdersOps$params$async <- async
    }

    #Instructions
    #required fields
    insts <-
      data.frame(
        orderType = betType,
        selectionId = selectionId,
        side = betSide
      )
    #optional fields
    if(!(handicap == 0)){
      insts$handicap <- handicap
    }
    if(!is.null(customerOrderRef)){
      insts$customerOrderRef <- customerOrderRef
    }

    if("MARKET_ON_CLOSE" %in% betType) {
      insts$marketOnCloseOrder <-
        data.frame(liability = betSize)
    }

    if("LIMIT_ON_CLOSE" %in% betType) {
      insts$limitOnCloseOrder <-
        data.frame(liability = betSize, price = reqPrice)
    }

    #required fields
    if("LIMIT" %in% betType){
      insts$limitOrder <-
        data.frame(size = betSize,
                   price = reqPrice,
                   persistenceType = persistenceType
        )
      #optional fields
      if(!is.null(timeInForce)){
        cbind(insts$limitOrder,
              timeInForce = timeInForce,
              minFillSize = minFillSize)
      }
      if(!is.null(betTargetType)){
        cbind(insts$limitOrder,
              betTargetType = betTargetType,
              betTargetSize = betTargetSize)
      }
    }

    else {
      #required fields
      insts$limitOrder <-
        data.frame(size = betSize,
                   price = reqPrice,
                   persistenceType = persistenceType
        )
      #optional fields
      if(!is.null(timeInForce)){
        cbind(insts$limitOrder,
              timeInForce = timeInForce,
              minFillSize = minFillSize)
      }
      if(!is.null(betTargetType)){
        cbind(insts$limitOrder,
              betTargetType = betTargetType,
              betTargetSize = betTargetSize)
      }
    }

    placeOrdersOps$params$instructions <-
      list(insts)

    placeOrdersOps <-
      placeOrdersOps[c("jsonrpc", "method", "params", "id")]

    placeOrdersOps <- jsonlite::toJSON(jsonlite::unbox(placeOrdersOps))

    # Read Environment variables for authorisation details
    product <- Sys.getenv('product')
    token <- Sys.getenv('token')

    placeOrders <- httr::content(
      httr::POST(url = "https://api.betfair.com/exchange/betting/json-rpc/v1",
                 config = httr::config(ssl_verifypeer = sslVerify),
                 body = placeOrdersOps,
                 httr::add_headers(Accept = "application/json",
                                   "X-Application" = product,
                                   "X-Authentication" = token)), as = "text", encoding = "UTF-8")

    placeOrders <- jsonlite::fromJSON(placeOrders)

    if(is.null(placeOrders$error))
      as.data.frame(placeOrders$result)
    else({
      if(!suppress)
        warning("Error- See output for details")
      as.data.frame(placeOrders$error)})
  }
