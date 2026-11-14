# Exchange rates that are far from the rates around them

The daily rates of Yahoo Finance have errors on a few days, some of them
wild, such as a Taiwan dollar worth 16 times as much on 24 October 2011,
or a run of days of late 2013 that put the rupiah 18% off. A rate more
than 15% away from the median of the 21 trading days around it is left
out, and of the rest, a rate more than 8% away from the median of the 7
trading days around it. A real jump, such as that of the Swiss franc
when its cap on the euro ended in January 2015, takes the median with
it, so it stays. The first and last days of the history, which have no
days on both sides, are kept.

## Usage

``` r
bad_rates(rate)
```

## Arguments

- rate:

  Numeric vector of the daily rates of a currency, sorted by date,
  without `NA`.

## Value

A logical vector as long as `rate`, `TRUE` for the rates to leave out.

## Examples

``` r
rate <- c(rep(1.02, 15), rep(0.86, 15))
rate[22] <- 0.086
which(golemstockindices:::bad_rates(rate))
#> [1] 22
```
