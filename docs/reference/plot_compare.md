# Line chart of normalized close prices

One line per index, with buttons that switch the y axis between a linear
and a log scale. The performance indices, whose closes include the
dividends that the others leave out, are marked (TR), for total return.

## Usage

``` r
plot_compare(
  prices,
  mode = "light",
  indices = get_indices(),
  currency = "local"
)
```

## Arguments

- prices:

  Prices from
  [`normalize_prices()`](https://sedzinfo.github.io/golemstockindices/reference/normalize_prices.md).

- mode:

  `"light"` (the default) or `"dark"`, to suit a light or dark page.

- indices:

  Data frame of indices from
  [`get_indices()`](https://sedzinfo.github.io/golemstockindices/reference/get_indices.md),
  for the indices to mark (TR).

- currency:

  `"local"` for prices in the money of each index, or the currency they
  were converted to with
  [`convert_prices()`](https://sedzinfo.github.io/golemstockindices/reference/convert_prices.md),
  `"USD"` or `"EUR"`, for the title.

## Value

A plotly object.

## Examples

``` r
if (FALSE) { # interactive()
history <- get_history(c("S&P 500", "Euro Stoxx 50", "Nikkei 225"))
plot_compare(normalize_prices(history))
# in US dollars
plot_compare(normalize_prices(convert_prices(history, "USD")), currency = "USD")
}
```
