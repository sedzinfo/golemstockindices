# Daily exchange rates against the US dollar

The rates of Yahoo Finance, such as `EUR=X`, the euros a US dollar buys,
from as far back as it has them: 1996 for the yen, 2001 to 2006 for the
other currencies. They are downloaded, kept on disk and brought up to
date like the prices of the indices (see
[`index_histories()`](https://sedzinfo.github.io/golemstockindices/reference/index_histories.md)).
The rates of weekends, when the currency markets are closed and Yahoo
Finance has a few stray ones, are left out, and so are those far from
the rates around them (see
[`bad_rates()`](https://sedzinfo.github.io/golemstockindices/reference/bad_rates.md)).

## Usage

``` r
currency_rates(currencies)
```

## Arguments

- currencies:

  Character vector of currency codes, such as "EUR". The US dollar,
  which needs no rate, and `NA` are left out.

## Value

A data frame with a row per currency and day: `currency`, `timestamp` (a
Date) and `per_usd`, the units of the currency a US dollar buys. A
currency whose rates cannot be downloaded has no rows.

## Examples

``` r
if (FALSE) { # \dontrun{
golemstockindices:::currency_rates(c("EUR", "JPY"))
} # }
```
