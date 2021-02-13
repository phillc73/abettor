abettor
=======
[![Build Status](https://travis-ci.org/phillc73/abettor.svg?branch=master)](https://travis-ci.org/phillc73/abettor)

`abettor` is an R package for connecting to the online betting exchange Betfair, via their API-NG product, using JSON-RPC. The package can be used to retrieve market information, place bets, cancel bets and manage account information such as balance, statement and P&L.

The breadth of API calls covered is growing, although not yet complete. If your use case is not yet covered, raise an [issue](https://github.com/phillc73/abettor/issues) or write new functionality yourself. New contributors always welcome.

## Quick start

### Install

Install from GitLab

```r
# install.packages("remotes")
library("remotes")
remotes::install_gitlab("phillc73/abettor")
library("abettor")
```
Or install from GitHub if you prefer (identical mirror of GitLab)

```r
# install.packages("remotes")
library("remotes")
remotes::install_github("phillc73/abettor")
library("abettor")
```

### Obtain a Betfair Developer Application Key

Betfair provided instructions to obtain an Application Key are [available here](https://docs.developer.betfair.com/display/1smk3cen4v3lu3yomq5qye0ni/Application+Keys), or follow the steps in the Place a Bet Tutorial linked below.

The `abettor` package is an aid to developing Betfair applications in R. Developers will still need to apply for a [Betfair Software Vendor Licence](https://developer.betfair.com/en/vendor-program/the-process/) should they wish to develop commercial software using this package. Personal use of the `abettor` package will only require a Betfair Application Key.

### Required Packages

Only two additional R packages are required.

```r
# Requires a minimum of version 1.7.2
library("jsonlite")
# Requires a minimum of version 1.4.2
library("httr")
```
### Tutorials

 - An initial tutorial describing how to place a bet with `abettor` is [available here](https://github.com/phillc73/abettor/blob/master/vignettes/abettor-placeBet.Rmd).

- [Betfair API tutorials in R](https://betfair-datascientists.github.io/api/apiRtutorial/) - an excellent series of tutorials using `abettor` from the [data science team](https://github.com/betfair-datascientists) at Betfair Australia. Their [Awesome Betfair](https://github.com/betfair-down-under/AwesomeBetfair) page is also worth reading.

## Supported Functions

```r
?loginBF
?logoutBF
?listClearedOrders
?listCompetitions
?listCurrentOrders
?listEventTypes
?listEvents
?listCountries
?listMarketBook
?listMarketCatalogue
?listMarketTypes
?listMarketPandL
?listVenues
?placeOrders
?replaceOrders
?updateOrders
?cancelOrders
?checkBalance
?getAccountStatement
?keepAlive
?listRunnerBook
?listTimeRanges
?listCurrencyRates
?getAccountDetails
?listRaceDetails
?heartbeat
```
Each function contains documented descriptions for their use and all supported arguments. Read them.

## Status

This package is under sporadic development.

### Issues

Problems? Something just doesn't work?

[Submit issues here](https://github.com/phillc73/abettor/issues).

### To Do

* More functions!
* More error handling
* Support in-play betting with live prices

## Links

* [Betfair Online Betting Exchange](https://www.betfair.com/exchange)
* [Betfair Developer Program](https://developer.betfair.com/)
* [Betfair Exchange API Documentation](https://docs.developer.betfair.com/display/1smk3cen4v3lu3yomq5qye0ni)

## Disclaimer

The `abettor` package is provided with absolutely no warranty. All `abettor` functions have been tested and should work, but they may not work as you think they do. Betting can be fun and profitable, but also risky. Be sensible and read the documentation. 
