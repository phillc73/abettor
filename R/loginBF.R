#' Login to Betfair, interactive end point. This section is mostly a copy of the
#' orginal master version.
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
#' @return Response from Betfair will be stored in {loginReturn}. Examples of 
#'   login responses for the JSON API interactive endpoint can be found here:
#'   
#'   \url{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Interactive+Login+-+API+Endpoint}
#'   
#'   
#'   
#' @section Note on \code{credentials} variable: This variable stores the 
#'   defined Betfair username and password. R function objects are ephemeral. 
#'   This variable dies immediately after function execution. Your Betfair 
#'   username and password is not stored anywhere outside this function and 
#'   details must always be passed to the function on execution.
#'   
#' @section Note on \code{headersPostLogin} variable: This variable is global. 
#'   It stores the session based authentication token and is required for all 
#'   other functions in this package.
#'   
#' @return The call output is parsed from JSON as a list, from which the status
#'   ("SUCCESS" or "FAIL") and error (if it is not null) are returned as a colon
#'   seperated concatenated string. For error values, see
#'   \link{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Non-Interactive+%28bot%29+login}.
#'   
#'   
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


loginBF <- function(username, password, applicationKey, sslVerify = TRUE){
  credentials <- paste("username=",username,"&password=",password,sep="")
  
  headersLogin <- list('Accept' = 'application/json', 'X-Application' = applicationKey)
  
  loginReturn=  tryCatch(RCurl::postForm("https://identitysso.betfair.com/api/login", .opts=list(postfields=credentials, httpheader=headersLogin, ssl.verifypeer = sslVerify))
                         ,error=function(cond) {
                           print(cond)
                           stop(cond)
                         }
  )
  authenticationKey <- jsonlite::fromJSON(loginReturn)
  
  # Assigning a global variable with <<-, I'm giddy with mischievious excitement
  
  headersPostLogin <- NULL
  
  
  headersPostLogin <<- list('Accept' = 'application/json', 'X-Application' = authenticationKey$product, 'X-Authentication' = authenticationKey$token, 'Content-Type' = 'application/json')
  
  return(paste0(authenticationKey$status,":",authenticationKey$error))
}
