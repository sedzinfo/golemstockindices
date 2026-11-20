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

[`library`](https://rdrr.io/r/base/library.html)`(`[`golemstockindices`](https://sedzinfo.github.io/golemstockindices/)`)`` ``spx`` ``<-`` `[`get_history`](https://sedzinfo.github.io/golemstockindices/reference/get_history.md)`(``"S&P 500"``, `[`as.Date`](https://rdrr.io/r/base/as.Date.html)`(``"1950-01-01"``)``)`

## Volatility

[`volatility_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/volatility_analysis.md)
asks whether the volatility of the last 21 trading days, and the move of
the last 2 days, are normal for the index. It compares them with the
index’s history and with a GARCH(1,1) model, and forecasts the next 5
trading days. All its windows count trading days, and a year is 252 of
them. It needs more than a year of history.

`analysis`` ``<-`` `[`volatility_analysis`](https://sedzinfo.github.io/golemstockindices/reference/volatility_analysis.md)`(``spx``)`` ``text`` ``<-`` `[`volatility_text`](https://sedzinfo.github.io/golemstockindices/reference/volatility_text.md)`(``analysis``)`` ``text``$``month``$``headline`` ``#> [1] "Volatility of the last 21 trading days: high"`` `[`writeLines`](https://rdrr.io/r/base/writeLines.html)`(`[`strwrap`](https://rdrr.io/r/base/strwrap.html)`(`[`paste`](https://rdrr.io/r/base/paste.html)`(``"-"``, ``text``$``month``$``points``)``, width ``=`` ``70``, exdent ``=`` ``2``)``)`` ``#> - 23.2% a year, against 12.7% in the year before and a median of`` ``#> 11.5% for all 21-day periods since 1950: the 92nd percentile.`` ``#> - Its variance is 3.3 times that of the year before, significant in`` ``#> both tests: the whole month was rougher.`` ``#> - The largest day, 5 Nov (−4.36%), was 5.6 standard deviations of the`` ``#> year before: rare, as days that large come about once every 2.5`` ``#> years.`` ``#> - The return of the 21 trading days, −7.5%, is in the 3rd percentile`` ``#> of all 21-day periods: one of the most extreme months.`

[`volatility_text()`](https://sedzinfo.github.io/golemstockindices/reference/volatility_text.md)
has two more parts, `$recent` for the last 2 days and `$forecast` for
the next 5. Each has a `headline` and `points`, a character vector of
sentences. The numbers behind the sentences are in the analysis, such as
the forecast ranges of the next closes:

`analysis``$``forecast``$``days`` ``#> date sigma low low_50 median high_50 high`` ``#> 1 2026-11-20 1.316313 6996.819 7128.699 7183.117 7237.950 7374.375`` ``#> 2 2026-11-23 1.296043 6928.983 7111.554 7190.953 7270.284 7454.132`` ``#> 3 2026-11-24 1.276682 6882.016 7100.710 7197.052 7295.364 7522.008`` ``#> 4 2026-11-25 1.258200 6846.712 7093.546 7203.725 7318.014 7579.691`` ``#> 5 2026-11-26 1.240564 6812.935 7086.666 7211.353 7338.592 7626.184`

[`plot_volatility()`](https://sedzinfo.github.io/golemstockindices/reference/plot_volatility.md)
draws three panels:

- the volatility of every 21-day period of the history, with its median
  and 95th percentile;
- each of the last 63 days, as its move in the standard deviations the
  GARCH model expected;
- the last 21 closes, followed by the forecast.

[`plot_volatility`](https://sedzinfo.github.io/golemstockindices/reference/plot_volatility.md)`(``analysis``)`

[`plot_forecast()`](https://sedzinfo.github.io/golemstockindices/reference/plot_forecast.md)
draws the lower panel on its own: the last 30 closes, then the median
close of the next 5 trading days, with the ranges of the middle half and
of 95% around it. The ranges start from the last close. Hover over the
median line for the ranges of a day:

[`plot_forecast`](https://sedzinfo.github.io/golemstockindices/reference/plot_forecast.md)`(``analysis``)`

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

`week`` ``<-`` `[`volatility_analysis`](https://sedzinfo.github.io/golemstockindices/reference/volatility_analysis.md)`(``spx``, month_days ``=`` ``5``, recent_days ``=`` ``1``)`` `[`volatility_text`](https://sedzinfo.github.io/golemstockindices/reference/volatility_text.md)`(``week``)``$``month``$``headline`` ``#> [1] "Volatility of the last 5 trading days: elevated"`` `[`volatility_text`](https://sedzinfo.github.io/golemstockindices/reference/volatility_text.md)`(``week``)``$``recent``$``headline`` ``#> [1] "Last day, 19 Nov: −2.0%, an unusual fall"`

[`plot_volatility()`](https://sedzinfo.github.io/golemstockindices/reference/plot_volatility.md)
takes `days` for the days of the middle panel and `context_days` for the
closes before the forecast, which
[`plot_forecast()`](https://sedzinfo.github.io/golemstockindices/reference/plot_forecast.md)
takes too. The length and the probability of the forecast are set in
[`volatility_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/volatility_analysis.md),
with `forecast_days` and `level`. For example, the next 10 trading days
with 90% ranges, after the last 60 closes:

`ten_days`` ``<-`` `[`volatility_analysis`](https://sedzinfo.github.io/golemstockindices/reference/volatility_analysis.md)`(``spx``, forecast_days ``=`` ``10``, level ``=`` ``0.9``)`` `[`plot_forecast`](https://sedzinfo.github.io/golemstockindices/reference/plot_forecast.md)`(``ten_days``, context_days ``=`` ``60``)`

## Drawdowns

[`drawdown_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/drawdown_analysis.md)
measures how far the index is below its all-time high, and lists its
earlier falls of 20% or more with how long they took to recover:

`falls`` ``<-`` `[`drawdown_analysis`](https://sedzinfo.github.io/golemstockindices/reference/drawdown_analysis.md)`(``spx``)`` ``now`` ``<-`` `[`drawdown_text`](https://sedzinfo.github.io/golemstockindices/reference/drawdown_text.md)`(``falls``)``$``now`` ``now``$``headline`` ``#> [1] "Now: −8.2% from the all-time high, in its 37th deepest fall"`` `[`writeLines`](https://rdrr.io/r/base/writeLines.html)`(`[`strwrap`](https://rdrr.io/r/base/strwrap.html)`(`[`paste`](https://rdrr.io/r/base/paste.html)`(``"-"``, ``now``$``points``)``, width ``=`` ``70``, exdent ``=`` ``2``)``)`` ``#> - The all-time high: 7,818.93 on 6 Oct 2026, 44 days ago. The lowest`` ``#> close since: 7,175.83 on 19 Nov 2026, −8.2%.`` ``#> - Back to the high takes a rise of +9.0% from the last close of`` ``#> 7,175.83.`` ``#> - Earlier falls as deep as −8.2% or deeper: 36. They got back to`` ``#> their high 52 to 2,744 days (median 214) after the peak, and 16 to`` ``#> 2,114 days (median 106) after the trough. This fall has lasted 44`` ``#> days so far.`

The falls are in `falls$episodes`, the deepest first. A fall that has
not got back to its high yet is marked `ongoing`:

`columns`` ``<-`` `[`c`](https://rdrr.io/r/base/c.html)`(``"peak_date"``, ``"trough_date"``, ``"depth_pct"``,`` `` ``"recovery_date"``, ``"days_total"``, ``"ongoing"``)`` `[`head`](https://rdrr.io/r/utils/head.html)`(``falls``$``episodes``[``, ``columns``]``)`` ``#> peak_date trough_date depth_pct recovery_date days_total ongoing`` ``#> 1 2007-10-09 2009-03-09 -56.77539 2013-03-28 1997 FALSE`` ``#> 2 2000-03-24 2002-10-09 -49.14695 2007-05-30 2623 FALSE`` ``#> 3 1973-01-11 1974-10-03 -48.20359 1980-07-17 2744 FALSE`` ``#> 4 1968-11-29 1970-05-26 -36.06164 1972-03-06 1193 FALSE`` ``#> 5 2020-02-19 2020-03-23 -33.92496 2020-08-18 181 FALSE`` ``#> 6 1987-08-25 1987-12-04 -33.50952 1989-07-26 701 FALSE`

[`plot_drawdowns()`](https://sedzinfo.github.io/golemstockindices/reference/plot_drawdowns.md)
draws the close on a log scale with the all-time high so far, and under
it the drawdown. The falls are shaded from their peak to their recovery,
the current one in amber, and their troughs are numbered by depth:

[`plot_drawdowns`](https://sedzinfo.github.io/golemstockindices/reference/plot_drawdowns.md)`(``falls``)`

[`drawdown_table()`](https://sedzinfo.github.io/golemstockindices/reference/drawdown_table.md)
shows the same falls as a sortable table:

[`drawdown_table`](https://sedzinfo.github.io/golemstockindices/reference/drawdown_table.md)`(``falls``)`

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

`months`` ``<-`` `[`seasonality_analysis`](https://sedzinfo.github.io/golemstockindices/reference/seasonality_analysis.md)`(``spx``, ``"month"``)`` ``text`` ``<-`` `[`seasonality_text`](https://sedzinfo.github.io/golemstockindices/reference/seasonality_text.md)`(``months``)`` ``text``$``groups``$``headline`` ``#> [1] "Best month: November, mean +1.9%; worst: September, −0.6%"`` ``text``$``chance``$``headline`` ``#> [1] "The months differ by more than chance usually gives (p = 0.0041)"`

The `$points` of each part give the details, such as the p-value of the
test and how many months it compared.

[`plot_seasonality()`](https://sedzinfo.github.io/golemstockindices/reference/plot_seasonality.md)
shows the mean return of each group, with the median as a diamond, and
under it the share of returns above 0. Hover over a bar for all the
numbers of its group:

[`plot_seasonality`](https://sedzinfo.github.io/golemstockindices/reference/plot_seasonality.md)`(``months``)`

[`seasonality_table()`](https://sedzinfo.github.io/golemstockindices/reference/seasonality_table.md)
shows the numbers as a table:

[`seasonality_table`](https://sedzinfo.github.io/golemstockindices/reference/seasonality_table.md)`(``months``)`

The other periods work the same way, for example the days of the week:

[`plot_seasonality`](https://sedzinfo.github.io/golemstockindices/reference/plot_seasonality.md)`(`[`seasonality_analysis`](https://sedzinfo.github.io/golemstockindices/reference/seasonality_analysis.md)`(``spx``, ``"day"``)``)`

## Dark mode and saving

Like the price charts, every `plot_` function takes `mode = "dark"` for
a dark page. The charts are plotly objects, and the tables are DT
tables, so
[`htmlwidgets::saveWidget()`](https://rdrr.io/pkg/htmlwidgets/man/saveWidget.html)
saves any of them as a web page:

`htmlwidgets``::`[`saveWidget`](https://rdrr.io/pkg/htmlwidgets/man/saveWidget.html)`(`[`plot_drawdowns`](https://sedzinfo.github.io/golemstockindices/reference/plot_drawdowns.md)`(``falls``)``, ``"drawdowns.html"``)`` ``htmlwidgets``::`[`saveWidget`](https://rdrr.io/pkg/htmlwidgets/man/saveWidget.html)`(`[`drawdown_table`](https://sedzinfo.github.io/golemstockindices/reference/drawdown_table.md)`(``falls``)``, ``"drawdowns_table.html"``)`
