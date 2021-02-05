#' Gets all developer application keys from Betfair.
#'
#' \code{getDeveloperAppKeys} gets all application keys owned by the given developer/vendor and
#' returns them as a list.
#'
#' @seealso
#' \url{https://docs.developer.betfair.com/display/1smk3cen4v3lu3yomq5qye0ni/getDeveloperAppKeys}
#' for general information on calling getDeveloperAppKeys via the Betfair API.
#'
#' @seealso \code{\link{loginBF}}, which must be executed first, as this
#'   function requires a valid session token.
#'
#' @param suppress Boolean. By default, this parameter is set to FALSE, meaning
#'  that a warning is posted when the getDeveloperAppKeys call throws an error. Changing
#'  this parameter to TRUE will suppress this warning.
#'
#' @param sslVerify Boolean. This argument defaults to TRUE and is optional. In
#'   some cases, where users have a self signed SSL Certificate, for example
#'   they may be behind a proxy server, Betfair will fail login with "SSL
#'   certificate problem: self signed certificate in certificate chain". If this
#'   error occurs you may set sslVerify to FALSE. This does open a small
#'   security risk of a man-in-the-middle intercepting your login credentials.
#'
#' @return Response from Betfair is stored in devKeys variable which is a list and is
#'   returned in that form.
#'
#' @section Note on \code{devKeysOps} variable: The \code{devKeysOps} variable
#'   is used to firstly build an R data frame containing all the data to be
#'   passed to Betfair, in order for the function to execute successfully. The
#'   data frame is then converted to JSON and included in the HTTP POST request.
#'   If the getDeveloperAppKeys call throws an error, a data frame containing error
#'   information is returned.
#'
#' @examples
#' \dontrun{
#' getDeveloperAppKeys() # without any arguments will return details as a data frame
#' # e.g. getDeveloperAppKeys()[[1]]$appId gives the appId for the first developer key.
#'
#' }
#'

getDeveloperAppKeys <- function(suppress = FALSE, sslVerify = TRUE) {

  devKeysOps <-
    data.frame(jsonrpc = "2.0", method = "AccountAPING/v1.0/getDeveloperAppKeys", id = "1")

  devKeysOps$params <- c("")

  devKeysOps <- devKeysOps[c("jsonrpc", "method", "params", "id")]

  devKeysOps <- jsonlite::toJSON(jsonlite::unbox(devKeysOps), pretty = TRUE)

  # Read Environment variables for authorisation details
  product <- Sys.getenv('product')
  token <- Sys.getenv('token')

  devKeys <- httr::content(
    httr::POST(url = "https://api.betfair.com/exchange/account/json-rpc/v1",
               config = httr::config(ssl_verifypeer = sslVerify),
               body = devKeysOps,
               httr::add_headers(Accept = "application/json", `X-Application` = product, `X-Authentication` = token)
    )
  )


  if(is.null(devKeys$error))
    (devKeys$result)
  else({
    if(!suppress)
      warning("Error- See output for details")
    as.data.frame(devKeys$error)})

}
