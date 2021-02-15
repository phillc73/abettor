#' Checks account details on Betfair.
#'
#' \code{getAccountDetails} allows you to see your Betfair account details.
#' Unlike other Betfair API calls, there are no betting dangers associated
#' with this function, it simply returns account information such as balance,
#' exposure, etc.
#'
#' @seealso
#' \url{https://docs.developer.betfair.com/display/1smk3cen4v3lu3yomq5qye0ni/getAccountDetails}
#' for general information on calling getAccountDetails via the Betfair API.
#'
#' @seealso \code{\link{loginBF}}, which must be executed first, as this
#'   function requires a valid session token
#'
#' @param suppress Boolean. By default, this parameter is set to FALSE, meaning
#'  that a warning is posted when the getAccountDetails call throws an error. Changing
#'  this parameter to TRUE will suppress this warning.
#'
#' @param sslVerify Boolean. This argument defaults to TRUE and is optional. In
#'   some cases, where users have a self signed SSL Certificate, for example
#'   they may be behind a proxy server, Betfair will fail login with "SSL
#'   certificate problem: self signed certificate in certificate chain". If this
#'   error occurs you may set sslVerify to FALSE. This does open a small
#'   security risk of a man-in-the-middle intercepting your login credentials.
#'
#' @return Response from Betfair is stored in AccountDetailsResponse variable,
#'   which is then parsed from JSON as a data frame of 1 row and 9 columns.
#'
#' @section Note on \code{detailsOps} variable: The \code{detailsOps} variable
#'   is used to firstly build an R data frame containing all the data to be
#'   passed to Betfair, in order for the function to execute successfully. The
#'   data frame is then converted to JSON and included in the HTTP POST request.
#'   If the getAccountDetails call throws an error, a data frame containing error
#'   information is returned.
#'
#' @examples
#' \dontrun{
#' getAccountDetails() # without any arguments will return details as a data frame
#' # e.g. getAccountDetails()$pointsBalance gives your points balance.
#'
#' }
#'

getAccountDetails <- function(suppress = FALSE, sslVerify = TRUE) {

  detailsOps <-
    data.frame(jsonrpc = "2.0", method = "AccountAPING/v1.0/getAccountDetails", id = "1")

  detailsOps$params <- data.frame(wallet = c(""))

  detailsOps$params$wallet <- "UK"

  detailsOps <- detailsOps[c("jsonrpc", "method", "params", "id")]

  detailsOps <- jsonlite::toJSON(jsonlite::unbox(detailsOps), pretty = TRUE)

  # Read Environment variables for authorisation details
  product <- Sys.getenv('product')
  token <- Sys.getenv('token')

  details <- httr::content(
    httr::POST(url = "https://api.betfair.com/exchange/account/json-rpc/v1",
               config = httr::config(ssl_verifypeer = sslVerify),
               body = detailsOps,
               httr::add_headers(Accept = "application/json", `X-Application` = product, `X-Authentication` = token)
    )
  )

  if(is.null(details$error))
    as.data.frame(details$result)
  else({
    if(!suppress)
      warning("Error- See output for details")
    as.data.frame(details$error)})

}
