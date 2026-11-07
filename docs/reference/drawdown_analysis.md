# Drawdown analysis of an index

How far is the index below its all-time high, and how does that compare
with its earlier falls? See
[`drawdown_episodes()`](https://sedzinfo.github.io/golemstockindices/reference/drawdown_episodes.md)
for how the falls are found.

**Now**: the last close against the all-time high, the lowest close
since that high, the rise the price needs to get back to it, and the
earlier falls that went at least as deep as the current one has so far:
how many days they took to get back to their high.

**The history**: the falls of at least `min_depth` percent, the deepest
first, the share of days that closed that far below the high, and the
days that closed at a new all-time high.

## Usage

``` r
drawdown_analysis(history, min_depth = 20)
```

## Arguments

- history:

  Price history of one index from
  [`get_history()`](https://sedzinfo.github.io/golemstockindices/reference/get_history.md),
  with all of it: the highs are those of the history given.

- min_depth:

  Smallest fall of the history to list, in percent below the high.

## Value

`NULL` when there are fewer than 2 prices, or a list with:

- index, first_date, last_date, min_depth:

  What was analysed.

- now:

  `date` and `close` of the last day, `drawdown_pct`, `high_date` and
  `high_price` of the all-time high, `days_since_high`, and
  `rise_needed_pct` to get back to it. While the price is below the high
  also `low_date` and `low_price`, the lowest close since the high,
  `deepest_pct` how far that is below it, `rank` of the current fall
  among all the falls of the history by that depth, 1 for the deepest,
  and `earlier`, the earlier falls at least as deep, as rows of
  [`drawdown_episodes()`](https://sedzinfo.github.io/golemstockindices/reference/drawdown_episodes.md).
  At the high, `previous` holds the last fall of at least `min_depth`
  percent, or no rows.

- episodes:

  The falls of at least `min_depth` percent from
  [`drawdown_episodes()`](https://sedzinfo.github.io/golemstockindices/reference/drawdown_episodes.md),
  with their `rank` in front, 1 for the deepest.

- series:

  A row per day: `date`, `close`, `high` (the all-time high so far) and
  `drawdown_pct` (see
  [`drawdown()`](https://sedzinfo.github.io/golemstockindices/reference/drawdown.md)).

- share_under:

  Percent of the days that closed at least `min_depth` percent below the
  high.

- new_highs:

  Days that closed at a new all-time high, the first day of the history
  left out.

## Examples

``` r
if (FALSE) { # interactive()
spx <- get_history("S&P 500", as.Date("1950-01-01"))
analysis <- drawdown_analysis(spx)
analysis$now$drawdown_pct
analysis$episodes
drawdown_text(analysis)
}
```
