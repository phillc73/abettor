#' Return settled Orders data
#'
#' \code{listClearedOrders} Returns a list of settled bets based on the bet status, ordered by settled date.
#' For more infromation, please consult the online documentation (\link{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/listClearedOrders})
#' 
#' @seealso \code{\link{loginBF}}, which must be executed first. Do NOT use the
#'   DELAY application key. The DELAY application key does not support price data.
#'
#' @param betStatus string. Restricts the results to the specified status. According
#' to the online documentation, this paramter is not mandatory. However, it returns an
#' empty data frame unless it's specified. Thus, by default, this parameter is set to "SETTLED" (matched bets that were settled normally).
#' Alternative values are "VOIDED" (matched bets that were subsequently voided by Betfair, before, during or after settlement)
#' , "LAPSED" (Unmatched bets that were cancelled by Betfair (for example at turn in play))
#' and "CANCELLED" (unmatched bets that were cancelled by an explicit customer action)
#'   
#' @param eventTypeIDs Vector<string>. Restrict the results to the specified event type IDs (e.g football = "1"). Optional.
#' 
#' @param eventIDs Vector<string>. Restrict the results to the specified event IDs (e.g. c("27664019","27664123")). Optional.
#' 
#' @param marketIDs Vector<string>. Restrict the results to the specified market IDs (e.g. c("1.122841367","1.122814314")). Optional.
#' 
#' @param runnerIDs Vector<string>. Restrict the results to the specified runner IDs (e.g. c("1039206","8216044")). Optional.
#' 
#' @param sideValue string.Restrict the results to the specified side (i.e. "BACK" or "LAY"). Optional.
#' 
#' @param sideValue string.Restrict the results to the specified side (i.e. "BACK" or "LAY"). Optional.
#' 
#' @param betIDs Vector<string>. Restrict the results to the specified bet IDs (e.g. c("61529884133","61529884472")). Optional.
#' 
#' @param toDate Datetime (ISO 8601 format). Lower bound of date range (inclusive).
#' Default value is NULL, which means that the oldest available items will be in range. Optional.
#' 
#' @param fromDate Datetime (ISO 8601 format). Upper bound of date range (inclusive).
#' Default value is NULL, which means that the latest available items will be in range. Optional.
#' 
#' @param fromRecordValue int. Specifies the first record that will be returned. Records start at index zero. 
#' Default parameter value is NULL, which Betfair interprets as 0. Optional.
#' 
#' @param recordCountValue int. Specifies the maximum number of records to be returned. 
#' To retrieve more than 1000 records (the maxiumum by default), you need to utilise this parameter. Optional.
#' 
#' @param includeItemDescriptionValue Boolean. Determines whether an ItemDescription (e.g. market and event information) object is included in the response 
#' The default value is NULL, which Betfair interprets as FALSE (i.e. no ItemDescription is returned) Optional.
#' 
#' @param groupByValue string. Only applicable to the "SETTLED" betstatus, this parameter determines how the data is aggregated.
#' THe default value is NULL, which means that the lowest level is returned (individual bet level). 
#' Alernative values are "EVENT_TYPE" (settled P&L, commission paid and number of bet orders aggregated over event type), "EVENT" (aggregated over different events),
#' "MARKET" (aggregated over individual markets) and "SIDE" (an averaged roll up of settled P&L, and number of bets, on the specified side of a specified selection within a specified market, that are either settled or voided). Optional.
#' 
#' @param flag Boolean. \code{RCurl::postForm} returns a warning if there's more records than the limit of 1000 (or limit specified by the record parameters) that can be returned in one call. 
#' By default, this parameter is set to FALSE, meaning this warning is not flagged.
#' Changing this parameter to TRUE will result in warnings being posted.
#' 
#' @param sslVerify Boolean. This argument defaults to TRUE and is optional. In
#'   some cases, where users have a self signed SSL Certificate, for example
#'   they may be behind a proxy server, Betfair will fail login with "SSL
#'   certificate problem: self signed certificate in certificate chain". If this
#'   error occurs you may set sslVerify to FALSE. This does open a small
#'   security risk of a man-in-the-middle intercepting your login credentials.
#'
#' @return Response from Betfair is stored in listMarketBook variable, which is
#'   then parsed from JSON as a list. Only the first item of this list contains
#'   the required event type identification details.
#'
#'
#' @section Note on \code{listMarketBookOps} variable: The
#'   \code{listMarketBookOps} variable is used to firstly build an R data frame
#'   containing all the data to be passed to Betfair, in order for the function
#'   to execute successfully. The data frame is then converted to JSON and
#'   included in the HTTP POST request.
#'
#' @examples
#' \dontrun{
#' # Return 100 settled bets (with market,event,runner information) for the last 2 days or so.
#' 
#' listClearedOrders(toDate=format(Sys.time()-200000, "%Y-%m-%dT"),recordCountValue=100,includeItemDescriptionValue = TRUE)
#' 
#' }
#'

listClearedOrders <- function(betStatusValue="SETTLED",eventTypeIDs=NULL,eventIDs=NULL,betIDs=NULL,marketIDs=NULL,runnerIDs=NULL, 
sideValue=NULL,fromDate = NULL, toDate = NULL,groupByValue=NULL,includeItemDescriptionValue=NULL,fromRecordValue=NULL,recordCountValue=NULL,flag=FALSE,sslVerify = TRUE){
  
  options(stringsAsFactors=FALSE)
  listOrderOps <- data.frame(jsonrpc = "2.0", method = "SportsAPING/v1.0/listClearedOrders", id = "1")
  
  listOrderOps$params <- data.frame(includeItemDescription = "")
  if(!is.null(betIDs))
    listOrderOps$params$betIds <- list(c(betIDs))
  if(!is.null(marketIDs))
    listOrderOps$params$marketIds <- list(c(marketIDs))
  if(!is.null(eventTypeIDs))
    listOrderOps$params$eventTypeIds <- list(c(eventTypeIDs))
  if(!is.null(eventIDs))
    listOrderOps$params$eventIds <- list(c(eventIDs))
  if(!is.null(eventIDs))
    listOrderOps$params$runnerIds <- list(c(runnerIDs))
  
  listOrderOps$params$betStatus<-betStatusValue
  listOrderOps$params$groupBy <- groupByValue
  listOrderOps$params$side <- sideValue
  listOrderOps$params$includeItemDescription <- includeItemDescriptionValue
  listOrderOps$params$fromRecord <- fromRecordValue
  listOrderOps$params$recordCount <- recordCountValue
  listOrderOps$params$settledDateRange <- data.frame(from = "")
  listOrderOps$params$settledDateRange$from=fromDate
  listOrderOps$params$settledDateRange$to=toDate
  
  listOrderOps <- listOrderOps[c("jsonrpc", "method", "params", "id")]
  
  listOrderOps <- jsonlite::toJSON(listOrderOps, pretty = TRUE)
  listOrder <- jsonlite::fromJSON(RCurl::postForm("https://api.betfair.com/exchange/betting/json-rpc/v1", .opts=list(postfields=listOrderOps, httpheader=headersPostLogin, ssl.verifypeer = TRUE)))
  if(listOrder$result$moreAvailable & flag==TRUE)
    warning("Not all bets included in output- More bets available")
  as.data.frame(listOrder$result$clearedOrders)
}
