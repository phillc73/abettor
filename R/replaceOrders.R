#' Change the price of a set of unmatched bets
#' \link{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/replaceOrders}
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
#' 
#' @seealso \code{\link{loginBF}}, which must be executed first. Do NOT use the 
#'   DELAY application key. The DELAY application key does not support price
#'   data.
#'   
#' @param marketId String. The market ID of the bets to be replaced. While many
#'   bets can be updated in one call, they must be from the same market.
#'   
#' @param betID vector (strings). The bet IDs of the bets to be replaced- bet
#'   IDs are displayed (called Ref) on the bet information on the right hand
#'   side of market page on the betfair desktop site.
#'   
#' @param newPrice vector (strings). The new price of the original bets (e.g
#'   "1.01", "2.22","10.0",etc). This parameter needs to be set of quoted
#'   doubles (see for more information on accepted price doubles (e.g. 2.02 is
#'   viable, while 10.02 is not))
#'   
#' @param sslVerify Boolean. This argument defaults to TRUE and is optional. In 
#'   some cases, where users have a self signed SSL Certificate, for example 
#'   they may be behind a proxy server, Betfair will fail login with "SSL 
#'   certificate problem: self signed certificate in certificate chain". If this
#'   error occurs you may set sslVerify to FALSE. This does open a small 
#'   security risk of a man-in-the-middle intercepting your login credentials.
#'   
#' @return If the call is successful, then the function returns "SUCCESS".
#'   Otherwise, a string indicating the nature of the error is returned.
#'   
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
#' updateOrder("1.19991480",c("61385423029","61385459133"),c("1.44","2.02") )
#' 
#' Note that if you run this function again (after changing the bet IDs- remember, replaceOrders places new bets), it will return an error (BET_TAKEN_OR_LAPSED), as the bet price hasn't changed.
#' 
#' Note that, unlike \code{updateOrders}, \code{replaceOrders} is a an all or nothing process. One error is sufficient to prevent any replacement across the entire set of bet IDs.
#' 
#' Another possible error occurs if you input incorrect data. In these scenarios, no updates will have been processed and "No Data Returned" will be the function output.
#' }
#' 

replaceOrders <- function(marketID,betID,newPrice,sslVerify = TRUE){
  
  options(stringsAsFactors=FALSE)
  if(length(betID)!=length(newPrice))
    return("Bet ID and Persistence Type vector need to have the same length")
  replaceOrderOps=paste0('[{"jsonrpc": "2.0","method": "SportsAPING/v1.0/replaceOrders","params":{"marketId": "',marketID,'","instructions": [',
                      paste0(sapply(as.data.frame(t(data.frame(betID,newPrice))),function(x)paste0('{"betId":"',x[1],'","newPrice":"',x[2],'"}')),collapse=","),']},"id": "1"}]')
  listOrder <- as.list(jsonlite::fromJSON(RCurl::postForm("https://api.betfair.com/exchange/betting/json-rpc/v1", .opts=list(postfields=replaceOrderOps, httpheader=headersPostLogin, ssl.verifypeer = TRUE))))
  output<-as.data.frame(replaceOrderOps$result)
  if(length(output)==0)
    return("No Data Returned")
  if(output$status=="SUCCESS")
    return(output$status)
  return(paste0(output$status,": ",output$errorCode," (",as.data.frame(output$instructionReports)$errorCode,")"))
}
