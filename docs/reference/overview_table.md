# Table of where the indices stand

A table with a row per index of
[`index_summary()`](https://sedzinfo.github.io/golemstockindices/reference/index_summary.md),
in the order of
[`get_indices()`](https://sedzinfo.github.io/golemstockindices/reference/get_indices.md):
its region, last close and its date, the change on the day, this year
and over a year, how far it is below its all-time high, that high and
its date, the currency of its shares and the first day of its history.
The changes are shaded red for falls and green for rises, each column on
its own scale, as a day's moves are much smaller than a year's, and the
distance from the high red, more strongly the further it is. Given the
history, a column after the close draws the last year of each index as a
small line (see
[`sparkline_svg()`](https://sedzinfo.github.io/golemstockindices/reference/sparkline_svg.md)).

## Usage

``` r
overview_table(summary, indices = get_indices(), history = NULL)
```

## Arguments

- summary:

  The result of
  [`index_summary()`](https://sedzinfo.github.io/golemstockindices/reference/index_summary.md).

- indices:

  Data frame of indices from
  [`get_indices()`](https://sedzinfo.github.io/golemstockindices/reference/get_indices.md),
  for the regions and currencies.

- history:

  The price history the summary was made from, for the lines of the last
  year, or `NULL` for none.

## Value

A DT datatable.

## Examples

``` r
if (FALSE) { # interactive()
indices <- get_indices()
history <- get_history(indices$label[1:3], as.Date("1900-01-01"))
overview_table(index_summary(history), indices, history)
}
```
