#' Return listMarketTypes data
#'
#' \code{listMarketTypes} returns a list of valid market types.
#'
#' \code{listMarketTypes} returns a list of valid market types, based on the
#' \code{eventTypeIds} specified. Returned data includes market types and count
#' of available markets for the specified \code{eventTypeIds}.
#'
#' @seealso \code{\link{loginBF}}, which must be executed first.
#'
#' @param eventTypeIds eventTypeIds String. Restrict markets by event type
#'   associated with the market. (i.e., Football, Horse Racing, etc). Accepts
#'   multiple IDs (See examples). IDs can be obtained via
#'   \code{\link{listEventTypes}}, Required. No default.
#'
#' @return Response from Betfair is stored in listMarketTypes variable, which is
#'   then parsed from JSON as a list. Only the first item of this list contains
#'   the required market types.
#'
#' @section Note on \code{listMarketTypesOps} variable: The
#'   \code{listMarketTypesOps} variable is used to firstly build an R data frame
#'   containing all the data to be passed to Betfair, in order for the function
#'   to execute successfully. The data frame is then converted to JSON and
#'   included in the HTTP POST request.
#'
#' @examples
#' \dontrun{
#' # Return all market types for Horse Racing.
#' listMarketTypes(eventTypeIds = 7)
#'
#' # Return all market types for Football and Horse
#' Racing
#' listMarketTypes(eventTypeIds = c("1","7"))
#' }
#'

listMarketTypes <- function(eventTypeIds){

  listMarketTypesOps <- data.frame(jsonrpc = "2.0", method = "SportsAPING/v1.0/listMarketTypes", id = "1")

  listMarketTypesOps$params <- data.frame(filter = c(""))

  listMarketTypesOps$params$filter <- data.frame(eventTypeIds = c(""))

  listMarketTypesOps$params$filter$eventTypeIds <- list(eventTypeIds)

  listMarketTypesOps <- listMarketTypesOps[c("jsonrpc", "method", "params", "id")]

  listMarketTypesOps <- toJSON(listMarketTypesOps, pretty = TRUE)

  listMarketTypes <- as.list(fromJSON(postForm("https://api.betfair.com/exchange/betting/json-rpc/v1", .opts=list(postfields=listMarketTypesOps, httpheader=headersPostLogin))))

  as.data.frame(listMarketTypes$result[1])

}
