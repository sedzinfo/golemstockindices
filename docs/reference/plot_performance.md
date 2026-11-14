# Performance of the indices over a period

One horizontal bar per index, its change over the period in percent,
green for rises and red for falls, the best at the top, from
[`performance_data()`](https://sedzinfo.github.io/golemstockindices/reference/performance_data.md).
The VIX is left out: it measures the fear in the market rather than the
value of shares, and its swings of tens of percent would squeeze the
others. The performance indices, whose changes include the dividends
that the others leave out, are marked (TR), for total return.

## Usage

``` r
plot_performance(
  summary,
  indices = get_indices(),
  period = performance_periods,
  mode = "light",
  currency = "local"
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

  `"day"`, `"week"`, `"month"`, `"month3"`, `"month6"`, `"month9"` (3, 6
  and 9 months), `"ytd"` (year to date) or `"year"`.

- mode:

  `"light"` (the default) or `"dark"`, to suit a light or dark page.

- currency:

  `"local"` for a summary of the prices in the money of each index, or
  the currency they were converted to with
  [`convert_prices()`](https://sedzinfo.github.io/golemstockindices/reference/convert_prices.md),
  `"USD"` or `"EUR"`, for the title.

## Value

A plotly object.

## Examples

``` r
if (FALSE) { # interactive()
indices <- get_indices()
history <- get_history(indices$label, as.Date("2020-01-01"))
plot_performance(index_summary(history), indices, "ytd")
# in US dollars
plot_performance(index_summary(convert_prices(history, "USD")), indices, "ytd", currency = "USD")
}
```
