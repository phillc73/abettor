#'Places an order on Betfair
#'
#'\code{placeOrders} places an order (single bet or multiple bets) on a single
#'market on the Betfair betting exchange.
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
#'\code{placeOrders} has parameters which relate to the market, then a list of
#'instructions for the bets to be placed. Each instruction also requires order
#'information, with the format depending on the type of order. This structure
#'is described in more detail below and demonstrated in the examples. There are
#'no default values set by the function. The only default values are those that
#'are set as blank, NULL or zero by the Betfair operation.
#'
#'@seealso \code{\link{loginBF}}, which must be executed first. Do NOT use the
#'  DELAY application key. The DELAY application key does not support placing
#'  bets.
#'
#'\title{Market fields}
#'@param marketId String. The market ID these orders are to be placed on. Can
#'  currently only accept a single market ID. IDs can be obtained via
#'  \code{\link{listMarketCatalogue}}. Required. No default.
#'@param customerRef String. Optional parameter allowing the client to pass a
#'  unique string (up to 32 chars) that is used to de-dupe mistaken
#'  re-submissions. \code{customerRef} can contain: upper/lower chars, digits, chars :
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
#'  is available for all bet types - including MARKET_ON_CLOSE and LIMIT_ON_CLOSE.                                      .
#'
#'\title{Instruction List}
#'@param instructionList Data frame. The format required for this data frame mirrors
#'  the structure required by the function and is outlined in
#'  \url{https://docs.developer.betfair.com/display/1smk3cen4v3lu3yomq5qye0ni/placeOrders#placeOrders-Operation}
#'  The data frame contains columns relating to the instructions and must also
#'  contain at least one data frame which contains order details. The data frame must be of
#'  type \code{limitOrder}, \code{limitOnCloseOrder} or \code{marketOnCloseOrder}
#'  depending on the type of orders being placed. These are outlined below. If the
#'  instruction list contains multiple order types then it must include a dataframe
#'  for each order type. A worked example is also provided on how to build the data frame.
#'@param orderType List <String>. A column of the \code{instructionList}
#'  data frame. It supports three order types, one of which must be specified for each
#'  element of the list. Valid order types are \code{LIMIT}, \code{LIMIT_ON_CLOSE}
#'  and \code{MARKET_ON_CLOSE}. Must be upper case. See note below explaining
#'  each of these options. Required. No default. If any element is set to an order
#'  type then there must be a corresponding data frame included in the
#'  \code{\link{instructionList}} data frame with order information. For example,
#'  if one element of the vector is equal to "MARKET_ON_CLOSE" then a
#'  \code{marketOnCloseOrder} data frame must be included.
#'@param selectionId List<String>. A column of the \code{instructionList}
#'  data frame.The list contains the selectionId of the desired item to bet
#'  on. If betting on a Horse Race, each element will be a single number to
#'  identify a horse. In a Football match, each element will be a single ID for
#'  one team. IDs can be obtained via \code{\link{listMarketCatalogue}}. Required.
#'  No default.
#'@param handicap List<String>. A column of the \code{instructionList}
#'  data frame. The handicap applied to the selection, if on an
#'  asian-style market. Optional. Defaults to 0, meaning no handicap.
#'  \code{handicap} must only be manually specified if betting on an asian-style
#'  market.
#'@param side List<String>. A column of the \code{instructionList} data frame.
#'  Each item in the list must specify whether the bet is a \code{BACK} or \code{LAY}.
#'  Must be upper case. See note below explaining each of these options. Required.
#'  No default.
#'@param customerOrderRef List<String>. A column of the \code{instructionList}
#'  data frame. An optional reference customers can set to identify instructions.
#'  No validation will be done on uniqueness and the string is limited to 32
#'  characters. If an empty string is provided it will be treated as NULL.
#'
#'\title{Limit Order}
#'@param limitOrder Data frame. A data frame which is required to be included in the
#'  \code{instructionList} data frame when one or more orders are of the order type
#'  \code{LIMIT}. The following columns form part of the \code{LimitOrder} data frame.
#'@param size List<String>. A column of the \code{limitOrder} data frame. The size
#'  of the bet in the currency of your account. Generally, the minimum limit bet size
#'  for UK accounts is 2 Pounds. Required. No default.
#'@param price List<String>. A column of the \code{limitOrder} data frame. The limit
#'  price. For LINE markets, the price at which the bet is settled and struck will
#'  always be 2.0 (Evens). On these bets, the \code{price} field is used to indicate the
#'  line value which is being bought or sold.  Required. No default.
#'@param persistenceType List<String>. A column of the \code{limitOrder} data frame.
#'  What to do with the order when the market turns in-play. Supports three
#'  persistence types, one of which must be specified. Valid persistence types are
#'  \code{LAPSE}, \code{PERSIST} and \code{MARKET_ON_CLOSE}. Must be upper case.
#'  See note below explaining each of these options. Required. No default.
#'@param timeInForce List<String>. A column of the \code{limitOrder} data frame.
#'  The type of \code{TimeInForce} value to use. This value takes precedence over
#'  any \code{persistenceType} value chosen. If this attribute is populated along
#'  with the \code{persistenceType} field, then the \code{persistenceType} will be
#'  ignored. When using \code{FILL_OR_KILL} for a LINE market the Volume Weighted
#'  Average Price (VWAP) functionality is disabled. Optional.
#'@param minFillSize List<Sring>. A column of the \code{limitOrder} data frame.
#'  An optional field used if the \code{timeInForce} attribute is populated.
#'  If specified without \code{timeInForce} then this field is ignored. If no
#'  \code{minFillSize} is specified, the order is killed unless the entire size
#'  can be matched. If \code{minFillSize} is specified, the order is killed unless
#'  at least the \code{minFillSize} can be matched. The \code{minFillSize} cannot be
#'  greater than the order's \code{size}. If specified for a BetTargetType and
#'  FILL_OR_KILL order, then this value will be ignored. Optional.
#'@param betTargetType List <String>. A column of the \code{limitOrder} data frame.
#'  An optional field to allow betting to a targeted \code{PAYOUT} or
#'  \code{BACKERS_PROFIT} level. It's invalid to specify both a \code{size} and
#'  \code{betTargetType}. Matching provides best execution at the requested price
#'  or better up to the payout or profit. If the bet is not matched completely
#'  and immediately, the remaining portion enters the unmatched pool of bets on
#'  the exchange. \code{betTargetType} bets are invalid for LINE markets. Optional.
#'@param betTargetSize List <String>. A column of the \code{limitOrder} data frame.
#'  An optional field which must be specified if \code{betTargetType} is specified
#'  for this order. The requested outcome size of either the payout or profit. This
#'  is named from the backer's perspective. For Lay bets the profit represents the
#'  bet's liability. Optional.
#'
#'\title{Limit on close order}
#'@param limitOnCloseOrder Data frame. A data frame which is included in the
#'  instructionList data frame and is required when one or more orders are
#'  of the order type LIMIT_ON_CLOSE. The following columns form part of the
#'  LimitOnCloseOrder data frame.
#'@param liability List<String>. A column of the \code{limitOnCloseOrder} data frame.
#'  The size of the bet. Required. No default.
#'@param price List<String>. A column of the \code{limitOnCloseOrder} data frame.
#'  The limit price of the bet for a LIMIT_ON_CLOSE bet. Required. No default.
#'
#'\title{Market on close order}
#'@param marketOnCloseOrder Data frame. A data frame which is included in the
#'  instructionList data frame and is required when one or more orders are
#'  of the order type MARKET_ON_CLOSE. The following columns form part of the
#'  marketOnCloseOrder data frame.
#'@param liability List<String>. A column of the \code{marketOnCloseOrder} data frame.
#'  The size of the bet. Required. No default.
#'
#'@param suppress Boolean. By default, this parameter is set to FALSE, meaning
#'  that a warning is posted when the \code{placeOrders} call throws an error. Changing
#'  this parameter to TRUE will suppress this warning.
#'@param sslVerify Boolean. This argument defaults to TRUE and is optional. In
#'  some cases, where users have a self signed SSL Certificate, for example they
#'  may be behind a proxy server, Betfair will fail login with "SSL certificate
#'  problem: self signed certificate in certificate chain". If this error occurs
#'  you may set sslVerify to FALSE. This does open a small security risk of a
#'  man-in-the-middle intercepting your login credentials.
#'
#'@return Response from Betfair is stored in \code{placeOrders} variable, which
#'  is then parsed from JSON as a list. It contains a row for each order in the
#'  \code{instructionList}.
#'
#'@section Notes on \code{orderType} options: There are three options for this
#'  argument and one of them must be specified for each element in the list.
#'  All upper case letters must be used. \describe{ \item{LIMIT}{A normal exchange
#'  limit order for immediate execution. Essentially a bet which will be either
#'  matched immediately if possible, or will wait unmatched on the exchange until
#'  the event begins. It will then either remain open in play or expire, depending
#'  on the \code{persistenceType}}.
#'  \item{LIMIT_ON_CLOSE}{Limit order for the auction (SP). If the Starting
#'  Price (SP) is more favourable than the value specified in \code{price} and there
#'  is enough market volume, the bet will be matched when the event begins.}
#'  \item{MARKET_ON_CLOSE}{Market order for the auction (SP). The bet amount, as
#'  specified in \code{size}, will be matched at the Starting Price,
#'  regardless of price, assuming there is enough market volume.} }
#'
#'@section Notes on \code{side} options: There are two options for this
#'  argument and one of them must be specified. All upper case letters must be
#'  used. \describe{ \item{BACK}{To back a team, horse or outcome is to bet on
#'  the selection to win.} \item{LAY}{To lay a team, horse, or outcome is to bet
#'  on the selection to lose.} }
#'
#'@section Notes on \code{persistenceType} options: There are three options for
#'  this argument and one of them must be specified. All upper case letters must
#'  be used. \describe{ \item{LAPSE}{Lapse the order when the market is turned
#'  in-play. Order is canceled if not matched prior to the market turning
#'  in-play.} \item{PERSIST}{Persist the order to in-play. The bet will be placed
#'  automatically into the in-play market at the start of the event.}
#'  \item{MARKET_ON_CLOSE}{Put the order into the auction (SP) at turn-in-play.
#'  The bet amount, as specified in \code{size}, will be matched at the
#'  Starting Price, regardless of price, assuming there is enough market
#'  volume.} }
#'
#'@section Note on \code{listPlaceOrdersOps} variable: The
#'  \code{listPlaceOrdersOps} variable is used to build an R data frame
#'  containing all the data to be passed to Betfair. The data frame is then
#'  converted to JSON and included in the httr POST request. If the \code{placeOrders}
#'  call throws an error, a data frame containing error information is returned.
#'
#' @examples
#' \dontrun{
#'
#' # Placing orders across the three order types with a single instruction:
#' # First build the \code{limitOrders} data frame (if required):
#'
#' limitOrders <- data.frame(c(5, 0, 0), c(4.5, 0, 0), c("LAPSE","LAPSE","LAPSE"))
#' colnames(limitOrders) <- c("size", "price", "persistenceType")
#'  # not used: timeInForce, minFillSize, betTargetType, betTargetSize
#'
#' # Next build the \code{limitOnCloseOrders} data frame (if required):
#'
#' limitOnCloseOrders <- data.frame(c(0, 30, 0), c(0, 5, 0))
#' colnames(limitOnCloseOrders) <- c("liability", "price")
#'
#' # Then build the \code{marketOnCloseOrders} data frame (if required):
#'
#' marketOnCloseOrders <- data.frame(c(0, 0, 30))
#' colnames(marketOnCloseOrders) <- c("liability")
#'
#' # Build the instruction list data frame:
#'
#' insts <- data.frame(c("LIMIT", "LIMIT_ON_CLOSE", "MARKET_ON_CLOSE"), c(36621856, 22370218, 38465945),  c("BACK", "LAY", "LAY"))
#' colnames(insts) <- c("orderType", "selectionId",  "side")
#' # not used: handicap
#'
#' # The include the relevant data frames into the instruction list:
#'
#' insts$limitOrder <- limitOrders
#' insts$limitOnCloseOrder <- limitOnCloseOrders
#' insts$marketOnCloseOrder <- marketOnCloseOrders
#'
#' Now use \code{placeOrders} to place all three orders at once:
#'
#' placeOrders(marketId = "1.179179402", instructionList = insts)
#'
#' # Note that this order has used only the required fields. There are other fields that are not used
#' # abd these are shown in the comments in the above example.
#'
#' # Note that if the limitOrders data frame is included then it cannot be left blank,
#' # even for orders that are not limit orders.
#'
#' }
#'

placeOrdersDF <-
  function(marketId, instructionList,
           customerRef = (format(Sys.time(), "%Y-%m-%dT%TZ")),
           suppress = FALSE, sslVerify = TRUE) {
    options(stringsAsFactors = FALSE)

    placeOrdersOps <-
      data.frame(jsonrpc = "2.0", method = "SportsAPING/v1.0/placeOrders", id = 1)

    placeOrdersOps$params <-
      data.frame(
        marketId = marketId, instructions = c(""), customerRef = customerRef
      )

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

