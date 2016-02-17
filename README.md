abettor
=======
[![Build Status](https://travis-ci.org/phillc73/abettor.svg?branch=master)](https://travis-ci.org/phillc73/abettor)

`abettor` is an R package for connecting to the online betting exchange Betfair, via their API-NG product, using JSON-RPC. The package can be used to retrieve market information, place bets, cancel bets and manage account information such as balance, statement and P&L.

The breadth of API calls covered is growing, although not yet complete. If your use case is not yet covered, raise an [issue](https://github.com/phillc73/abettor/issues) or write new functionality yourself. New contributors always welcome.

## Quick start

### Install

Install from GitLab

```r
# install.packages("devtools")
devtools::install_git("https://gitlab.com/phillc73/abettor.git")
library("abettor")
```
Or install from GitHub if you prefer (identical mirror of GitLab)

```r
# install.packages("devtools")
devtools::install_github("phillc73/abettor")
require("abettor")
```

### Obtain a Betfair Developer Application Key

Betfair provided instructions to obtain an Application Key are [available here](https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Application+Keys), or follow the steps in the Place a Bet Tutorial linked below.

The `abettor` package is an aid to developing Betfair applications in R. Developers will still need to apply for a [Betfair Software Vendor Licence](https://developer.betfair.com/default/api-s-and-services/vendor-program/vendor-program-overview/) should they wish to develop commercial software using this package. Personal use of the `abettor` package will only require a Betfair Application Key.

### Required Packages

Only two additional R packages are required.

```r
# Requires a minimum of version 1.95-4.3
require("RCurl")
# Requires a minimum of version 0.9.12
require("jsonlite")
```
### Place a Bet Tutorial

An initial tutorial describing how to place a bet with `abettor` is [available here](https://github.com/phillc73/abettor/blob/master/vignettes/abettor-placeBet.Rmd).

## Supported Functions

```r
?loginBF
?logoutBF
?listClearedOrders
?listCurrentOrders
?listEventTypes
?listEvents
?listCountries
?listMarketBook
?listMarketCatalogue
?listMarketTypes
?listMarketPandL
?placeOrders
?replaceOrders
?updateOrders
?cancelOrders
?checkBalance
?getAccountStatement
?keepAlive
```
Each function contains documented descriptions for their use and all supported arguments. Read them.

## Status

This package is under active development.

Current Version: 0.1.5

See [current release notes](https://github.com/phillc73/abettor/releases) for more details.

### Issues

Problems? Something just doesn't work?

[Submit issues here](https://github.com/phillc73/abettor/issues).

### To Do

* More functions!
* More error handling
* Support in-play betting with live prices
* Develop a Shiny web app for demonstration purposes
* See if `data.table` makes things quicker

## Links

* [Betfair Online Betting Exchange](https://www.betfair.com)
* [Betfair Developer Program](https://developer.betfair.com/)
* [Betfair Exchange API Documentation](https://developer.betfair.com/default/api-s-and-services/sports-api/)
* [Creator's Website](http://www.starkingdom.co.uk)
* [Creator on Twitter](https://twitter.com/_starkingdom)

## Disclaimer

The `abettor` package is provided with absolutely no warranty. All `abettor` functions have been tested and should work, but they may not work as you think they do. Betting can be fun and profitable, but also risky. Be sensible and read the documentation. 
