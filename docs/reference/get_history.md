# Get the daily price history of indices

Returns the daily prices of one or more stock market indices from Yahoo
Finance, in index points. Each index's history is kept on disk between R
sessions, and once it is more than an hour old only its last two weeks
are downloaded again, so calls are fast. The downloads of several
indices run at the same time. An index is priced on the days its
exchange trades, so weekends and holidays have no prices.

## Usage

``` r
get_history(labels, start_date = Sys.Date() - 365, indices = get_indices())
```

## Arguments

- labels:

  Character vector of index labels, such as "S&P 500", from the `label`
  column of
  [`get_indices()`](https://sedzinfo.github.io/golemstockindices/reference/get_indices.md).

- start_date:

  Date. The first day to get, a year ago by default.

- indices:

  Data frame of indices from
  [`get_indices()`](https://sedzinfo.github.io/golemstockindices/reference/get_indices.md),
  to look the labels up.

## Value

A data frame with one row per index and day, sorted by index and date,
with the `open`, `high`, `low`, `close` and `volume` columns,
`timestamp` as a Date and the `label`. Labels that match no index are
left out with a message, and `NULL` is returned when no label matches or
nothing could be downloaded.

## Examples

``` r
if (FALSE) { # interactive()
spx <- get_history("S&P 500", as.Date("2020-01-01"))
plot_timeseries(spx)

history <- get_history(c("S&P 500", "DAX", "Nikkei 225"))
plot_compare(normalize_prices(history))
}
```
