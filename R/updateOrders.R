#' Change bet persistence type
#'
#' \url{https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/updateOrders}
#'
#' \code{updateOrders} changes the persistence type of a specific unmatched bet.
#'
#' @seealso \code{\link{loginBF}}, which must be executed first. Do NOT use the
#'   DELAY application key. The DELAY application key does not support price
#'   data.
#'
#' @param marketId String. The market ID of the bets to be updated. While many
#'   bets can be updated in one call, they must be from the same market. Required.
#'   No default.
#'
#' @param betId vector (strings). The bet IDs of the bets to be updated- bet IDs
#'   are displayed (called Ref) on the bet information on the right hand side of
#'   market page on the betfair desktop site. Required. No default.
#'
#' @param persistenceType vector (strings). The persistence state of updated
#'   bets. persistanceType can take three values ("LAPSE","PERSIST" and
#'   "MARKET_ON_CLOSE", which correspond to Cancel, Keep and
#'   Take SP on the desktop website). Required. No default.
#'
#'@param suppress Boolean. By default, this parameter is set to FALSE, meaning
#'   that a warning is posted when the updateOrders call throws an error. Changing
#'   this parameter to TRUE will suppress this warning.
#'
#'@param sslVerify Boolean. This argument defaults to TRUE and is optional. In
#'   some cases, where users have a self signed SSL Certificate, for example
#'   they may be behind a proxy server, Betfair will fail login with "SSL
#'   certificate problem: self signed certificate in certificate chain". If this
#'   error occurs you may set sslVerify to FALSE. This does open a small
#'   security risk of a man-in-the-middle intercepting your login credentials.
#'
#' @return Response from Betfair is stored in updateOrders variable, which
#'  is then parsed from JSON as a list. The status column recognises whether
#'  the call was successful. If the updateOrders call throws an error, a data
#'  frame containing error information is returned. Note that there are two types
#'  of error associated with this call. An API error is triggered, for example,
#'  when an invalid market ID is entered. Another type of error is returned if
#'  no action is required (e.g. call to set to PERSIST for a bet that is
#'  already set to PERSIST).
#'
#'
#' @section Note on \code{updateOrders}: Unlike some other functions that
#'   utilised data frames, this function converts the input to a JSON-compatible
#'   format. The JSON output is then converted back to a data frame.
#'
#' @examples
#' \dontrun{
#' # Update two bets on the same market so that they will persist in play.
#' The following variables are for illustrative purposes and don't represent
#' actual Betfair IDs:
#'
#' updateOrders(marketId = "1.10271480",
#'             betID = c("61385423029","61385459133"),
#'             persistenceType = c("PERSIST","PERSIST")
#'             )
#'
#' Note that if you run this function again, it will return an error
#' (BET_ACTION_ERROR (NO_ACTION_REQUIRED)) as the bets are already set to "PERSIST".
#'
#' Now, if you run the function for a third time, but with one "LAPSE" and one
#' "PERSIST", it will again return a different error (PROCESSED_WITH_ERRORS).
#' This is because all bets need to be successful to return "SUCCESS".
#' Please note, however, that the viable bet IDs will have been succesfully updated
#' i.e. it's not an all or nothing process but rather each update is treated
#' individually (unlike \code{replaceOrders}).
#'
#' }
#'

updateOrders <-
  function(marketId, betId, persistenceType, suppress = FALSE, sslVerify = TRUE) {
    options(stringsAsFactors = FALSE)

    if (length(betId) != length(persistenceType))
      return("Bet ID and Persistence Type vector need to have the same length")

    updateOrderOps <-
      paste0(
        '[{"jsonrpc": "2.0","method": "SportsAPING/v1.0/updateOrders","params":{"marketId": "',marketId,'","instructions": [',
        paste0(sapply(as.data.frame(t(data.frame(
          betId, persistenceType
        ))),function(x)
          paste0('{"betId":"',x[1],'","newPersistenceType":"',x[2],'"}')),collapse =
          ","),']},"id": "1"}]'
      )

    # Read Environment variables for authorisation details
    product <- Sys.getenv('product')
    token <- Sys.getenv('token')

    updateOrder <- httr::content(
      httr::POST(url = "https://api.betfair.com/exchange/betting/json-rpc/v1",
                 config = httr::config(ssl_verifypeer = sslVerify),
                 body = updateOrderOps,
                 httr::add_headers(Accept = "application/json",
                                   "X-Application" = product,
                                   "X-Authentication" = token)), as = "text", encoding = "UTF-8")

    updateOrder <- jsonlite::fromJSON(updateOrder)

    if(is.null(updateOrder$error)){
      if(!is.null(updateOrder$result$errorCode) & !suppress)
          warning("Error- See output for details")
          as.data.frame(updateOrder$result)}
    else({
      if(!suppress)
        warning("API Error- See output for details")
      as.data.frame(updateOrder$error)})
  }
