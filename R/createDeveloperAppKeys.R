#' Create developer application keys from Betfair.
#'
#' \code{createDeveloperAppKeys} creates two application Keys for a given user; one 'Delayed' and the other
#' 'Live'. You must apply to have your 'Live' App Key activated. Information on activating a Live App Key
#' can be found here: \url{https://docs.developer.betfair.com/display/1smk3cen4v3lu3yomq5qye0ni/Application+Keys#ApplicationKeys-HowdoIactivatemyLiveAppKey?}
#'
#' @seealso
#' \url{https://docs.developer.betfair.com/display/1smk3cen4v3lu3yomq5qye0ni/createDeveloperAppKeys}
#' for general information on calling createDeveloperAppKeys via the Betfair API.
#'
#' @seealso \code{\link{loginBF}}, which must be executed first, as this
#'   function requires a valid session token.
#'
#' @param appName String. Choose a display name for the application. No default. Required.
#'
#' @param suppress Boolean. By default, this parameter is set to FALSE, meaning
#'  that a warning is posted when the createDeveloperAppKeys call throws an error. Changing
#'  this parameter to TRUE will suppress this warning.
#'
#' @param sslVerify Boolean. This argument defaults to TRUE and is optional. In
#'   some cases, where users have a self signed SSL Certificate, for example
#'   they may be behind a proxy server, Betfair will fail login with "SSL
#'   certificate problem: self signed certificate in certificate chain". If this
#'   error occurs you may set sslVerify to FALSE. This does open a small
#'   security risk of a man-in-the-middle intercepting your login credentials.
#'
#' @return Response from Betfair is stored in createDevKey variable which is a list and is
#'   returned in that form.
#'
#' @section Note on \code{createDevKeyOps} variable: The \code{createDevKeyOps} variable
#'   is used to firstly build an R data frame containing all the data to be
#'   passed to Betfair, in order for the function to execute successfully. The
#'   data frame is then converted to JSON and included in the HTTP POST request.
#'   If the createDeveloperAppKeys call throws an error, a data frame containing error
#'   information is returned.
#'
#' @examples
#' \dontrun{
#' createDeveloperAppKeys() # without any arguments will return details as a data frame
#' # e.g. createDeveloperAppKeys()[[1]]$appId gives the appId for the first developer key.
#'
#' }
#'

createDeveloperAppKeys <- function(appName, suppress = FALSE, sslVerify = TRUE) {

  createDevKeyOps <-
    data.frame(jsonrpc = "2.0", method = "AccountAPING/v1.0/createDeveloperAppKeys", id = "1")

  createDevKeyOps$params <- c("")

  createDevKeyOps$params <- data.frame(appName = c(""))

  createDevKeyOps$params$appName <- appName


  createDevKeyOps <- createDevKeyOps[c("jsonrpc", "method", "params", "id")]

  createDevKeyOps <- jsonlite::toJSON(jsonlite::unbox(createDevKeyOps), pretty = TRUE)

  # Read Environment variables for authorisation details
  product <- Sys.getenv('product')
  token <- Sys.getenv('token')

  createDevKey <- httr::content(
    httr::POST(url = "https://api.betfair.com/exchange/account/json-rpc/v1",
               config = httr::config(ssl_verifypeer = sslVerify),
               body = createDevKeyOps,
               httr::add_headers(Accept = "application/json", `X-Application` = product, `X-Authentication` = token)
    )
  )


  if(is.null(createDevKey$error))
    (createDevKey$result)
  else({
    if(!suppress)
      warning("Error- See output for details")
    as.data.frame(createDevKey$error)})

}
