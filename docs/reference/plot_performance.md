# Performance of the indices over a period

One horizontal bar per index, its change over the period in percent,
green for rises and red for falls, the best at the top, from
[`performance_data()`](https://sedzinfo.github.io/golemstockindices/reference/performance_data.md).
The VIX is left out: it measures the fear in the market rather than the
value of shares, and its swings of tens of percent would squeeze the
others.

## Usage

``` r
plot_performance(
  summary,
  indices = get_indices(),
  period = c("day", "week", "month", "ytd", "year"),
  mode = "light"
)
```

## Arguments

- summary:

  The result of
  [`index_summary()`](https://sedzinfo.github.io/golemstockindices/reference/index_summary.md).

- indices:

  Data frame of indices from
  [`get_indices()`](https://sedzinfo.github.io/golemstockindices/reference/get_indices.md);
  the indices without a currency, the VIX, are left out.

- period:

  `"day"`, `"week"`, `"month"`, `"ytd"` (year to date) or `"year"`.

- mode:

  `"light"` (the default) or `"dark"`, to suit a light or dark page.

## Value

A plotly object.

## Examples

``` r
if (FALSE) { # interactive()
indices <- get_indices()
summary <- index_summary(get_history(indices$label, as.Date("2020-01-01")))
plot_performance(summary, indices, "ytd")
}
```
