#' Return Current Orders data
#'
#' \code{listOrders} returns all matched and unmatched bets for all markets or specific markets.
#'It is also possible to filter the results according to bet IDs and date intervals.
#'
#' @seealso \code{\link{loginBF}}, which must be executed first. Do NOT use the
#'   DELAY application key. The DELAY application key does not support price data.
#'
#' @param marketIds String. A list of market ID strings from which the corresponding current orders will be returned. 
#' Not required. Default is set to NULL.
#'   
#' @param priceData String. Supports five price data types, one of which must be
#'   specified. Valid price data types are SP_AVAILABLE, SP_TRADED,
#'   EX_BEST_OFFERS, EX_ALL_OFFERS and EX_TRADED. Must be upper case. See note
#'   below explaining each of these options. Required. no default.
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
#' @section Note on \code{listMarketBookOps} variable: The
#'   \code{listMarketBookOps} variable is used to firstly build an R data frame
#'   containing all the data to be passed to Betfair, in order for the function
#'   to execute successfully. The data frame is then converted to JSON and
#'   included in the HTTP POST request.
#'
#' @examples
#' \dontrun{
#' # Return all prices for the requested market. This actual market ID is
#' unlikely to work and is just for demonstration purposes.
#' listMarketBook(marketIds = "1.116700328", priceData = "EX_ALL_OFFERS")
#' }
#'

listOrders <- function(betIds=NULL,marketIds=NULL,orderByValue=NULL,SortDirValue=NULL, 
fromDate = NULL, toDate = NULL,
flag=TRUE,orderProjectionValue=NULL,fromRecordValue=NULL,recordCountValue=NULL,sslVerify = TRUE){
  
  options(stringsAsFactors=FALSE)
  listOrderOps <- data.frame(jsonrpc = "2.0", method = "SportsAPING/v1.0/listCurrentOrders", id = "1")
  
  listOrderOps$params <- data.frame(orderProjection = "")
  if(!is.null(betIds))
    listOrderOps$params$betIds <- list(c(betIds))
  if(!is.null(marketIds))
    listOrderOps$params$marketIds <- list(c(marketIds))
  
  listOrderOps$params$orderProjection=orderProjectionValue
  listOrderOps$params$orderBy <- orderByValue
  listOrderOps$params$SortDir <- SortDirValue
  listOrderOps$params$fromRecord <- fromRecordValue
  listOrderOps$params$recordCount <- recordCountValue
  if(!is.null(fromDate)& !is.null(toDate))
    listOrderOps$params$daterange <- data.frame(from = fromDate, to = toDate)
  
  listOrderOps <- listOrderOps[c("jsonrpc", "method", "params", "id")]
  
  listOrderOps <- jsonlite::toJSON(listOrderOps, pretty = TRUE)

  listOrder <- jsonlite::fromJSON(RCurl::postForm("https://api.betfair.com/exchange/betting/json-rpc/v1", .opts=list(postfields=listOrderOps, httpheader=headersPostLogin, ssl.verifypeer = TRUE)))

  if(listOrder$result$moreAvailable & flag==TRUE)
    warning("Not all bets included in output- More bets available")
  as.data.frame(listOrder$result$currentOrders)
  
}
