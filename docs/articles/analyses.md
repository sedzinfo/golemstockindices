# Volatility, drawdowns and seasonality

The Volatility, Drawdowns and Seasonality tabs of the [golemstockindices
app](https://sedzinfo-golemstockindices.share.connect.posit.cloud/) work
the same way in R. An `_analysis()` function does the calculations, and
its result goes to three functions:

- `_text()` sums it up in sentences, as the app does above its charts;
- `plot_` draws its chart;
- `_table()`, for drawdowns and seasonality, shows its numbers as a
  sortable table.

All three analyses compare the present with an index’s past, so pass
them the whole history. [Get
started](https://sedzinfo.github.io/golemstockindices/articles/golemstockindices.md)
shows how to find indices and download their prices. This page uses the
S&P 500 since 1950.

``` r

library(golemstockindices)
spx <- get_history("S&P 500", as.Date("1950-01-01"))
```

## Volatility

[`volatility_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/volatility_analysis.md)
asks whether the volatility of the last 21 trading days, and the move of
the last 2 days, are normal for the index. It compares them with the
index’s history and with a GARCH(1,1) model, and forecasts the next 5
trading days. All its windows count trading days, and a year is 252 of
them. It needs more than a year of history.

``` r

analysis <- volatility_analysis(spx)
text <- volatility_text(analysis)
text$month$headline
#> [1] "Volatility of the last 21 trading days: high"
writeLines(strwrap(paste("-", text$month$points), width = 70, exdent = 2))
#> - 25.9% a year, against 12.7% in the year before and a median of
#>   11.5% for all 21-day periods since 1950: the 94th percentile.
#> - Its variance is 4.1 times that of the year before, significant in
#>   both tests: the whole month was rougher.
#> - The largest day, 5 Nov (−4.36%), was 5.6 standard deviations of the
#>   year before: rare, as days that large come about once every 2.5
#>   years.
#> - The return of the 21 trading days, −9.8%, is in the 2nd percentile
#>   of all 21-day periods: one of the most extreme months.
```

[`volatility_text()`](https://sedzinfo.github.io/golemstockindices/reference/volatility_text.md)
has two more parts, `$recent` for the last 2 days and `$forecast` for
the next 5. Each has a `headline` and `points`, a character vector of
sentences. The numbers behind the sentences are in the analysis, such as
the forecast ranges of the next closes:

``` r

analysis$forecast$days
#>         date    sigma      low   low_50   median  high_50     high
#> 1 2026-11-23 1.719252 6683.703 6847.921 6917.272 6987.324 7159.003
#> 2 2026-11-24 1.679700 6600.139 6825.667 6923.923 7023.507 7258.306
#> 3 2026-11-25 1.641785 6539.927 6809.982 6930.246 7052.403 7336.845
#> 4 2026-11-26 1.605456 6495.917 6798.434 6938.980 7078.495 7402.325
#> 5 2026-11-27 1.570663 6451.576 6792.765 6944.346 7102.361 7463.779
```

[`plot_volatility()`](https://sedzinfo.github.io/golemstockindices/reference/plot_volatility.md)
draws three panels:

- the volatility of every 21-day period of the history, with its median
  and 95th percentile;
- each of the last 63 days, as its move in the standard deviations the
  GARCH model expected;
- the last 21 closes, followed by the forecast.

``` r

plot_volatility(analysis)
```

[`plot_forecast()`](https://sedzinfo.github.io/golemstockindices/reference/plot_forecast.md)
draws the lower panel on its own: the last 30 closes, then the median
close of the next 5 trading days, with the ranges of the middle half and
of 95% around it. The ranges start from the last close. Hover over the
median line for the ranges of a day:

``` r

plot_forecast(analysis)
```

The GARCH model needs at least 500 days before the last days. Without
one,
[`plot_volatility()`](https://sedzinfo.github.io/golemstockindices/reference/plot_volatility.md)
draws only its upper panel, and
[`plot_forecast()`](https://sedzinfo.github.io/golemstockindices/reference/plot_forecast.md)
stops with an error that says there is no forecast.

The arguments of
[`volatility_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/volatility_analysis.md)
change the periods. For example, `month_days = 5` and `recent_days = 1`
ask about the last week and the last day:

``` r

week <- volatility_analysis(spx, month_days = 5, recent_days = 1)
volatility_text(week)$month$headline
#> [1] "Volatility of the last 5 trading days: high"
volatility_text(week)$recent$headline
#> [1] "Last day, 20 Nov: −3.7%, an unusual fall"
```

[`plot_volatility()`](https://sedzinfo.github.io/golemstockindices/reference/plot_volatility.md)
takes `days` for the days of the middle panel and `context_days` for the
closes before the forecast, which
[`plot_forecast()`](https://sedzinfo.github.io/golemstockindices/reference/plot_forecast.md)
takes too. The length and the probability of the forecast are set in
[`volatility_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/volatility_analysis.md),
with `forecast_days` and `level`. For example, the next 10 trading days
with 90% ranges, after the last 60 closes:

``` r

ten_days <- volatility_analysis(spx, forecast_days = 10, level = 0.9)
plot_forecast(ten_days, context_days = 60)
```

## Drawdowns

[`drawdown_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/drawdown_analysis.md)
measures how far the index is below its all-time high, and lists its
earlier falls of 20% or more with how long they took to recover:

``` r

falls <- drawdown_analysis(spx)
now <- drawdown_text(falls)$now
now$headline
#> [1] "Now: −11.6% from the all-time high, in its 22nd deepest fall"
writeLines(strwrap(paste("-", now$points), width = 70, exdent = 2))
#> - The all-time high: 7,818.93 on 6 Oct 2026, 45 days ago. The lowest
#>   close since: 6,910.39 on 20 Nov 2026, −11.6%.
#> - Back to the high takes a rise of +13.1% from the last close of
#>   6,910.39.
#> - Earlier falls as deep as −11.6% or deeper: 21. They got back to
#>   their high 102 to 2,744 days (median 469) after the peak, and 32 to
#>   2,114 days (median 178) after the trough. This fall has lasted 45
#>   days so far.
```

The falls are in `falls$episodes`, the deepest first. A fall that has
not got back to its high yet is marked `ongoing`:

``` r

columns <- c("peak_date", "trough_date", "depth_pct",
             "recovery_date", "days_total", "ongoing")
head(falls$episodes[, columns])
#>    peak_date trough_date depth_pct recovery_date days_total ongoing
#> 1 2007-10-09  2009-03-09 -56.77539    2013-03-28       1997   FALSE
#> 2 2000-03-24  2002-10-09 -49.14695    2007-05-30       2623   FALSE
#> 3 1973-01-11  1974-10-03 -48.20359    1980-07-17       2744   FALSE
#> 4 1968-11-29  1970-05-26 -36.06164    1972-03-06       1193   FALSE
#> 5 2020-02-19  2020-03-23 -33.92496    2020-08-18        181   FALSE
#> 6 1987-08-25  1987-12-04 -33.50952    1989-07-26        701   FALSE
```

[`plot_drawdowns()`](https://sedzinfo.github.io/golemstockindices/reference/plot_drawdowns.md)
draws the close on a log scale with the all-time high so far, and under
it the drawdown. The falls are shaded from their peak to their recovery,
the current one in amber, and their troughs are numbered by depth:

``` r

plot_drawdowns(falls)
```

[`drawdown_table()`](https://sedzinfo.github.io/golemstockindices/reference/drawdown_table.md)
shows the same falls as a sortable table:

``` r

drawdown_table(falls)
```

To list smaller falls as well, lower `min_depth`, for example
`drawdown_analysis(spx, min_depth = 10)`.

## Seasonality

[`seasonality_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/seasonality_analysis.md)
asks whether some periods bring better returns than others. The period
is one of:

- `"day"`, the days of the week;
- `"week"`, the weeks of the year;
- `"month"`, the months;
- `"year"`, the years of the US presidential cycle.

or a calendar effect, its returns against the rest:

- `"turn"`, the turn of the month: the last trading day of a month and
  the first 3 of the next;
- `"holiday"`, the trading days before a holiday;
- `"santa"`, the Santa rally: the last 5 trading days of December and
  the first 2 of January;
- `"half"`, Sell in May: May to October against November to April.

A Kruskal-Wallis test then asks whether the differences could be chance.

``` r

months <- seasonality_analysis(spx, "month")
text <- seasonality_text(months)
text$groups$headline
#> [1] "Best month: November, mean +1.9%; worst: September, −0.6%"
text$chance$headline
#> [1] "The months differ by more than chance usually gives (p = 0.0041)"
```

The `$points` of each part give the details, such as the p-value of the
test and how many months it compared.

[`plot_seasonality()`](https://sedzinfo.github.io/golemstockindices/reference/plot_seasonality.md)
shows the mean return of each group, with the median as a diamond, and
under it the share of returns above 0. Hover over a bar for all the
numbers of its group:

``` r

plot_seasonality(months)
```

[`seasonality_table()`](https://sedzinfo.github.io/golemstockindices/reference/seasonality_table.md)
shows the numbers as a table:

``` r

seasonality_table(months)
```

The other periods work the same way, for example the days of the week:

``` r

plot_seasonality(seasonality_analysis(spx, "day"))
```

and the calendar effects, for example the turn of the month, whose two
groups are the days of the turn and the rest of the month:

``` r

turn <- seasonality_analysis(spx, "turn")
seasonality_text(turn)$groups$headline
#> [1] "Turn of the month: mean +0.11% a day; rest of the month: +0.02%"
seasonality_text(turn)$chance$headline
#> [1] "The turn of the month and the rest of the month differ by more than chance usually gives (p < 0.001)"
```

## Dark mode and saving

Like the price charts, every `plot_` function takes `mode = "dark"` for
a dark page. The charts are plotly objects, and the tables are DT
tables, so
[`htmlwidgets::saveWidget()`](https://rdrr.io/pkg/htmlwidgets/man/saveWidget.html)
saves any of them as a web page:

``` r

htmlwidgets::saveWidget(plot_drawdowns(falls), "drawdowns.html")
htmlwidgets::saveWidget(drawdown_table(falls), "drawdowns_table.html")
```
