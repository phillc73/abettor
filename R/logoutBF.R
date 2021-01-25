#' Logout from the Betfair API.
#'
#' \code{logoutBF} terminates the current session. \code{\link{loginBF}} will
#' need to be called again before any further actions can be performed.
#'
#' \code{logoutBF} terminates the current session. \code{\link{loginBF}} will
#' need to be called again before any further actions can be performed.
#'
#' @seealso
#'   \url{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Logout}
#'    for general information on requesting Logout on the Betfair API.
#'
#' @seealso \code{\link{loginBF}}, which must be executed first, as this
#'   function requires a valid session token
#'
#' @param suppress Boolean. \code{RCurl::postForm} posts a warning due to a
#'   lack of inputs. By default, this parameter is set to TRUE, meaning this
#'   warning is suppressed. Changing this parameter to FALSE will result in warnings
#'   being posted.
#'
#' @param sslVerify Boolean. This argument defaults to TRUE and is optional. In
#'   some cases, where users have a self signed SSL Certificate, for example
#'   they may be behind a proxy server, Betfair will fail login with "SSL
#'   certificate problem: self signed certificate in certificate chain". If this
#'   error occurs you may set sslVerify to FALSE. This does open a small
#'   security risk of a man-in-the-middle intercepting your login credentials.
#'
#' @return Similar to \code{\link{loginBF}}, the call output is parsed from JSON
#'   as a list, from which the statuses SUCCESS or FAIL and error, if it is
#'   not null are returned as a colon seperated concatenated string. For error
#'   values, see
#'   \url{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Logout}.
#'
#' @examples
#' \dontrun{
#' loginBF("username","password","appKey")
#' logoutBF()
#' logoutBF()
#'
#' The last logout in this block will return an error. The first logout terminates
#' the session, meaning there is no session to end on the second logout request.
#'  }
#'

logoutBF = function(suppress = TRUE, sslVerify = TRUE) {

  # Read Environment variables for authorisation details
  product <- Sys.getenv('product')
  token <- Sys.getenv('token')

  if (suppress)
    logout <-
      suppressWarnings(logout <- httr::content(
      httr::POST(url = "https://identitysso.betfair.com/api/logout",
                 httr::add_headers(Accept = "application/json",
                 "X-Application" = product,
                 "X-Authentication" = token)), as = "text", encoding = "UTF-8")
                 )
  else
    (logout <- httr::content(
      httr::POST(url = "https://identitysso.betfair.com/api/logout",
                 httr::add_headers(Accept = "application/json",
                 "X-Application" = product,
                 "X-Authentication" = token)), as = "text", encoding = "UTF-8")
                 )

logout_result <- as.list(strsplit(logout, ":")[[1]])

success_fail <- gsub("[[:punct:][:blank:]]", "", logout_result[4])
success_fail <- gsub("error", "", success_fail)

error_msg <- gsub('[\\\\}"]', "", logout_result[5])

return(paste0(success_fail,":",error_msg))

}
