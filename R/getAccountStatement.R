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
#'   This function will convert NULL to 0 as it requires a value to increment in
#'   the loop where there are more than 100 records. Optional.
#'
#' @param fromRecordValue int. Specifies the first record that will be returned.
#'   Records start at index zero. Default parameter value is NULL, which Betfair
#'   interprets as 0. Optional.
#'
#' @param recordCountValue int. Specifies the maximum number of records to be
#'   returned. Note that there is a page size limit of 100. If the number is
#'   greater than 100 then the function will loop to gather all records. Optional
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
#' @param suppress Boolean. By default, this parameter is set to FALSE, meaning
#'   that a warning is posted when the getAccountStatement call throws an error.
#'   Changing this parameter to TRUE will suppress this warning.
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
#'   request. If the getAccountStatement call throws an error, a data frame
#'   containing error information is returned.
#'
#' @examples
#' \dontrun{
#' # Return all available records:
#' getAccountStatement()
#' }
#'

getAccountStatement <-
  function(localeString = NULL, fromRecordValue = 0,
           recordCountValue = NULL, fromDate = NULL, toDate = NULL,
           includeItemValue = NULL, walletValue = NULL, suppress = FALSE,
           flag = FALSE, sslVerify = TRUE) {
    options(stringsAsFactors = FALSE)

    pageSize <- 100

    recordCount <- 0
    moreRecords <- TRUE
    startRecordValue <- fromRecordValue

    accAllOrders <- data.frame()

    while(moreRecords){

      getAccStatOps <-
        data.frame(jsonrpc = "2.0", method = "AccountAPING/v1.0/getAccountStatement", id = "1")

      getAccStatOps$params <- data.frame(fromRecord = startRecordValue)


      getAccStatOps$params$locale <- localeString
      if(!is.null(recordCountValue)){
        getAccStatOps$params$recordCount <- min((recordCountValue - recordCount), pageSize)
      } else {
        getAccStatOps$params$recordCount <- recordCountValue
      }
      getAccStatOps$params$includeItem <- includeItemValue
      getAccStatOps$params$Wallet <- walletValue
      getAccStatOps$params$itemDateRange <- data.frame(from = "")
      getAccStatOps$params$itemDateRange$from <- fromDate
      getAccStatOps$params$itemDateRange$to <- toDate

      getAccStatOps <-
        getAccStatOps[c("jsonrpc", "method", "params", "id")]

      getAccStatOps <- jsonlite::toJSON(jsonlite::unbox(getAccStatOps))

      # Read Environment variables for authorisation details
      product <- Sys.getenv('product')
      token <- Sys.getenv('token')

      accOrder <- httr::content(
        httr::POST(url = "https://api.betfair.com/exchange/account/json-rpc/v1",
                   config = httr::config(ssl_verifypeer = sslVerify),
                   body = getAccStatOps,
                   httr::add_headers(Accept = "application/json",
                                     "X-Application" = product,
                                     "X-Authentication" = token)), as = "text", encoding = "UTF-8")

      accOrder <- jsonlite::fromJSON(accOrder)


      if (!is.null(accOrder$error)){
        if(!suppress)
          warning("Error- See output for details")
        return(as.data.frame(accOrder$error))}

      accNewOrders <- lapply(accOrder$result$accountStatement$itemClassData[, 1], jsonlite::fromJSON)
      accNewOrders <- lapply(accNewOrders, function(x) {	Map(function(z){ifelse(is.null(z), NA, z)},  x) })
      accNewOrders <- do.call(rbind, lapply(accNewOrders, data.frame))

      accLegacy <- accOrder$result$accountStatement$legacyData
      colnames(accLegacy) <- paste0("legacyData.",colnames(accLegacy))
      accNewOrders <- cbind(accOrder$result$accountStatement[, !(names(accOrder$result$accountStatement) %in% c("itemClassData", "legacyData"))], accNewOrders, accLegacy)
      row.names(accNewOrders) <- seq_len(nrow(accNewOrders))+startRecordValue

      if(nrow(accAllOrders)==0){
        accAllOrders <- accNewOrders
      } else {
        accAllOrders <- bind_rows(accAllOrders, accNewOrders)
      }

      recordCount <- nrow(accAllOrders)
      if(is.null(recordCountValue)){
        moreRecords <- accOrder$result$moreAvailable
      } else {
        moreRecords <- accOrder$result$moreAvailable & (recordCount < recordCountValue)
      }
      startRecordValue <- startRecordValue + pageSize
    }

    if (accOrder$result$moreAvailable & flag == TRUE)
      warning("Not all bets included in output- More bets available")
    return(accAllOrders)
  }
