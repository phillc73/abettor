#' Betfair Heartbeat API function
#'
#' \code{heartbeat} supports automatic bet cancellation if Betfair
#' becomes unresponsive.
#'
#' This heartbeat operation is provided to help customers have their positions
#' managed automatically in the event of their API clients losing connectivity
#' with the Betfair API. If a heartbeat request is not received within a
#' prescribed time period, then Betfair will attempt to cancel all 'LIMIT' type
#' bets for the given customer on the given exchange. There is no guarantee that
#' this service will result in all bets being cancelled as there are a number of
#' circumstances where bets are unable to be cancelled. Manual intervention is
#' strongly advised in the event of a loss of connectivity to ensure that
#' positions are correctly managed. If this service becomes unavailable for any
#' reason, then your heartbeat will be unregistered automatically to avoid bets
#' being inadvertently cancelled upon resumption of service. you should manage
#' your position manually until the service is resumed. Heartbeat data may also
#' be lost in the unlikely event of nodes failing within the cluster, which may
#' result in your position not being managed until a subsequent heartbeat
#' request is received.
#'
#' @seealso
#'   \url{https://docs.developer.betfair.com/display/1smk3cen4v3lu3yomq5qye0ni/Heartbeat+API}
#'
#' @seealso \code{\link{loginBF}}, which must be executed first, as this
#'   function requires a valid session token
#'
#' @param endPoint String. Defines which end point to use for the Heartbeat API.
#'   Valid options are "Global", "IT" and "ES". Values are case sensitive.
#'   Any other value will return an error and the API call will fail. Default
#'   value is "Global".
#' 
#' @param preferredTimeoutSeconds Integer. Maximum period in seconds that may
#'   elapse (without a subsequent heartbeat request), before a cancellation
#'   requestis automatically submitted on your behalf. The minimum value is 10,
#'   the maximum value permitted is 300. Passing 0 will result in your heartbeat
#'   being unregistered (or ignored if no current heartbeat registered).
#'   You'll still get an actionPerformed value returned when passing 0, so this
#'   may be used to determine if any action was performed since your last
#'   heartbeat, without actually registering a new heartbeat. Passing a negative
#'   value will result in an error being returned, INVALID_INPUT_DATA. Any
#'   errors while registering your heartbeat will result in a error being
#'   returned, UNEXPECTED_ERROR. Passing a value that is less than the minimum
#'   timeout will result in your heartbeat adopting the minimum timeout. Passing
#'   a value that is greater than the maximum timeout will result in your
#'   heartbeat adopting the maximum timeout. The minimum and maximum timeouts
#'   are subject to change, so your client should utilise the returned
#'   actualTimeoutSeconds to set an appropriate frequency for your subsequent
#'   heartbeat requests. Default value is 10 seconds.
#'
#' @param suppress Boolean. By default, this parameter is set to FALSE, meaning
#'   that a warning is posted when the listVenues call throws an error.
#'   Changing this parameter to TRUE will suppress this warning.
#'
#' @param sslVerify Boolean. This argument defaults to TRUE and is optional. In
#'   some cases, where users have a self signed SSL Certificate, for example
#'   they may be behind a proxy server, Betfair will fail login with "SSL
#'   certificate problem: self signed certificate in certificate chain". If this
#'   error occurs you may set sslVerify to FALSE. This does open a small
#'   security risk of a man-in-the-middle intercepting your login credentials.
#'
#' @return Response from Betfair will be stored in a two row, one column
#'   dataframe. This dataframe contains a value for actualTimeoutSeconds, 
#'   which should be used to set the frequency of subsequent heartbear requests,
#'   and actionedPerformed, which details the action performed since the last
#'   heartbeat request. The first heartbeat request will always return NONE for
#'   actionedPerformed.
#'
#' @section Note on \code{heartbeatOps} variable: The \code{heartbeatOps}
#'   variable is used to firstly build an R data frame containing all the data
#'   to be passed to Betfair, in order for the function to execute
#'   successfully. The data frame is then converted to JSON and included in the
#'   HTTP POST request. If the heartbeat call throws an error, a data
#'   frame containing error information is returned.
#'
#' @examples
#'   \dontrun{
#'   # Heartbeat API call using default Global endpoint and 10 second timeout
#'   heartbeat()
#'  }
#' \dontrun{
#'   # Set heartbeat timeout to 20 seconds. Defailt global end point is used
#'   heartbeat(preferredTimeoutSeconds = 20)
#'  }
#' \dontrun{
#'   # Use Italian endpoint and detail timeout of 10 seconds
#'   heartbeat(endPoint = "IT")
#'   }
#'

heartbeat <- function(endPoint = "Global",
                      preferredTimeoutSeconds = 10,
                      suppress = FALSE,
                      sslVerify = TRUE) {

  if (endPoint == "Global") {
      endPoint = "https://api.betfair.com/exchange/heartbeat/json-rpc/v1"
  } else if (endPoint == "IT") {
      endPoint = "https://api.betfair.it/exchange/heartbeat/json-rpc/v1"
  } else if (endPoint == "ES") {
      endPoint = "https://api.betfair.es/exchange/heartbeat/json-rpc/v1"
  } else {
      print("Please choose a valid endPoint value. Supported values are Global, ES, IT. Values are case sensitive,")
  }

  heartbeatOps <- data.frame(jsonrpc = "2.0", 
                                method = "HeartbeatAPING/v1.0/heartbeat",
                                params = "",
                                id = "1")

  heartbeatOps$params <- data.frame(preferredTimeoutSeconds = preferredTimeoutSeconds)

  heartbeatOps <- heartbeatOps[c("jsonrpc", "method", "params", "id")]

  heartbeatOps <- jsonlite::toJSON(jsonlite::unbox(heartbeatOps), pretty = TRUE)

  # Read Environment variables for authorisation details
  product <- Sys.getenv("product")
  token <- Sys.getenv("token")

  details <- httr::content(
    httr::POST(url = endPoint,
                 config = httr::config(ssl_verifypeer = sslVerify),
                 body = heartbeatOps,
                 httr::add_headers(Accept = "application/json",
                                   `X-Application` = product,
                                   `X-Authentication` = token,
                                   as = "text",
                                   encoding = "UTF-8")
               )
    )

  if(is.null(details$error))
    as.data.frame(do.call(rbind, details$result))
  else({
    if(!suppress)
      warning("Error- See output for details")
    as.data.frame(details$error)})

}

