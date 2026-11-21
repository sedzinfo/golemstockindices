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

[`library`](https://rdrr.io/r/base/library.html)`(`[`golemstockindices`](https://sedzinfo.github.io/golemstockindices/)`)`` ``indices`` ``<-`` `[`get_indices`](https://sedzinfo.github.io/golemstockindices/reference/get_indices.md)`(``)`` ``history`` ``<-`` `[`get_history`](https://sedzinfo.github.io/golemstockindices/reference/get_history.md)`(``indices``$``label``, `[`as.Date`](https://rdrr.io/r/base/as.Date.html)`(``"1900-01-01"``)``)`` `[`nrow`](https://rdrr.io/r/base/nrow.html)`(``indices``)`` ``#> [1] 55`

The first download of all the indices takes a few seconds, as they are
downloaded at the same time. After that they are kept on disk.

## Where every index stands

[`index_summary()`](https://sedzinfo.github.io/golemstockindices/reference/index_summary.md)
gives a row per index with its last close and its change in percent
since the close before, a week, 1, 3, 6 and 9 months, the start of the
year and a year before, and how far it is below its highest close:

`summary`` ``<-`` `[`index_summary`](https://sedzinfo.github.io/golemstockindices/reference/index_summary.md)`(``history``)`` ``columns`` ``<-`` `[`c`](https://rdrr.io/r/base/c.html)`(``"label"``, ``"date"``, ``"close"``, ``"day_pct"``, ``"ytd_pct"``, ``"year_pct"``,`` `` ``"from_high_pct"``)`` `[`print`](https://rdrr.io/r/base/print.html)`(`[`head`](https://rdrr.io/r/utils/head.html)`(``summary``[``, ``columns``]``)``, digits ``=`` ``3``)`` ``#> label date close day_pct ytd_pct year_pct from_high_pct`` ``#> 1 AEX 2026-11-20 1066 -2.36 12.07 14.035 -6.90`` ``#> 2 All Ordinaries 2026-11-20 8693 -1.63 -3.61 -1.598 -8.03`` ``#> 3 ASX 200 2026-11-20 8593 -1.58 -1.40 0.467 -7.32`` ``#> 4 Athens General 2026-11-20 2553 -1.87 20.37 24.135 -59.83`` ``#> 5 ATX 2026-11-20 6204 -2.74 16.48 28.720 -11.52`` ``#> 6 BEL 20 2026-11-20 5798 -1.49 14.16 16.620 -5.26`

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

[`overview_table`](https://sedzinfo.github.io/golemstockindices/reference/overview_table.md)`(``summary``, ``indices``, ``history``)`

## Performance chart

[`plot_performance()`](https://sedzinfo.github.io/golemstockindices/reference/plot_performance.md)
draws a bar per index with its change over a period, green for rises and
red for falls, the best at the top. The period is one of `"day"`,
`"week"`, `"month"`, `"month3"`, `"month6"`, `"month9"`, `"ytd"` (the
year to date) and `"year"`. The VIX is left out, as its swings of tens
of percent would squeeze the others. Hover over a bar for the numbers:

[`plot_performance`](https://sedzinfo.github.io/golemstockindices/reference/plot_performance.md)`(``summary``, ``indices``, ``"ytd"``)`

The other periods work the same way:

[`plot_performance`](https://sedzinfo.github.io/golemstockindices/reference/plot_performance.md)`(``summary``, ``indices``, ``"year"``)`` `[`plot_performance`](https://sedzinfo.github.io/golemstockindices/reference/plot_performance.md)`(``summary``, ``indices``, ``"month3"``)`

To compare the indices in one currency, convert the prices first, as in
[Get
started](https://sedzinfo.github.io/golemstockindices/articles/golemstockindices.md),
and tell
[`plot_performance()`](https://sedzinfo.github.io/golemstockindices/reference/plot_performance.md)
the currency, for the title. This chart is not drawn here, to keep the
page light:

`dollars`` ``<-`` `[`convert_prices`](https://sedzinfo.github.io/golemstockindices/reference/convert_prices.md)`(``history``, ``"USD"``)`` `[`plot_performance`](https://sedzinfo.github.io/golemstockindices/reference/plot_performance.md)`(`[`index_summary`](https://sedzinfo.github.io/golemstockindices/reference/index_summary.md)`(``dollars``)``, ``indices``, ``"ytd"``, currency ``=`` ``"USD"``)`

## Which exchanges are open

[`market_status()`](https://sedzinfo.github.io/golemstockindices/reference/market_status.md)
gives a row per exchange, from west to east, with its local time and
whether it is open, at lunch or closed, and when that changes. Without
an argument it judges the present. Here it judges a Monday at 15:00 UTC:

`status`` ``<-`` `[`market_status`](https://sedzinfo.github.io/golemstockindices/reference/market_status.md)`(`[`as.POSIXct`](https://rdrr.io/r/base/as.POSIXlt.html)`(``"2026-11-09 15:00"``, tz ``=`` ``"UTC"``)``)`` ``cities`` ``<-`` `[`c`](https://rdrr.io/r/base/c.html)`(``"New York"``, ``"London"``, ``"Frankfurt"``, ``"Tokyo"``)`` ``columns`` ``<-`` `[`c`](https://rdrr.io/r/base/c.html)`(``"exchange"``, ``"local_time"``, ``"state"``, ``"text"``, ``"hours"``)`` ``status``[``status``$``exchange`` `[`%in%`](https://rdrr.io/r/base/match.html)` ``cities``, ``columns``]`` ``#> exchange local_time state text hours`` ``#> 3 New York 10:00 open closes 16:00 09:30–16:00`` ``#> 7 London 15:00 open closes 16:30 08:00–16:30`` ``#> 8 Frankfurt 16:00 open closes 17:30 09:00–17:30`` ``#> 33 Tokyo 00:00 closed opens 09:00 09:00–11:30, 12:30–15:30`

It knows the regular sessions on weekdays, but not the holidays, so on a
holiday an exchange shows as open. Its `indices` column lists the
indices of each exchange.

## Dark mode and saving

[`plot_performance()`](https://sedzinfo.github.io/golemstockindices/reference/plot_performance.md)
takes `mode = "dark"` for a dark page. The chart is a plotly object and
the table a DT table, so
[`htmlwidgets::saveWidget()`](https://rdrr.io/pkg/htmlwidgets/man/saveWidget.html)
saves either as a web page:

`chart`` ``<-`` `[`plot_performance`](https://sedzinfo.github.io/golemstockindices/reference/plot_performance.md)`(``summary``, ``indices``, ``"ytd"``, mode ``=`` ``"dark"``)`` ``htmlwidgets``::`[`saveWidget`](https://rdrr.io/pkg/htmlwidgets/man/saveWidget.html)`(``chart``, ``"performance.html"``)`` ``htmlwidgets``::`[`saveWidget`](https://rdrr.io/pkg/htmlwidgets/man/saveWidget.html)`(`[`overview_table`](https://sedzinfo.github.io/golemstockindices/reference/overview_table.md)`(``summary``, ``indices``, ``history``)``, ``"overview.html"``)`
