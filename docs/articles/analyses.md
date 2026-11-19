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
#> - 22.5% a year, against 12.7% in the year before and a median of
#>   11.5% for all 21-day periods since 1950: the 91st percentile.
#> - Its variance is 3.2 times that of the year before, significant in
#>   both tests: the whole month was rougher.
#> - The largest day, 5 Nov (−4.36%), was 5.6 standard deviations of the
#>   year before: rare, as days that large come about once every 2.5
#>   years.
#> - The return of the 21 trading days, −5.0%, is in the 8th percentile
#>   of all 21-day periods: a weak month.
```

[`volatility_text()`](https://sedzinfo.github.io/golemstockindices/reference/volatility_text.md)
has two more parts, `$recent` for the last 2 days and `$forecast` for
the next 5. Each has a `headline` and `points`, a character vector of
sentences. The numbers behind the sentences are in the analysis, such as
the forecast ranges of the next closes:

``` r

analysis$forecast$days
#>         date    sigma      low   low_50   median  high_50     high
#> 1 2026-11-19 1.221646 7154.384 7279.306 7331.054 7383.170 7512.087
#> 2 2026-11-20 1.205495 7093.158 7263.488 7338.515 7414.480 7591.041
#> 3 2026-11-23 1.190118 7045.810 7253.444 7346.000 7437.754 7653.656
#> 4 2026-11-24 1.175483 7011.755 7248.979 7353.112 7459.624 7706.399
#> 5 2026-11-25 1.161562 6981.805 7243.363 7361.148 7478.724 7757.373
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
#> [1] "Volatility of the last 5 trading days: normal"
volatility_text(week)$recent$headline
#> [1] "Last day, 18 Nov: −0.2%, a normal fall"
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
#> [1] "Now: −6.3% from the all-time high, in its 54th deepest fall"
writeLines(strwrap(paste("-", now$points), width = 70, exdent = 2))
#> - The all-time high: 7,818.93 on 6 Oct 2026, 43 days ago. The lowest
#>   close since: 7,323.63 on 18 Nov 2026, −6.3%.
#> - Back to the high takes a rise of +6.8% from the last close of
#>   7,323.63.
#> - Earlier falls as deep as −6.3% or deeper: 53. They got back to
#>   their high 34 to 2,744 days (median 118) after the peak, and 16 to
#>   2,114 days (median 63) after the trough. This fall has lasted 43
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
