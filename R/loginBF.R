#' Login to Betfair, interactive end point.
#'
#' \code{loginBF} logs in to Betfair, via the API-NG JSON interactive end point.
#'
#' This login function \strong{must be executed first}, before any other
#' functions in this package. Failure to execute \code{loginBF} renders
#' everything else pointless. You will require a valid Betfair username,
#' password and application key. Obtain a Betfair application key by following
#' the instructions here:
#'
#' \url{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Application+Keys}
#'
#' \code{username}, \code{password} and \code{applicationKey} are all mandatory
#' and must be user defined.
#'
#' Every time \code{loginBF} is executed, a new login to Betfair occurs. Don't
#' login more than is necessary.
#'
#' @param username Character string containing Betfair username and must be
#'   defined. See Examples.
#' @param password Character string containing Betfair password and must be
#'   defined. See Examples.
#' @param applicationKey Character string containing Betfair application key and
#'   must be defined. See Examples.
#' @param sslVerify Boolean. This argument defaults to TRUE and is optional. In
#'   some cases, where users have a self signed SSL Certificate, for example
#'   they may be behind a proxy server, Betfair will fail login with "SSL
#'   certificate problem: self signed certificate in certificate chain". If this
#'   error occurs you may set sslVerify to FALSE. This does open a small
#'   security risk of a man-in-the-middle intercepting your login credentials.
#'   See Examples.
#'
#' @return Response from Betfair will be stored in \code{loginReturn} parse from
#'   JSON as a list. This will include the statuses SUCCESS, FAIL or error, if
#'   it is not null, returned as a colon separated concatenated string. Examples
#'   of login responses for the JSON API interactive endpoint can be found here:
#'
#'   \url{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Interactive+Login+-+API+Endpoint}
#'
#'   For error values, see:
#'
#'   \url{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Non-Interactive+\%28bot\%29+login}
#'
#' @section Note on \code{credentials} variable: This variable stores the
#'   defined Betfair username and password. R function objects are ephemeral.
#'   This variable dies immediately after function execution. Your Betfair
#'   username and password is not stored anywhere outside this function and
#'   details must always be passed to the function on execution.
#'
#' @section Notes on \code{product} and \code{token} envrionment variables:
#'   These two envrionment variables store the session based authentication
#'   token and product string. They are required for all other functions in this
#'   package.
#'
#' @examples
#' \dontrun{
#' loginBF(username = "YourBetfairUsername",
#'         password = "YourBetfairPassword",
#'         applicationKey = "YourBetfairAppKey"
#'         )
#'
#' # Login with self signed SSL Certificate
#' loginBF(username = "YourBetfairUsername",
#'         password = "YourBetfairPassword",
#'         applicationKey = "YourBetfairAppKey",
#'         sslVerify = FALSE
#'         )
#'
#' }
#'

loginBF <-
  function(username, password, applicationKey, sslVerify = TRUE) {
    credentials <-
      paste0("username=", username, "&password=", password)


    loginReturn =  tryCatch(
      httr::POST(url = "https://identitysso.betfair.com/api/login",
                 config = httr::config(ssl_verifypeer = sslVerify),
                 query = credentials,
                 httr::add_headers(Accept = "application/json", `X-Application` = applicationKey))
      ,error = function(cond) {
        print(cond)
        stop(cond)
      }
    )
    authenticationKey <- httr::content(loginReturn)

    # Set environment variables with authentication details
    Sys.setenv(product = authenticationKey$product)
    Sys.setenv(token = authenticationKey$token)

    # Ouput success/failure status and any error message
    return(paste0(authenticationKey$status,":",authenticationKey$error))
  }
