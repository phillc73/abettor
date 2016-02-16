#' Return market profit and loss
#'
#' \code{listMarketPandL} Retrieve profit and loss for a given list of OPEN
#' markets. The values are calculated using matched bets and optionally settled
#' bets
#'
#' @seealso \code{\link{loginBF}}, which must be executed first. Do NOT use the
#'   DELAY application key. The DELAY application key does not support price
#'   data.
#'
#' @seealso \code{\link{listClearedOrders}} to retrieve your profit and loss for
#'   CLOSED markets
#'
#'   Note that \code{listMarketPandL} does not include any information about the
#'   value of your bets on the markets e.g. value of profit/loss if you were to
#'   cashout at current prices. It simply returns the money you'd win/lose if
#'   specific selections were to win. If you wish to calculate your cashout
#'   position, then we'll need to design a new function combining
#'   \code{listCurrentOrders} and \code{listMarketBook} (it's on the to-do
#'   list).
#'
#' @param marketIds Vector<String>. A set of market ID strings from which the
#'   corresponding market profit and losses will be returned. According to the
#'   online documentation, this parameter is not required. However, setting it
#'   to null will return an empty data frame. So I suggest including market IDs
#'   in this parameter.
#'
#' @param includeSettledBetsValue Boolean. Option to include settled bets
#'   (partially settled markets only). This parameter defaults to NULL, which
#'   Betfair interprets as false. Optional.
#'
#' @param includeBspBetsValue Boolean. Option to include Betfair Starting Price
#'   (BSP) bets. This parameter defaults to NULL, which Betfair interprets as
#'   FALSE. Optional.
#'
#' @param netOfCommissionValue Boolean. Option to return profit and loss net of
#'   user's current commission rate for this market, including any special
#'   tariffs. This parameter defaults to NULL, which Betfair interprets as
#'   FALSE. Optional.
#'
#' @param sslVerify Boolean. This argument defaults to TRUE and is optional. In
#'   some cases, where users have a self signed SSL Certificate, for example
#'   they may be behind a proxy server, Betfair will fail login with "SSL
#'   certificate problem: self signed certificate in certificate chain". If this
#'   error occurs you may set sslVerify to FALSE. This does open a small
#'   security risk of a man-in-the-middle intercepting your login credentials.
#'
#' @param errorWarning Boolean. This argument defaults to FALSE and is optional.
#'   If set to TRUE, then, in the case of errors, the error details will be
#'   posted as a warning.
#'
#' @return Response from Betfair is stored in listPandL variable, which is then
#'   parsed from JSON as a data frame of at least two varialbes (more if the
#'   optional parameters are included). The first column records the market IDs,
#'   while the corresponding market P&Ls are stored within a list.
#'
#' @section Note on \code{listMarketBookOps} variable: The
#'   \code{listMarketBookOps} variable is used to firstly build an R data frame
#'   containing all the data to be passed to Betfair, in order for the function
#'   to execute successfully. The data frame is then converted to JSON and
#'   included in the HTTP POST request.
#'
#' @examples
#' \dontrun{
#' Return the P&L (net of comission) for the requested markets. This actual
#' market IDs are unlikely to work and are just for demonstration purposes.
#'
#' listMarketPandL(marketIds = c("1.122323121","1.123859413"),
#'                netOfCommission = TRUE)
#' }
#'


listMarketPandL <-
  function(marketIds = NULL,includeSettledBetsValue = NULL,includeBspBetsValue =
             NULL,netOfCommissionValue = NULL,sslVerify = TRUE,errorWarning = FALSE) {
    options(stringsAsFactors = FALSE)
    listPandLOps <-
      data.frame(jsonrpc = "2.0", method = "SportsAPING/v1.0/listMarketProfitAndLoss", id = "1")

    listPandLOps$params <- data.frame(includeSettledBetsValue = "")
    if (!is.null(marketIds))
      listPandLOps$params$marketIds <- list(c(marketIds))

    listPandLOps$params$includeSettledBets <- includeSettledBetsValue
    listPandLOps$params$includeBspBets <- includeBspBetsValue
    listPandLOps$params$netOfCommission <- netOfCommissionValue

    listPandLOps <- listPandLOps[c("jsonrpc", "method", "params", "id")]

    listPandLOps <- jsonlite::toJSON(listPandLOps, pretty = TRUE)

    listPandL <-
      jsonlite::fromJSON(
        RCurl::postForm(
          "https://api.betfair.com/exchange/betting/json-rpc/v1", .opts = list(
            postfields = listPandLOps, httpheader = headersPostLogin, ssl.verifypeer = TRUE
          )
        )
      )
    if (errorWarning) {
      if (!is.null(listPandL$error))
        warning(
          paste0(
            "FAIL: ",listPandL$error$data$APINGException$errorCode," (",listPandL$error$data$APINGException$errorDetails,")"
          )
        )
    }
    as.data.frame(listPandL$result)

  }
