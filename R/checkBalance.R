#' Checks account balance on Betfair. See \link{http://learning.betfair.com/en/videos/australian-wallet.html} (video)
#' or \link{https://en-betfair.custhelp.com/app/answers/detail/a_id/103/~/exchange%3A-what-are-wallets-used-for%3F}
#' for more general information on Betfair's wallet system.
#' 
#'
#' \code{checkBalance} allows you to see you Betfair account balance (for either your Main wallet or Australian Wallet)
#'
#' \code{checkBalance} checks your Betfair balance.Unlike other Betfair API calls,
#' there are no dangers associated with this function- it simply returns account
#' information (balance, exposure, etc).
#' 
#' @seealso  \link{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/getAccountFunds}
#' for general information on calling account balance via the Betfair API.
#' 
#' @seealso \code{\link{loginBF}}, which must be executed first, as this function requires a valid session token
#'
#' @param AUS Boolean. Betfair users have a main wallet and an Australian wallet.
#' This parameter determines which wallet is queried. By default,
#' it is set to FALSE (as in, main wallet data is returned). Changing this parameter to FALSE
#' returns Australian account information.
#' 
#' 
#' @param sslVerify Boolean. This argument defaults to TRUE and is optional. In
#'   some cases, where users have a self signed SSL Certificate, for example
#'   they may be behind a proxy server, Betfair will fail login with "SSL
#'   certificate problem: self signed certificate in certificate chain". If this
#'   error occurs you may set sslVerify to FALSE. This does open a small
#'   security risk of a man-in-the-middle intercepting your login credentials.
#'
#' @return Response from Betfair is stored in AccountFundsResponse variable,
#'   which is then parsed from JSON as a data frame of 1 row and 7 columns.
#'  
#'
#' @section Note on \code{balanceOps} variable: The
#'   \code{balanceOps} variable is used to firstly build an R data frame
#'   containing all the data to be passed to Betfair, in order for the function
#'   to execute successfully. The data frame is then converted to JSON and
#'   included in the HTTP POST request.
#'
#' @examples
#' \dontrun{
#' checkBalance() without any arguments will return main wallet information as a data frame
#' e.g. checkBalance()$availableToBetBalance tells how much left in your wallet to bet
#' checkBalance(AUS=TRUE) returns the corresponding information for the Australian wallet
#' }
#' 
#' 
#
checkBalance <- function(AUS=FALSE, sslVerify = TRUE){
  
  balanceOps <- data.frame(jsonrpc = "2.0", method = "AccountAPING/v1.0/getAccountFunds", id = "1")
  
  balanceOps$params <- data.frame(wallet = c(""))
  
  balanceOps$params$wallet <- ifelse(AUS,c("AUSTRALIAN"),c("UK"))
  
  
  balanceOps <- balanceOps[c("jsonrpc", "method", "params", "id")]
  
  balanceOps <- jsonlite::toJSON(balanceOps, pretty = TRUE)
  
  
  balanceOps <- as.list(jsonlite::fromJSON(RCurl::postForm("https://api.betfair.com/exchange/account/json-rpc/v1", .opts=list(postfields=balanceOps, httpheader=headersPostLogin, ssl.verifypeer = sslVerify))))
  
  as.data.frame(balanceOps$result)
  
}
