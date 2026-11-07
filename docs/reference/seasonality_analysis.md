# Seasonality analysis of an index

Do some days of the week, weeks of the year, months or years of the US
presidential cycle bring better returns than others? The returns of the
complete periods (see
[`seasonal_returns()`](https://sedzinfo.github.io/golemstockindices/reference/seasonal_returns.md))
are summed up by group, and a Kruskal-Wallis test asks whether the
differences between the groups are larger than chance would give. The
test compares the ranks of the returns, so a few extreme months do not
decide it, but it takes the returns as independent, which market returns
are only roughly: calm and wild stretches come in runs.

## Usage

``` r
seasonality_analysis(history, period = c("day", "week", "month", "year"))
```

## Arguments

- history:

  Price history of one index from
  [`get_history()`](https://sedzinfo.github.io/golemstockindices/reference/get_history.md),
  with all of it.

- period:

  `"day"`, `"week"`, `"month"` or `"year"`.

## Value

`NULL` when the history has no complete period with one before it, or a
list with:

- index, period:

  What was analysed.

- returns:

  The returns of
  [`seasonal_returns()`](https://sedzinfo.github.io/golemstockindices/reference/seasonal_returns.md).

- groups:

  A row per group that has returns, in their natural order: `group`,
  `returns` (how many), `mean_pct`, `median_pct`, `up_pct` (the share of
  the returns above 0), `best_pct` and `worst_pct`.

- all:

  The same numbers for all the returns together, as a list.

- p_value:

  The p-value of the Kruskal-Wallis test, `NA` when fewer than two
  groups have returns, or no group has two.

## Examples

``` r
if (FALSE) { # interactive()
spx <- get_history("S&P 500", as.Date("1950-01-01"))
analysis <- seasonality_analysis(spx, "month")
analysis$groups
analysis$p_value
seasonality_text(analysis)
}
```
