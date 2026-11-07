# Seasonality chart of an index

Two panels with a bar per group of
[`seasonality_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/seasonality_analysis.md).
The upper one shows the mean return, green above 0 and red below, with
the median as a diamond; the lower one shows the share of the returns
above 0, with a dashed line at 50%. Hover over a bar for all the numbers
of its group.

## Usage

``` r
plot_seasonality(analysis, mode = "light")
```

## Arguments

- analysis:

  The result of
  [`seasonality_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/seasonality_analysis.md).

- mode:

  `"light"` (the default) or `"dark"`, to suit a light or dark page.

## Value

A plotly object.

## Examples

``` r
if (FALSE) { # interactive()
spx <- get_history("S&P 500", as.Date("1950-01-01"))
plot_seasonality(seasonality_analysis(spx, "month"))
plot_seasonality(seasonality_analysis(spx, "day"), mode = "dark")
}
```
