#'Places an order on Betfair
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
#'@seealso \code{\link{loginBF}}, which must be executed first. Do NOT use the
#'  DELAY application key. The DELAY application key does not support placing
#'  bets.
#'
#'@param marketId String. The market ID these orders are to be placed on. Can
#'  currently only accept a single market ID. IDs can be obtained via
#'  \code{\link{listMarketCatalogue}}. Required. No default.
#'@param selectionId String. The selection id of the desired item to bet on. If
#'  betting on a Horse Race, this will be a single number to identify a horse.
#'  In a Football match, this will be a single ID for one team. IDs can be
#'  obtained via \code{\link{listMarketCatalogue}}. Required. No default.
#'@param betSide Sting. Specififies whether the bet is a back or lay. This
#'  argument accepts one of two options - BACK or LAY. Must be upper case.See
#'  note below explaining each of these options. Required. No default.
#'@param betType String. Supports three order types, one of which must be
#'  specified. Valid order types are LIMIT, LIMIT_ON_CLOSE and MARKET_ON_CLOSE.
#'  Must be upper case. See note below explaining each of these options.
#'  Required. Default is set to LIMIT.
#'@param betSize String. The size of the bet in the currency of your account.
#'  Generally, the minimum size for GB accounts is 2 Pounds.
#'@param reqPrice String. The lowest price at which you wish to place your bet.
#'  If unmatched higher prices are available on the opposite side of the bet,
#'  your order will be matched at those higher prices. Required. No default.
#'@param persistenceType String. What to do with the order, when the market
#'  turns in-play. Supports three persistence types, one of which must be
#'  specified. Valid persistence types are LAPSE, PERSIST and MARKET_ON_CLOSE.
#'  Must be upper case. See note below explaining each of these options.
#'  Required. Default is set to LAPSE.
#'@param handicap String. The handicap applied to the selection, if on an
#'  asian-style market. Optional. Defaults to 0, meaning no handicap.
#'  \code{handicap} must only be manually specified if betting on an asian-style
#'  market.
#'@param customerRef String. Optional parameter allowing the client to pass a
#'  unique string (up to 32 chars) that is used to de-dupe mistaken
#'  re-submissions. CustomerRef can contain: upper/lower chars, digits, chars :
#'  - . _ + * : ; ~ only. Optional. Defaults to current system date and time.
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
#'  included in the HTTP POST request. If the placeOrders call throws an error,
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
#' # Place a LIMIT_ON_CLOSE lay bet on a selection on a horse racing market (note that
#' # LIMIT_ON_CLOSE orders only work on markets with Betfair Starting Price (BSP)
#' # enabled):
#'
#' placeOrders(marketId = "1.124156004",
#'             selectionId = "8877720", betType = "LIMIT_ON_CLOSE",
#'             betSide="LAY",
#'             betSize ="2",
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
#'             betSize ="2")
#'
#' # Note that in both MARKET_ON_CLOSE and LIMIT_ON_CLOSE orders, the betSize parameter
#' # specifies the liability of the order. For example, a LIMIT_ON_CLOSE order of betSize=2
#' # and reqPrice = 1.1 is equivalent to a lay bet of 20 at 1.1 (i.e. max liability of
#' # 2 and a minimum profit of 20 if the selection doesn't win).
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
           betType = "LIMIT", persistenceType = "LAPSE",
           handicap = "0", customerRef = (format(Sys.time(), "%Y-%m-%dT%TZ")),
           suppress = FALSE, sslVerify = TRUE) {
    options(stringsAsFactors = FALSE)

    placeOrdersOps <-
      data.frame(jsonrpc = "2.0", method = "SportsAPING/v1.0/placeOrders", id = 1)

    placeOrdersOps$params <-
      data.frame(
        marketId = marketId, instructions = c(""), customerRef = customerRef
      )

    if (betType == "MARKET_ON_CLOSE") {
      placeOrdersOps$params$instructions <-
        data.frame(
          selectionId = selectionId,
          handicap = handicap,
          side = betSide,
          orderType = betType,
          marketOnCloseOrder = c("")
        )

      placeOrdersOps$params$instructions$marketOnCloseOrder <-
        data.frame(liability = betSize)


    }
    else if (betType == "LIMIT_ON_CLOSE") {
      placeOrdersOps$params$instructions <-
        data.frame(
          selectionId = selectionId,
          handicap = handicap,
          side = betSide,
          orderType = betType,
          limitOnCloseOrder = c("")
        )

      placeOrdersOps$params$instructions$limitOnCloseOrder <-
        data.frame(liability = betSize, price = reqPrice)


    }

    else {
      instructions.data.frame <-
        data.frame(
          limitOrder = rep("",max(sapply(list(betSide,betSize,reqPrice,persistenceType),length)))
        )

      instructions.data.frame$limitOrder <-
        data.frame(price = reqPrice)
      instructions.data.frame$limitOrder$persistenceType <-
        persistenceType
      instructions.data.frame$limitOrder$size <- betSize

      instructions.data.frame$selectionId <- selectionId
      instructions.data.frame$handicap <- handicap
      instructions.data.frame$side <- betSide
      instructions.data.frame$orderType <- betType
    }
    if(betType == "LIMIT"){
    placeOrdersOps$params$instructions <-
      list(instructions.data.frame)}
    else(placeOrdersOps$params$instructions <-
           list(placeOrdersOps$params$instructions))

    placeOrdersOps <-
      placeOrdersOps[c("jsonrpc", "method", "params", "id")]

    placeOrdersOps <- jsonlite::toJSON(placeOrdersOps, pretty = TRUE)

    # Read Environment variables for authorisation details
    product <- Sys.getenv('product')
    token <- Sys.getenv('token')

    headers <- list(
      'Accept' = 'application/json', 'X-Application' = product, 'X-Authentication' = token, 'Content-Type' = 'application/json'
    )

    placeOrders <-
      as.list(jsonlite::fromJSON(
        RCurl::postForm(
          "https://api.betfair.com/exchange/betting/json-rpc/v1", .opts = list(
            postfields = placeOrdersOps, httpheader = headers, ssl.verifypeer = sslVerify
          )
        )
      ))

    if(is.null(placeOrders$error))
      as.data.frame(placeOrders$result)
    else({
      if(!suppress)
        warning("Error- See output for details")
      as.data.frame(placeOrders$error)})
  }
