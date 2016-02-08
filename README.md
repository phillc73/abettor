abettor
=======

I'm very new to Github, so I'm still coming to terms with forking, pulling and other verbs.

`abettor` is an R package for connecting to the online betting exchange Betfair, via their API-NG product, using JSON-RPC. The package can currently only be used to retrieve market information and place bets.

Unlike the original version ([phillc73/abettor](https://github.com/phillc73/abettor)), this fork intends to provide R functions for the entirety of Betfair's API-NG product, which encompasses all explicit supported API-NG requests and derivative calls (e.g. market cashout). Alert me to any bugs and please send me your requests. Like I said, I want this package to be comprehensive, so let me if there's something you want to see.

The package is still in development, so please check back regularly for updates. It draws heavily from the [original](https://github.com/phillc73/abettor), so also consult that page for more details.

## Quick start

### Install

```r
# install.packages("devtools")
devtools::install_github("dashee/abettor")
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

Current Version: 0.1.3

See [current release notes](https://github.com/phillc73/abettor/releases) for more details.

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
