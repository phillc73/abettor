#' Return listCountries data
#'
#' \code{listCountries} returns a list of two letter country codes.
#'
#' \code{listCountries} returns a list of two letter country codes.
#' \code{eventTypeIds} is required to limit list to specific event types. e.g.
#' Horse Racing. Returned data includes country codes and count of available
#' markets in each country, for the specified \code{eventTypeIds}. A complete
#' list of valid two letter ISO country codes used by Betfair may be found at
#' the following location:
#'
#' \url{http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2#Officially_assigned_code_elements}
#'
#' @seealso \code{\link{loginBF}}, which must be executed first.
#'
#' @param eventTypeIds String. Restrict markets by event type associated with
#'   the market. (i.e., Football, Horse Racing, etc). Accepts multiple IDs (See
#'   examples). IDs can be obtained via \code{\link{listEventTypes}}, Required. No
#'   default.
#'
#' @return Response from Betfair is stored in listCountries variable, which is
#'   then parsed from JSON as a list. Only the first item of this list contains
#'   the required country identification codes.
#'
#' @section Note on \code{listCountriesOps} variable: The
#'   \code{listCountriesOps} variable is used to firstly build an R data frame
#'   containing all the data to be passed to Betfair, in order for the function
#'   to execute successfully. The data frame is then converted to JSON and
#'   included in the HTTP POST request.
#'
#' @examples
#' \dontrun{
#' # Return all current country codes and market depth for Horse Racing.
#' listCountries(eventTypeIds = 7)
#'
#' # Return all current country codes and market depth for Football and Horse
#' Racing
#' listCountries(eventTypeIds = c("1","7"))
#' }
#'

listCountries <- function(eventTypeIds){

  listCountriesOps <- data.frame(jsonrpc = "2.0", method = "SportsAPING/v1.0/listCountries", id = "1")

  listCountriesOps$params <- data.frame(filter = c(""))

  listCountriesOps$params$filter <- data.frame(eventTypeIds = c(""))

  listCountriesOps$params$filter$eventTypeIds <- list(eventTypeIds)

  listCountriesOps <- listCountriesOps[c("jsonrpc", "method", "params", "id")]

  listCountriesOps <- jsonlite::toJSON(listCountriesOps, pretty = TRUE)

  listCountries <- as.list(jsonlite::fromJSON(RCurl::postForm("https://api.betfair.com/exchange/betting/json-rpc/v1", .opts=list(postfields=listCountriesOps, httpheader=headersPostLogin))))

  as.data.frame(listCountries$result[1])

}
