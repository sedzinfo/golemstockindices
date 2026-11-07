# Heatmap of monthly returns by year

Months are colored from red to green by their return. The color limit is
the 95th percentile of the absolute returns, so a few extreme months do
not wash out the rest.

## Usage

``` r
plot_returns_calendar(calendar, label = NULL, mode = "light")
```

## Arguments

- calendar:

  Matrix from
  [`monthly_returns()`](https://sedzinfo.github.io/golemstockindices/reference/monthly_returns.md).

- label:

  Label of the index for the title, or `NULL` for none.

- mode:

  `"light"` (the default) or `"dark"`, to suit a light or dark page.

## Value

A plotly object.

## Examples

``` r
if (FALSE) { # interactive()
spx <- get_history("S&P 500", as.Date("1950-01-01"))
plot_returns_calendar(monthly_returns(spx), "S&P 500")
}
```
