#' Perform a keepAlive action on the Betfair API.
#'
#' This function essentially refreshes the session token, which prevents
#' automatic session expiry and allows the user to continue to make calls to the
#' API. According to the official online documentation, the current session
#' timeout period is four hours (and just 20 mins for the Italian exchange)
#'
#' See
#' \link{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Keep+Alive}
#' for more information. Thus, make sure to call this function at least every
#' four hours to prevent session expiry.
#'
#' \code{keepAlive} refreshes your session token.Unlike other Betfair API calls,
#' there are no dangers associated with this function- it simply resets the
#' session expiry time.
#'
#' @seealso
#' \link{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Keep+Alive}
#' for general information on requesting keepAlive on the Betfair API.
#'
#' @seealso \code{\link{loginBF}}, which must be executed first, as this
#'   function requires a valid session token
#'
#' @param suppress Boolean. \code{RCurl::postForm} posts a warning due to . By
#'   default, this parameter is set to TRUE, meaning this warning is suppressed.
#'   Changing this parameter to FALSE will result in warnings being posted.
#'
#' @param sslVerify Boolean. This argument defaults to TRUE and is optional. In
#'   some cases, where users have a self signed SSL Certificate, for example
#'   they may be behind a proxy server, Betfair will fail login with "SSL
#'   certificate problem: self signed certificate in certificate chain". If this
#'   error occurs you may set sslVerify to FALSE. This does open a small
#'   security risk of a man-in-the-middle intercepting your login credentials.
#'
#' @return Similar to \code{\link{loginBF}}, the call output is parsed from JSON
#'   as a list, from which the status ("SUCCESS" or "FAIL") and error (if it is
#'   not null) are returned as a colon seperated concatenated string. For error
#'   values, see
#'   \link{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Keep+Alive}
#'
#'
#' @examples
#' \dontrun{
#'  keepAlive() refreshes the session token and resets the session expiry time
#'  with warnings suppressed, which, if successful, will return "SUCCESS:"
#'
#'  The following block shows how we might set up a loop to ensure keepAlive() is called
#'  within every 4 hours:
#'
#'  \code{
#'  start=Sys.time()
#'  while(TRUE){
#'  if(Sys.time()-start>14400){ # 14,400 seconds = 4 hours
#'    keepAlive()
#'    start=Sys.time()
#'  }
#'  # perform some API calls
#'  }}}
#'


keepAlive = function(suppress = TRUE,sslVerify = TRUE) {
  if (suppress)
    keepAlive <-
      suppressWarnings(as.list(jsonlite::fromJSON(
        RCurl::postForm(
          "https://identitysso.betfair.com/api/keepAlive", .opts = list(httpheader =
                                                                          headersPostLogin, ssl.verifypeer = sslVerify)
        )
      )))
  else
    (   keepAlive   =    as.list(jsonlite::fromJSON(
      RCurl::postForm(
        "https://identitysso.betfair.com/api/keepAlive", .opts = list(httpheader =
                                                                        headersPostLogin, ssl.verifypeer = sslVerify)
      )
    )))
  return(paste0(keepAlive$status,":",keepAlive$error))
}
