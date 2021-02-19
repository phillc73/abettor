#' Checks account balance on Betfair.
#'
#' \code{getAccountFunds} allows you to see you Betfair account balance.
#'
#' \code{getAccountFunds} checks your Betfair balance. Unlike other Betfair API
#' calls, there are no dangers associated with this function, it simply returns
#' account information such as balance, exposure, etc.
#'
#' @seealso
#' \url{https://docs.developer.betfair.com/display/1smk3cen4v3lu3yomq5qye0ni/getAccountFunds}
#' for general information on calling account balance via the Betfair API.
#'
#' @seealso \code{\link{loginBF}}, which must be executed first, as this
#'   function requires a valid session token
#'
#' @param suppress Boolean. By default, this parameter is set to FALSE, meaning
#'  that a warning is posted when the checkBalance call throws an error. Changing
#'  this parameter to TRUE will suppress this warning.
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
#' @section Note on \code{balanceOps} variable: The \code{balanceOps} variable
#'   is used to firstly build an R data frame containing all the data to be
#'   passed to Betfair, in order for the function to execute successfully. The
#'   data frame is then converted to JSON and included in the HTTP POST request.
#'   If the checkBalance call throws an error, a data frame containing error
#'   information is returned.
#'
#' @examples
#' \dontrun{
#' getAccountFunds() # without any arguments will return global wallet information as a data frame
#' # e.g. getAccountFunds()$availableToBetBalance tells how much left in your wallet to bet
#'
#' }
#'
#' @export
#' 

getAccountFunds <- function(suppress = FALSE, sslVerify = TRUE) {

  balanceOps <-
    data.frame(jsonrpc = "2.0", method = "AccountAPING/v1.0/getAccountFunds", id = "1")

  balanceOps$params <- data.frame(wallet = c(""))

  balanceOps$params$wallet <- "UK"

  balanceOps <- balanceOps[c("jsonrpc", "method", "params", "id")]

  balanceOps <- jsonlite::toJSON(jsonlite::unbox(balanceOps), pretty = TRUE)

  # Read Environment variables for authorisation details
  product <- Sys.getenv('product')
  token <- Sys.getenv('token')

  balance <- httr::content(
    httr::POST(url = "https://api.betfair.com/exchange/account/json-rpc/v1",
                 config = httr::config(ssl_verifypeer = sslVerify),
                 body = balanceOps,
                 httr::add_headers(Accept = "application/json", `X-Application` = product, `X-Authentication` = token)
               )
    )

  if(is.null(balance$error))
    as.data.frame(balance$result)
  else({
    if(!suppress)
      warning("Error- See output for details")
    as.data.frame(balance$error)})

}

#' @rdname getAccountFunds
#' @examples #' \dontrun{
#' checkBalance() # without any arguments will return global wallet information as a data frame
#' # e.g. checkBalance()$availableToBetBalance tells how much left in your wallet to bet
#'
#' }
#' @export


checkBalance <- getAccountFunds