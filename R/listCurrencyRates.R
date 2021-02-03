#' List Betfair's currency conversion rates.
#'
#' \code{listCurrencyRates} allows you to see Betfair's current currency
#' coversion rates.
#'
#' @seealso
#' \url{https://docs.developer.betfair.com/display/1smk3cen4v3lu3yomq5qye0ni/listCurrencyRates}
#' for general information on calling listCurrencyRates via the Betfair API.
#'
#' @seealso \code{\link{loginBF}}, which must be executed first, as this
#'   function requires a valid session token
#'
#' @param fromCurrency String. Currently GBP is the only currency that is supported.
#' Setting this parameter to any other value will cause an error.
#'
#' @param suppress Boolean. By default, this parameter is set to FALSE, meaning
#'  that a warning is posted when the listCurrencyRates call throws an error.
#'  Changing this parameter to TRUE will suppress this warning.
#'
#' @param sslVerify Boolean. This argument defaults to TRUE and is optional. In
#'   some cases, where users have a self signed SSL Certificate, for example
#'   they may be behind a proxy server, Betfair will fail login with "SSL
#'   certificate problem: self signed certificate in certificate chain". If this
#'   error occurs you may set sslVerify to FALSE. This does open a small
#'   security risk of a man-in-the-middle intercepting your login credentials.
#'
#' @return Response from Betfair is stored in a list of currency rate pairs,
#'   which is then parsed from JSON as a data frame with 2 columns.
#'
#' @section Note on \code{ratesOps} variable: The \code{ratesOps} variable
#'   is used to firstly build an R data frame containing all the data to be
#'   passed to Betfair, in order for the function to execute successfully. The
#'   data frame is then converted to JSON and included in the HTTP POST request.
#'   If the getAccountDetails call throws an error, a data frame containing error
#'   information is returned.
#'
#' @examples
#' \dontrun{
#' listCurrencyRates() # returns Betfair's current exchange rates.
#' # e.g. getAccountDetails()$pointsBalance gives your points balance.
#'
#' }
#'

listCurrencyRates <- function(fromCurrency = "GBP",
                              suppress = FALSE, sslVerify = TRUE) {

  ratesOps <-
    data.frame(jsonrpc = "2.0", method = "AccountAPING/v1.0/listCurrencyRates", id = "1")

  ratesOps$params <- data.frame(fromCurrency = c(""))

  ratesOps$params$fromCurrency <- fromCurrency

  ratesOps <- ratesOps[c("jsonrpc", "method", "params", "id")]

  ratesOps <- jsonlite::toJSON(jsonlite::unbox(ratesOps), pretty = TRUE)

  # Read Environment variables for authorisation details
  product <- Sys.getenv('product')
  token <- Sys.getenv('token')

  rates <- httr::content(
    httr::POST(url = "https://api.betfair.com/exchange/account/json-rpc/v1",
               config = httr::config(ssl_verifypeer = sslVerify),
               body = ratesOps,
               httr::add_headers(Accept = "application/json", `X-Application` = product, `X-Authentication` = token)),
  )

  if(is.null(rates$error)){
    rates <- t(matrix(unlist((rates$result)),nrow = 2))
    colnames(rates) <- c("currencyCode", "rate")
    return(rates)
  }
  else({
    if(!suppress)
      warning("Error- See output for details")
    as.data.frame(rates$error)})

}
