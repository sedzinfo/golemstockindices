# Download the daily prices of several indices at the same time

Asks Yahoo Finance for the daily prices of each index from its start
date to now, one request per index, all sent at once (see
[`fetch_all()`](https://sedzinfo.github.io/golemstockindices/reference/fetch_all.md)).
A failed download is reported as a message instead of an error, and the
other indices are still read.

## Usage

``` r
download_histories(indices, starts)
```

## Arguments

- indices:

  Rows of
  [`get_indices()`](https://sedzinfo.github.io/golemstockindices/reference/get_indices.md).

- starts:

  Dates, one per row: the first day to download.

## Value

A list with an element per row: the prices, as described in
[`parse_chart()`](https://sedzinfo.github.io/golemstockindices/reference/parse_chart.md),
or `NULL` when nothing could be downloaded.

## Examples

``` r
if (FALSE) { # \dontrun{
golemstockindices:::download_histories(get_indices()[1:3, ], rep(Sys.Date() - 30, 3))
} # }
```
