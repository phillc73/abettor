#'Return Current Orders data
#'
#'\code{listCurrentOrders} returns all matched and unmatched bets for all
#'markets or specific markets. It is also possible to filter the results
#'according to bet IDs and date intervals.
#'
#'@seealso \code{\link{loginBF}}, which must be executed first. Do NOT use the
#'  DELAY application key. The DELAY application key does not support price
#'  data.
#'
#'@param marketIds String. A list of market ID strings from which the
#'  corresponding current orders will be returned. Optional. Default is set to
#'  NULL.
#'
#'@param betIds Vector<string>. Restrict the results to the specified bet IDs
#'  (e.g. c("61529884133","61529884472")). Optional. Default is set to NULL.
#'
#'@param orderByValue string. Specifies how the results will be ordered. The
#'  default value is NULL, which Betfair interprets as "BY_BET" (order by bet
#'  ID).  Also acts as a filter such that only orders with a valid value in the
#'  field being ordered by will be returned (i.e. BY_VOID_TIME returns only
#'  voided orders, "BY_SETTLED_TIME" (applies to partially settled markets)
#'  returns only settled orders and "BY_MATCH_TIME" returns only orders with a
#'  matched date (voided, settled, matched orders)). The remaaining alternative
#'  values are "BY_MARKET" (Order by market id, then placed time, then bet id)
#'  and "BY_PLACE_TIME" (Order by placed time, then bet id). The context of the
#'  date filter applied by the dateRange parameter (placed, matched, voided or
#'  settled date) - see toDate and FromDate for more information. See also the
#'  OrderByValue parameter description.
#'
#'@param SortDirValue string. Specifies the direction in which the results will
#'  be sorted. The default value is NULL, which Betfair interprets as
#'  "EARLIEST_TO_LATEST". The alternative value is "LATEST_TO_EARLIEST".
#'  Optional.
#'
#'
#'@param toDate Datetime (ISO 8601 format). Lower bound of date range
#'  (inclusive). Default value is NULL, which means that the oldest available
#'  items will be in range. Optional. Default is set to NULL.
#'
#'@param fromDate Datetime (ISO 8601 format). Upper bound of date range
#'  (inclusive). Default value is NULL, which means that the latest available
#'  items will be in range. Optional. Default is set to NULL.
#'
#'@param orderProjectionValue string. Restricts the results to the specified
#'  order status. Possible values are: "EXECUTABLE" (An order that has a
#'  remaining unmatched portion); "EXECUTION_COMPLETE" (An order that does not
#'  have any remaining unmatched portion); "ALL" (EXECUTABLE and
#'  EXECUTION_COMPLETE orders). Default value is NULL, which Betfair interprets
#'  as "ALL". Optional.
#'
#'@param customerOrderRefs List<String>. Optionally restricts the results to the
#'specified customerOrderRefs.
#'
#'@param customerStrategyRefs List<String>. Optionally restricts the results to the
#'specified customerStrategyRefs.
#'
#'@param fromRecordValue int. Specifies the first record that will be returned.
#'  Records start at index zero. Default parameter value is NULL, which Betfair
#'  interprets as 0. Optional. Default is set to NULL.
#'
#'@param recordCountValue int. Specifies the maximum number of records to be
#'  returned. To retrieve more than 1000 records (the maxiumum by default), you
#'  need to utilise this parameter. Optional. Default is set to NULL.
#'
#'@param flag Boolean. \code{RCurl::postForm} returns a warning if there's more
#'  records than the limit of 1000 (or limit specified by the record parameters)
#'  that can be returned in one call. By default, this parameter is set to
#'  FALSE, meaning this warning is not flagged. Changing this parameter to TRUE
#'  will result in warnings being posted.
#'
#'@param suppress Boolean. By default, this parameter is set to FALSE, meaning
#'  that a warning is posted when the listCurrentOrders call throws an error.
#'  Changing this parameter to TRUE will suppress this warning.
#'
#'@param sslVerify Boolean. This argument defaults to TRUE and is optional. In
#'  some cases, where users have a self signed SSL Certificate, for example they
#'  may be behind a proxy server, Betfair will fail login with "SSL certificate
#'  problem: self signed certificate in certificate chain". If this error occurs
#'  you may set sslVerify to FALSE. This does open a small security risk of a
#'  man-in-the-middle intercepting your login credentials.
#'
#'@return Response from Betfair is stored in currentOrders variable, which is
#'  then parsed from JSON as a list. Only the first item of this list contains
#'  the required event type identification details.
#'
#'
#'@section Note on \code{listOrderOps} variable: The \code{listOrderOps}
#'  variable is used to firstly build an R data frame containing all the data to
#'  be passed to Betfair, in order for the function to execute successfully. The
#'  data frame is then converted to JSON and included in the HTTP POST request.
#'  If the listCurrentOrders call throws an error, a data frame containing error
#'  information is returned.
#'
#' @examples
#' \dontrun{
#'  Return all current orders:
#' listCurrentOrders()
#'  Return all voided bets:
#' listCurrentOrders(orderByValue="BY_VOID_TIME")
#' }
#'

listCurrentOrders <-
  function(betIds = NULL, marketIds = NULL,orderByValue = NULL, SortDirValue = NULL,
           fromDate = NULL, toDate = NULL, flag = FALSE, orderProjectionValue = NULL,
           customerOrderRefs = NULL, customerStrategyRefs = NULL,
           fromRecordValue = NULL, recordCountValue = NULL, suppress = FALSE, sslVerify = TRUE) {
    options(stringsAsFactors = FALSE)

    listOrderOps <-
      data.frame(jsonrpc = "2.0", method = "SportsAPING/v1.0/listCurrentOrders", id = "1")

    listOrderOps$params <- data.frame(orderProjection = "")
    if (!is.null(betIds))
      listOrderOps$params$betIds <- list(c(betIds))
    if (!is.null(marketIds))
      listOrderOps$params$marketIds <- list(c(marketIds))

    listOrderOps$params$orderProjection <- orderProjectionValue
    listOrderOps$params$customerOrderRefs <- customerOrderRefs
    listOrderOps$params$customerStrategyRefs <- customerStrategyRefs
    listOrderOps$params$orderBy <- orderByValue
    listOrderOps$params$SortDir <- SortDirValue
    listOrderOps$params$fromRecord <- fromRecordValue
    listOrderOps$params$recordCount <- recordCountValue
    if (!is.null(fromDate) & !is.null(toDate))
      listOrderOps$params$daterange <-
      data.frame(from = fromDate, to = toDate)

    listOrderOps <-
      listOrderOps[c("jsonrpc", "method", "params", "id")]

    listOrderOps <- jsonlite::toJSON(jsonlite::unbox(listOrderOps))

    # Read Environment variables for authorisation details
    product <- Sys.getenv('product')
    token <- Sys.getenv('token')

    listOrder <- httr::content(
      httr::POST(url = "https://api.betfair.com/exchange/betting/json-rpc/v1",
                 config = httr::config(ssl_verifypeer = sslVerify),
                 body = listOrderOps,
                 httr::add_headers(Accept = "application/json",
                                   "X-Application" = product,
                                   "X-Authentication" = token)), as = "text", encoding = "UTF-8")

    listOrder <- jsonlite::fromJSON(listOrder)


    if (!is.null(listOrder$error)){
      if(!suppress)
        warning("Error- See output for details")
      return(as.data.frame(listOrder$error))}
    if (listOrder$result$moreAvailable && flag == TRUE)
      warning("Not all bets included in output- More bets available")
    as.data.frame(listOrder$result$currentOrders)

  }
