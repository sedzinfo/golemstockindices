# Line chart of normalized close prices

One line per index, with buttons that switch the y axis between a linear
and a log scale.

## Usage

``` r
plot_compare(prices, mode = "light")
```

## Arguments

- prices:

  Prices from
  [`normalize_prices()`](https://sedzinfo.github.io/golemstockindices/reference/normalize_prices.md).

- mode:

  `"light"` (the default) or `"dark"`, to suit a light or dark page.

## Value

A plotly object.

## Examples

``` r
if (FALSE) { # interactive()
history <- get_history(c("S&P 500", "Euro Stoxx 50", "Nikkei 225"))
plot_compare(normalize_prices(history))
}
```
