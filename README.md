abettor
=======

`abettor` is an R package for connecting to the online betting exchange Betfair, via their API-NG product, using JSON-RPC. The package can currently only be used to retrieve market information and place bets.

This package deliberately does not provide comprehensive R functions for the entirety of Betfair's API-NG product. The functions which are supported generally use limited arguments. The idea being to return a broader set of Betfair data, which can be manipulated by the user from within R, using familiar code and providing fine grained control.

## Quick start

### Install

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
?listEventTypes
?listEvents
?listCountries
?listMarketBook
?listMarketCatalogue
?listMarketTypes
?placeOrders
```
Each function contains documented descriptions for their use and all supported arguments. Read them.

## Status

This package is under active development.

Current Version: 0.1.1

### Issues

Problems? Something just doesn't work?

[Submit issues here](https://github.com/phillc73/abettor/issues).

### To Do

* Cancel Bet Functions
* Account Management Functions
* More functions!
* Graceful error handling
* Develop a Shiny web app for demonstration purposes
* See if `data.table` makes things quicker

## Links

* [Betfair Online Betting Exchange](https://www.betfair.com)
* [Betfair Developer Program](https://developer.betfair.com/)
* [Betfair Exchange API Documentation](https://developer.betfair.com/default/api-s-and-services/sports-api/)
* [Author's Website](http://www.starkingdom.co.uk)
* [Author on Twitter](https://twitter.com/_starkingdom)

## Disclaimer

The `abettor` package is provided with absolutely no warranty. All `abettor` functions have been tested and should work, but they may not work as you think they do. Betting can be fun and profitable, but also risky. Be sensible and read the documentation. 
