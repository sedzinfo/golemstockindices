# The market overview

The Overview and Performance tabs of the [golemstockindices
app](https://sedzinfo-golemstockindices.share.connect.posit.cloud/) show
where every index stands. In R,
[`index_summary()`](https://sedzinfo.github.io/golemstockindices/reference/index_summary.md)
calculates the numbers,
[`overview_table()`](https://sedzinfo.github.io/golemstockindices/reference/overview_table.md)
shows them as a table,
[`plot_performance()`](https://sedzinfo.github.io/golemstockindices/reference/plot_performance.md)
draws them as a chart, and
[`market_status()`](https://sedzinfo.github.io/golemstockindices/reference/market_status.md)
says which exchanges are open.

## Download every index

[`get_indices()`](https://sedzinfo.github.io/golemstockindices/reference/get_indices.md)
lists the indices, and
[`get_history()`](https://sedzinfo.github.io/golemstockindices/reference/get_history.md)
downloads the prices of all of them. Start in 1900 to get all the
history there is, because the highest close is that of the history you
pass:

``` r

library(golemstockindices)
indices <- get_indices()
history <- get_history(indices$label, as.Date("1900-01-01"))
nrow(indices)
#> [1] 55
```

The first download of all the indices takes a few seconds, as they are
downloaded at the same time. After that they are kept on disk.

## Where every index stands

[`index_summary()`](https://sedzinfo.github.io/golemstockindices/reference/index_summary.md)
gives a row per index with its last close and its change in percent
since the close before, a week, 1, 3, 6 and 9 months, the start of the
year and a year before, and how far it is below its highest close:

``` r

summary <- index_summary(history)
columns <- c("label", "date", "close", "day_pct", "ytd_pct", "year_pct",
             "from_high_pct")
print(head(summary[, columns]), digits = 3)
#>            label       date close day_pct ytd_pct year_pct from_high_pct
#> 1            AEX 2026-11-18  1099  -1.006  15.499    18.03         -4.05
#> 2 All Ordinaries 2026-11-19  8837  -1.073  -2.020     1.32         -6.51
#> 3        ASX 200 2026-11-19  8730  -1.036   0.185     3.34         -5.84
#> 4 Athens General 2026-11-18  2585  -2.016  21.870    28.42        -59.33
#> 5            ATX 2026-11-18  6395  -1.950  20.059    35.58         -8.80
#> 6         BEL 20 2026-11-18  5953  -0.576  17.212    20.40         -2.73
```

A change is empty when the history does not go back far enough.
`from_high_pct` is 0 for an index that closed at its high.

## Table

[`overview_table()`](https://sedzinfo.github.io/golemstockindices/reference/overview_table.md)
shows the summary as a sortable table, in the order of
[`get_indices()`](https://sedzinfo.github.io/golemstockindices/reference/get_indices.md).
It adds the region and the currency of each index from `indices`, and,
when you pass the history, a small line of its last year. The changes
are shaded red for falls and green for rises, each column on its own
scale, and the distance from the high is red, more strongly the further
it is:

``` r

overview_table(summary, indices, history)
```

## Performance chart

[`plot_performance()`](https://sedzinfo.github.io/golemstockindices/reference/plot_performance.md)
draws a bar per index with its change over a period, green for rises and
red for falls, the best at the top. The period is one of `"day"`,
`"week"`, `"month"`, `"month3"`, `"month6"`, `"month9"`, `"ytd"` (the
year to date) and `"year"`. The VIX is left out, as its swings of tens
of percent would squeeze the others. Hover over a bar for the numbers:

``` r

plot_performance(summary, indices, "ytd")
```

The other periods work the same way:

``` r

plot_performance(summary, indices, "year")
plot_performance(summary, indices, "month3")
```

To compare the indices in one currency, convert the prices first, as in
[Get
started](https://sedzinfo.github.io/golemstockindices/articles/golemstockindices.md),
and tell
[`plot_performance()`](https://sedzinfo.github.io/golemstockindices/reference/plot_performance.md)
the currency, for the title. This chart is not drawn here, to keep the
page light:

``` r

dollars <- convert_prices(history, "USD")
plot_performance(index_summary(dollars), indices, "ytd", currency = "USD")
```

## Which exchanges are open

[`market_status()`](https://sedzinfo.github.io/golemstockindices/reference/market_status.md)
gives a row per exchange, from west to east, with its local time and
whether it is open, at lunch or closed, and when that changes. Without
an argument it judges the present. Here it judges a Monday at 15:00 UTC:

``` r

status <- market_status(as.POSIXct("2026-11-09 15:00", tz = "UTC"))
cities <- c("New York", "London", "Frankfurt", "Tokyo")
columns <- c("exchange", "local_time", "state", "text", "hours")
status[status$exchange %in% cities, columns]
#>     exchange local_time  state         text                    hours
#> 3   New York      10:00   open closes 16:00              09:30–16:00
#> 7     London      15:00   open closes 16:30              08:00–16:30
#> 8  Frankfurt      16:00   open closes 17:30              09:00–17:30
#> 33     Tokyo      00:00 closed  opens 09:00 09:00–11:30, 12:30–15:30
```

It knows the regular sessions on weekdays, but not the holidays, so on a
holiday an exchange shows as open. Its `indices` column lists the
indices of each exchange.

## Dark mode and saving

[`plot_performance()`](https://sedzinfo.github.io/golemstockindices/reference/plot_performance.md)
takes `mode = "dark"` for a dark page. The chart is a plotly object and
the table a DT table, so
[`htmlwidgets::saveWidget()`](https://rdrr.io/pkg/htmlwidgets/man/saveWidget.html)
saves either as a web page:

``` r

chart <- plot_performance(summary, indices, "ytd", mode = "dark")
htmlwidgets::saveWidget(chart, "performance.html")
htmlwidgets::saveWidget(overview_table(summary, indices, history), "overview.html")
```
