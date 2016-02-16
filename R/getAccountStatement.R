#' Get Account Statement
#'
#' \code{getAccountStatement} returns an account statement via the Betfair API.
#'
#' @seealso \code{\link{loginBF}}, which must be executed first. Do NOT use the
#'   DELAY application key. The DELAY application key does not support price
#'   data.
#'
#' @param localeString String. The language to be used where applicable. If not
#'   specified, the customer account default is returned. Default is NULL.
#'   Optional.
#'
#' @param fromRecordValue int. Specifies the first record that will be returned.
#'   Records start at index zero. Default parameter value is NULL, which Betfair
#'   interprets as 0. Optional.
#'
#' @param recordCountValue int. Specifies the maximum number of records to be
#'   returned. Note that there is a page size limit of 100.
#'
#' @param toDate Datetime (ISO 8601 format). Lower bound of date range
#'   (inclusive). Default value is NULL, which means that the oldest available
#'   items will be in range. This itemDataRange is currently only applied when
#'   includeItem is set to ALL or not specified, else items are NOT bound by
#'   itemDate. Optional.
#'
#' @param fromDate Datetime (ISO 8601 format). Upper bound of date range
#'   (inclusive). Default value is NULL, which means that the latest available
#'   items will be in range. This parameter is currently only applied when
#'   includeItem is set to ALL or not specified, else items are NOT bound by
#'   itemDate. Optional.
#'
#' @param includeItemValue string. Determines Which items are include. The default
#'   value is NULL, which Betfair interprets as "ALL" (include all items). THe
#'   alternative values are "DEPOSITS_WITHDRAWALS" (include payments only),
#'   "EXCHANGE" (include exchange bets only) and "POKER_ROOM" (include poker
#'   transactions only). Optional.
#'
#' @param walletValue string. Specifies from Which wallet to return statementItems.
#'   The default value is NULL, which returns UK wallet info. THe alternative
#'   value is "AUSTRALIAN", which corresponds to the Austrailian wallet.
#'   Optional.
#'
#' @param flag Boolean. \code{RCurl::postForm} returns a warning if there's more
#'   records than the limit of 100 that can be returned in one call. By default,
#'   this parameter is set to FALSE, meaning this warning is not flagged.
#'   Changing this parameter to TRUE will result in warnings being posted.
#'
#' @param sslVerify Boolean. This argument defaults to TRUE and is optional. In
#'   some cases, where users have a self signed SSL Certificate, for example
#'   they may be behind a proxy server, Betfair will fail login with "SSL
#'   certificate problem: self signed certificate in certificate chain". If this
#'   error occurs you may set sslVerify to FALSE. This does open a small
#'   security risk of a man-in-the-middle intercepting your login credentials.
#'
#' @return Response from Betfair is stored in Account Statement variable, which
#'   is then parsed from JSON as a data frame.
#'
#' @section Note on \code{getAccStatOps} variable: The \code{getAccStatOps}
#'   variable is used to firstly build an R data frame containing all the data
#'   to be passed to Betfair, in order for the function to execute successfully.
#'   The data frame is then converted to JSON and included in the HTTP POST
#'   request.
#'
#' @examples
#' \dontrun{
#' # Return the latest 100 records:
#' getAccountStatement()
#' }
#'

getAccountStatement <-
  function(localeString = NULL,fromRecordValue = NULL,recordCountValue =
             NULL,fromDate = NULL, toDate = NULL,
           includeItemValue = NULL, walletValue = NULL, flag =
             FALSE, sslVerify = TRUE) {
    options(stringsAsFactors = FALSE)
    getAccStatOps <-
      data.frame(jsonrpc = "2.0", method = "AccountAPING/v1.0/getAccountStatement", id = "1")

    getAccStatOps$params <- data.frame(fromRecord = "")
    getAccStatOps$params$locale <- localeString
    getAccStatOps$params$fromRecord <- fromRecordValue
    getAccStatOps$params$recordCount <- recordCountValue
    getAccStatOps$params$includeItem <- includeItemValue
    getAccStatOps$params$Wallet <- walletValue
    getAccStatOps$params$daterange <- data.frame(from = "")
    getAccStatOps$params$daterange$from <- fromDate
    getAccStatOps$params$daterange$to <- toDate

    getAccStatOps <-
      getAccStatOps[c("jsonrpc", "method", "params", "id")]

    getAccStatOps <- jsonlite::toJSON(getAccStatOps, pretty = TRUE)
    AccOrder <-
      jsonlite::fromJSON(
        RCurl::postForm(
          "https://api.betfair.com/exchange/account/json-rpc/v1", .opts = list(
            postfields = getAccStatOps, httpheader = headersPostLogin, ssl.verifypeer = TRUE
          )
        )
      )
    if (!is.null(AccOrder$error))
      return(paste0("FAIL: ",AccOrder$error$message))
    if (AccOrder$result$moreAvailable & flag == TRUE)
      warning("Not all bets included in output- More bets available")
    as.data.frame(AccOrder$result$accountStatement)

  }
