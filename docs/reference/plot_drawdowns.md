# Drawdown chart of an index

Two panels over the whole history. The upper one is the close on a log
scale with the all-time high so far; the lower one is the drawdown, how
far each close is below that high (see
[`drawdown()`](https://sedzinfo.github.io/golemstockindices/reference/drawdown.md)),
with a dashed line at `min_depth` percent. The falls of the analysis are
shaded from their peak to their recovery, the current one in amber, and
their troughs carry their rank, as in
[`drawdown_table()`](https://sedzinfo.github.io/golemstockindices/reference/drawdown_table.md);
hover over a trough for its dates.

## Usage

``` r
plot_drawdowns(analysis, mode = "light")
```

## Arguments

- analysis:

  The result of
  [`drawdown_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/drawdown_analysis.md).

- mode:

  `"light"` (the default) or `"dark"`, to suit a light or dark page.

## Value

A plotly object.

## Examples

``` r
if (FALSE) { # interactive()
spx <- get_history("S&P 500", as.Date("1950-01-01"))
plot_drawdowns(drawdown_analysis(spx))
}
```
