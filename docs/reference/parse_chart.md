# Read the daily prices of a Yahoo Finance answer

Days without a close, which Yahoo Finance has for some holidays, are
left out, and so is the last day while its market is still open, as its
close is not final yet. The dates are those of the exchange. Yahoo
Finance keeps the levels with the rounding errors of single precision,
such as 4554.97998046875 for 4554.98, so they are rounded to the 2
decimals indices are published with.

## Usage

``` r
parse_chart(json, index, now = Sys.time())
```

## Arguments

- json:

  The JSON text of the answer.

- index:

  One row of
  [`get_indices()`](https://sedzinfo.github.io/golemstockindices/reference/get_indices.md).

- now:

  The time to judge whether the market is open, now by default.

## Value

A data frame with a row per day, sorted by date: `label`, `timestamp` (a
Date), `open`, `high`, `low`, `close` and `volume`, or `NULL` when the
answer has no days.

## Examples

``` r
json <- paste0(
  '{"chart":{"result":[{"meta":{"gmtoffset":-18000,',
  '"currentTradingPeriod":{"regular":{"start":1704205800,"end":1704229200}}},',
  '"timestamp":[1704205800,1704292200],"indicators":{"quote":[{"open":[4745.2,4725.1],',
  '"high":[4754.3,4729.3],"low":[4722.7,4699.7],"close":[4742.8,4704.8],',
  '"volume":[3743050000,3950760000]}]}}],"error":null}}'
)
golemstockindices:::parse_chart(json, golemstockindices::get_indices()[1, ])
#>     label  timestamp   open   high    low  close     volume
#> 1 S&P 500 2024-01-02 4745.2 4754.3 4722.7 4742.8 3743050000
#> 2 S&P 500 2024-01-03 4725.1 4729.3 4699.7 4704.8 3950760000
```
