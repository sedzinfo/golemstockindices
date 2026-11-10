# Download the daily prices of an index

[`download_histories()`](https://sedzinfo.github.io/golemstockindices/reference/download_histories.md)
for one index.

## Usage

``` r
download_history(index, start_date)
```

## Arguments

- index:

  One row of
  [`get_indices()`](https://sedzinfo.github.io/golemstockindices/reference/get_indices.md).

- start_date:

  Date. The first day to download.

## Value

The prices, as described in
[`parse_chart()`](https://sedzinfo.github.io/golemstockindices/reference/parse_chart.md),
or `NULL` when nothing could be downloaded.

## Examples

``` r
if (FALSE) { # \dontrun{
golemstockindices:::download_history(get_indices()[1, ], Sys.Date() - 30)
} # }
```
