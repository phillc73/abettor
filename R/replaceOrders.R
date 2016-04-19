#' Change the price of a set of unmatched bets
#'
#' \url{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/replaceOrders}
#'
#' \code{replaceOrders} changes the price of a specific set of unmatched bets
#' from the same market.
#'
#' Important Info: This operation is logically a bulk cancel followed by a bulk
#' place. The cancel is completed first then the new orders are placed. The new
#' orders will be placed atomically in that they will all be placed or none will
#' be placed. In the case where the new orders cannot be placed, the
#' cancellations will not be rolled back.
#'
#' @seealso \code{\link{loginBF}}, which must be executed first. Do NOT use the
#'   DELAY application key. The DELAY application key does not support price
#'   data.
#'
#' @param marketId String. The market ID of the bets to be replaced. While many
#'   bets can be updated in one call, they must be from the same market.
#'   Required. No default.
#'
#' @param betId vector (strings). The bet IDs of the bets to be replaced- bet
#'   IDs are displayed (called Ref) on the bet information on the right hand
#'   side of market page on the betfair desktop site. Required. No default.
#'
#' @param newPrice vector (strings). The new price of the original bets (e.g
#'   "1.01", "2.22","10.0",etc). This parameter needs to be a set of quoted
#'   doubles (see Betfair's online documentation for more information on accepted 
#'   price doubles (e.g. 2.02 is viable, while 10.02 is not). Requred. No
#'   default.
#'   
#' @param suppress Boolean. By default, this parameter is set to FALSE, meaning 
#'   that a warning is posted when the replaceOrders call throws an error. 
#'   Changing this parameter to TRUE will suppress this warning.   
#'
#' @param sslVerify Boolean. This argument defaults to TRUE and is optional. In
#'   some cases, where users have a self signed SSL Certificate, for example
#'   they may be behind a proxy server, Betfair will fail login with "SSL
#'   certificate problem: self signed certificate in certificate chain". If this
#'   error occurs you may set sslVerify to FALSE. This does open a small
#'   security risk of a man-in-the-middle intercepting your login credentials.
#'
#' @return Response from Betfair is stored in replaceOrders variable, which
#'  is then parsed from JSON as a list. The status column recognises whether
#'  the call was successful. If the replaceOrders call throws an error, a data 
#'  frame containing error information is returned. Note that there are two types
#'  of error associated with this call. An API error is triggered, for example,
#'  when an invalid market ID is entered. Another type of error is returned if 
#'  no action is required (e.g. call to change the price for a bet to the price 
#'  at which it is already set).
#'
#' @section Note on \code{replaceOrders}: Unlike some other functions that
#'   utilised data frames, this function converts the input to a JSON-compatible
#'   format. The JSON output is then converted back to a data frame.
#'
#' @examples
#' \dontrun{
#' Change the price of two bets. The following
#' variables are for illustrative purposes and don't represent actual Betfair IDs:
#'
#' updateOrder(marketId = "1.19991480", betId = c("61385423029","61385459133"),
#'            newPrice = c("1.44","2.02")
#'            )
#'
#' Note that if you run this function again (after changing the bet IDs remember,
#' replaceOrders places new bets), it will return an error (BET_TAKEN_OR_LAPSED),
#' as the bet price hasn't changed.
#'
#' Note that, unlike \code{updateOrders}, \code{replaceOrders} is an all or
#' nothing process. One error is sufficient to prevent any replacement across the
#' entire set of bet IDs.
#'
#' }
#'

replaceOrders <- function(marketId ,betId, newPrice, suppress = FALSE, sslVerify = TRUE) {
  options(stringsAsFactors = FALSE)
  
  if (length(betId) != length(newPrice))
    return("Bet ID and Persistence Type vector need to have the same length")
  
  replaceOrderOps = paste0(
    '[{"jsonrpc": "2.0","method": "SportsAPING/v1.0/replaceOrders","params":{"marketId": "',marketId,'","instructions": [',
    paste0(sapply(as.data.frame(t(data.frame(betId,newPrice))),function(x)
      paste0('{"betId":"',x[1],'","newPrice":"',x[2],'"}')),collapse = ","),']},"id": "1"}]'
  )
  
  # Read Environment variables for authorisation details
  product <- Sys.getenv('product')
  token <- Sys.getenv('token')
  
  headers <- list(
    'Accept' = 'application/json', 'X-Application' = product, 'X-Authentication' = token, 'Content-Type' = 'application/json'
  )
  
  replaceOrder <-
    as.list(jsonlite::fromJSON(
      RCurl::postForm(
        "https://api.betfair.com/exchange/betting/json-rpc/v1", .opts = list(
          postfields = replaceOrderOps, httpheader = headers, ssl.verifypeer = sslVerify
        )
      )
    ))
  
  if(is.null(replaceOrder$error)){
    if(!is.null(replaceOrder$result$errorCode) & !suppress)
      warning("Error- See output for details")
    as.data.frame(replaceOrder$result)}
  else({
    if(!suppress)
      warning("API Error- See output for details")
    as.data.frame(replaceOrder$error)})  
}
