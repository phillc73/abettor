#' Places an order on Betfair
#'
#' \code{placeOrders} places an order (bet) on the Betfair betting exchange.
#'
#' \code{placeOrders} places an order (bet) on the Betfair betting exchange.
#' When using this function, be careful not to have logged in with your "DELAY"
#' application key. It is not possible to place bets with the DELAY application
#' key. Executing this function, after a successful login, will place real money
#' bets on the Betfair betting exchange. You do this at your own risk. The
#' author of this package accepts no responsibility if things go wrong. Be
#' careful! Running tests, by placing small bets, is not only a good idea to
#' begin with, it will also probably save you money. \code{placeOrders} has to
#' date only been successfully tested on Horse Racing markets, however there
#' should be no reason why other market orders will not be placed, assuming
#' correct argument options are used.
#'
#' @seealso \code{\link{loginBF}}, which must be executed first. Do NOT use the
#'   DELAY application key. The DELAY application key does not support placing
#'   bets.
#'
#' @param marketId String. The market ID these orders are to be placed on. Can
#'   currently only accept a single market ID. IDs can be obtained via
#'   \code{\link{listMarketCatalogue}}. Required. No default.
#' @param selectionId String. The selection id of the desired item to bet on. If
#'   betting on a Horse Race, this will be a single number to identify a horse.
#'   In a Football match, this will be a single ID for one team. IDs can be
#'   obtained via \code{\link{listMarketCatalogue}}. Required. No default.
#' @param betSide Sting. Back or Lay. This argument accepts one of two options -
#'   BACK or LAY. Must be upper case.See note below explaining each of these
#'   options. Required. No default.
#' @param betType String. Supports three order types, one of which must be
#'   specified. Valid order types are LIMIT, LIMIT_ON_CLOSE and MARKET_ON_CLOSE.
#'   Must be upper case. See note below explaining each of these options.
#'   Required. no default.
#' @param betSize String. The size of the bet in the currency of your account.
#'   Generally the minimum size for GB accounts is 2 Pounds.
#' @param reqPrice String. The lowest price at which you wish to place your bet.
#'   If unmatched higher prices are available on the opposite side of the bet,
#'   your order will be matched at those higher prices. Required. No default.
#' @param persistenceType String. What to do with the order, when the market
#'   turns in-play. Supports three persistence types, one of which must be
#'   specified. Valid persistence types are LAPSE, PERSIST and MARKET_ON_CLOSE.
#'   Must be upper case. See note below explaining each of these options.
#'   Required. no default.
#' @param handicap String. The handicap applied to the selection, if on an
#'   asian-style market. Optional. Defaults to 0, meaning no handicap.
#'   \code{handicap} must only be manually specified if betting on an
#'   asian-style market.
#' @param customerRef String. Optional parameter allowing the client to pass a
#'   unique string (up to 32 chars) that is used to de-dupe mistaken
#'   re-submissions. CustomerRef can contain: upper/lower chars, digits, chars :
#'   - . _ + * : ; ~ only. Optional. Defaults to current system date and time.
#'
#'
#' @return Response from Betfair is stored in listMarketCatalogue variable,
#'   which is then parsed from JSON as a list. Only the first item of this list
#'   contains the required event type identification details.
#'
#' @section Notes on \code{betType} options: There are three options for this
#'   argument and one of them must be specified. All upper case letters must be
#'   used. \describe{ \item{LIMIT}{A normal exchange limit order for
#'   immediate execution. Essentially a bet which will be either matched
#'   immediately if possible, or will wait unmatched until the event begins. It
#'   will then either remain open in play or expire, depending on
#'   \code{persistenceType}} \item{LIMIT_ON_CLOSE}{Limit order for the auction
#'   (SP). If the Starting Price (SP) is greater than the value specified in
#'   \code{reqPrice} and there is enough market volume, the bet will be matched
#'   when the event begins.} \item{MARKET_ON_CLOSE}{Market order for the auction
#'   (SP). The bet amount, as specified in \code{betSize}, will be matched at
#'   the Starting Price, regardless of price, assuming there is enough market
#'   volume.} }
#'
#' @section Notes on \code{betSide} options: There are just two options for this
#'   argument and one of them must be specified. All upper case letters must be
#'   used. \describe{ \item{BACK}{To back a team, horse or outcome is to bet on
#'   the selection to win.} \item{LAY}{To lay a team, horse, or outcome is to
#'   bet on the selection to lose.} }
#'
#' @section Notes on \code{persistenceType} options: There are three options for
#'   this argument and one of them must be specified. All upper case letters
#'   must be used. \describe{ \item{LAPSE}{Lapse the order when the market is
#'   turned in-play. Order is canceled if not matched prior to the market
#'   turning in-play.} \item{PERSIST}{Persist the order to in-play. The bet will
#'   be place automatically into the in-play market at the start of the event.}
#'   \item{MARKET_ON_CLOSE}{Put the order into the auction (SP) at turn-in-play.
#'   The bet amount, as specified in \code{betSize}, will be matched at the
#'   Starting Price, regardless of price, assuming there is enough market
#'   volume.} }
#'
#' @section Note on \code{listPlaceOrdersOps} variable: The
#'   \code{listPlaceOrdersOps} variable is used to firstly build an R data frame
#'   containing all the data to be passed to Betfair, in order for the function
#'   to execute successfully. The data frame is then converted to JSON and
#'   included in the HTTP POST request.
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
#' }
#'

placeOrders <- function(marketId, selectionId, betSide, betType, betSize, reqPrice, persistenceType, handicap = "0", customerRef = (format(Sys.time(), "%Y-%m-%dT%TZ"))){

  options(stringsAsFactors=FALSE)
  placeOrdersOps <- data.frame(jsonrpc = "2.0", method = "SportsAPING/v1.0/placeOrders", id = 1)

  placeOrdersOps$params <- data.frame(marketId = marketId, instructions = c(""), customerRef = customerRef)
  placeOrdersOps$params$instructions <- data.frame(selectionId = selectionId, handicap = handicap, side = betSide, orderType = betType, limitOrder=c(""))
  placeOrdersOps$params$instructions$limitOrder <- data.frame(size = betSize, price = reqPrice, persistenceType = persistenceType)
  placeOrdersOps$params$instructions <- list(placeOrdersOps$params$instructions)

  placeOrdersOps <- placeOrdersOps[c("jsonrpc", "method", "params", "id")]

  placeOrdersOps <- jsonlite::toJSON(placeOrdersOps, pretty = TRUE)

  placeOrders <- as.list(jsonlite::fromJSON(RCurl::postForm("https://api.betfair.com/exchange/betting/json-rpc/v1", .opts=list(postfields=placeOrdersOps, httpheader=headersPostLogin))))

  as.data.frame(placeOrders$result[1])

}
