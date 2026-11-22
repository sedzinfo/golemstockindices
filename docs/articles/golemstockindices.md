# Get started

The charts of the [golemstockindices
app](https://sedzinfo-golemstockindices.share.connect.posit.cloud/) are
also R functions. Each one takes the prices you download with
[`get_history()`](https://sedzinfo.github.io/golemstockindices/reference/get_history.md)
and returns an interactive [plotly](https://plotly.com/r/) chart. Run it
in the console and the chart opens in the RStudio Viewer or your
browser. In an R Markdown or Quarto document it appears in the page.

This article shows the price charts. [Volatility, drawdowns and
seasonality](https://sedzinfo.github.io/golemstockindices/articles/analyses.md)
shows the charts of the analyses, and [The market
overview](https://sedzinfo.github.io/golemstockindices/articles/market.md)
shows the table and the chart that put all the indices side by side.

## Install and load the package

``` r

install.packages("golemstockindices",
  repos = c("https://sedzinfo.r-universe.dev", "https://cloud.r-project.org"))
```

``` r

library(golemstockindices)
```

The prices need no API key. They come from Yahoo Finance.

## Find an index

Indices are picked by their label, such as `"S&P 500"`.
[`get_indices()`](https://sedzinfo.github.io/golemstockindices/reference/get_indices.md)
lists them, with the `label` of each, its `region`, the `currency` of
the shares in it and its `type`:

``` r

indices <- get_indices()
table(indices$region)
#> 
#>       Africa     Americas Asia-Pacific       Europe           US 
#>            1            3           15           29            7
head(indices[, c("label", "region", "currency", "type")])
#>              label region currency  type
#> 1          S&P 500     US      USD price
#> 2        Dow Jones     US      USD price
#> 3 Nasdaq Composite     US      USD price
#> 4       Nasdaq-100     US      USD price
#> 5   NYSE Composite     US      USD price
#> 6     Russell 2000     US      USD price
```

The `type` is `"price"` for an index that leaves out the dividends of
its companies, such as the S&P 500, and `"total return"` for one that
reinvests them, such as the DAX. The charts mark the total return
indices (TR). The VIX measures the expected volatility of the S&P 500,
so it has no currency and no type.

## Download the prices

[`get_history()`](https://sedzinfo.github.io/golemstockindices/reference/get_history.md)
downloads the daily prices of one or more indices from a start date on,
a year ago by default. They are in index points, and there is a row per
day on which the exchange traded:

``` r

spx <- get_history("S&P 500", as.Date("1990-01-01"))
tail(spx[, c("label", "timestamp", "open", "high", "low", "close", "volume")])
#>        label  timestamp    open    high     low   close     volume
#> 9286 S&P 500 2026-11-13 7616.85 7621.78 7499.40 7561.67 4372990000
#> 9287 S&P 500 2026-11-16 7513.98 7515.60 7400.15 7416.59 5152460000
#> 9288 S&P 500 2026-11-17 7411.02 7415.37 7288.34 7340.53 5165100000
#> 9289 S&P 500 2026-11-18 7355.69 7367.68 7285.76 7323.63 5388180000
#> 9290 S&P 500 2026-11-19 7389.26 7415.64 7173.63 7175.83 5692800000
#> 9291 S&P 500 2026-11-20 7150.39 7198.67 6882.66 6910.39 6679680000
```

Each index’s prices are kept on disk between R sessions. Once they are
more than an hour old, only the last two weeks are downloaded again, so
later calls are fast. The history of the S&P 500 goes back to 1927. This
article starts at 1990, to keep the page light.

## Candlestick chart

[`plot_timeseries()`](https://sedzinfo.github.io/golemstockindices/reference/plot_timeseries.md)
draws the daily open, high, low and close prices of one index as
candles, with a line through the close and its 50- and 200-day moving
averages. The smaller charts underneath show the trading volume and the
drawdown: how far the price is below its all-time high so far.

``` r

plot_timeseries(spx)
```

Zoom with the range buttons (1 year, 6 months, 7 days, …) or the slider
under the chart. The Linear and Log buttons switch the axis of the
prices, and a click on a legend entry hides or shows that line.

The averages and the drawdown are calculated over the history you pass.
Pass all of it and zoom on the chart, rather than downloading a shorter
history. A history that starts in 1990 has no 200-day average before its
200th day, and its drawdown is measured from the highest close since
1990.

Choose other moving averages with `averages`, or none with
`averages = NULL`. Leave out the drawdown chart with
`show_drawdown = FALSE`. A chart of a long history is large, so this one
is not drawn here, to keep the page light:

``` r

plot_timeseries(spx, averages = c(20, 100), show_drawdown = FALSE)
```

`bollinger = TRUE` adds the Bollinger bands around the prices: the
20-day average and two standard deviations of the last 20 closes above
and below it. `show_rsi = TRUE` adds a panel under the prices with the
14-day relative strength index, from 0 to 100, with dashed lines at 30
and 70:

``` r

plot_timeseries(spx, bollinger = TRUE, show_rsi = TRUE)
```

[`bollinger_bands()`](https://sedzinfo.github.io/golemstockindices/reference/bollinger_bands.md)
and
[`rsi()`](https://sedzinfo.github.io/golemstockindices/reference/rsi.md)
calculate them, for your own charts or tables:

``` r

indicators <- data.frame(date = spx$timestamp, close = spx$close, bollinger_bands(spx$close), rsi = rsi(spx$close))
tail(indicators, 3)
#>            date   close   middle    upper    lower      rsi
#> 9289 2026-11-18 7323.63 7559.276 7819.530 7299.022 36.56191
#> 9290 2026-11-19 7175.83 7534.896 7839.184 7230.608 31.41340
#> 9291 2026-11-20 6910.39 7499.231 7904.112 7094.351 24.68925
```

## Compare indices

To compare several indices, download them together and pass them through
[`normalize_prices()`](https://sedzinfo.github.io/golemstockindices/reference/normalize_prices.md).
It starts every index at 100 on the first date on which all of them have
data, so 150 means the price rose by half since that date:

``` r

history <- get_history(c("S&P 500", "Euro Stoxx 50", "Nikkei 225"))
prices <- normalize_prices(history)
tail(prices[, c("label", "timestamp", "close", "index")])
#>       label  timestamp   close    index
#> 735 S&P 500 2026-11-13 7561.67 111.7618
#> 736 S&P 500 2026-11-16 7416.59 109.6175
#> 737 S&P 500 2026-11-17 7340.53 108.4934
#> 738 S&P 500 2026-11-18 7323.63 108.2436
#> 739 S&P 500 2026-11-19 7175.83 106.0591
#> 740 S&P 500 2026-11-20 6910.39 102.1359
plot_compare(prices)
```

The Linear and Log buttons switch the vertical axis. On the log axis
equal distances are equal percentages. The history is the last year,
because that is what
[`get_history()`](https://sedzinfo.github.io/golemstockindices/reference/get_history.md)
downloads when it has no start date.

To see how the indices did against one of them, pass the normalized
prices to
[`relative_prices()`](https://sedzinfo.github.io/golemstockindices/reference/relative_prices.md)
with the label of that index, the base. Each of the other lines is then
its ratio to the base, 100 at the start: above 100 the index did better
than the base since then, below it worse. Tell
[`plot_compare()`](https://sedzinfo.github.io/golemstockindices/reference/plot_compare.md)
the base, for the title and a dashed line at 100:

``` r

plot_compare(relative_prices(prices, "S&P 500"), base = "S&P 500")
```

## Currency conversion

Each index is in the money of its shares, so a chart of indices from
several countries mixes currencies.
[`convert_prices()`](https://sedzinfo.github.io/golemstockindices/reference/convert_prices.md)
converts the prices to US dollars (`"USD"`) or euros (`"EUR"`);
`"local"`, the default, leaves them as they are. It multiplies each
price by the exchange rate of its day, from Yahoo Finance. Volumes and
the VIX are left as they are.

Pass the converted history to
[`normalize_prices()`](https://sedzinfo.github.io/golemstockindices/reference/normalize_prices.md)
and tell
[`plot_compare()`](https://sedzinfo.github.io/golemstockindices/reference/plot_compare.md)
the currency, for the title:

``` r

euros <- convert_prices(history, "EUR")
plot_compare(normalize_prices(euros), currency = "EUR")
```

The daily rates are not taken at the close of each exchange, so the
change of a single day mixes in a few hours of the moves of the
currency. Over weeks and months this matters little.

## Monthly returns

[`monthly_returns()`](https://sedzinfo.github.io/golemstockindices/reference/monthly_returns.md)
turns an index’s prices into a matrix of returns in percent, with a row
per year and a column per month.
[`plot_returns_calendar()`](https://sedzinfo.github.io/golemstockindices/reference/plot_returns_calendar.md)
draws it as a heatmap, from red for falls to green for rises:

``` r

returns <- monthly_returns(spx)
tail(returns, 3)
#>       Jan   Feb   Mar   Apr  May   Jun   Jul  Aug   Sep   Oct   Nov   Dec
#> 2024 1.59  5.17  3.10 -4.16 4.80  3.47  1.13 2.28  2.02 -0.99  5.73 -2.50
#> 2025 2.70 -1.42 -5.75 -0.76 6.15  4.96  2.17 1.91  3.53  2.27  0.13 -0.05
#> 2026 1.37 -0.87 -5.09 10.42 5.15 -1.06 -0.13 2.62 -0.45 -0.93 -8.83    NA
plot_returns_calendar(returns, "S&P 500")
```

Each month’s return is its last close relative to the last close of the
month before. The first month and the months still to come are empty.

## Dark mode

Every chart function has a `mode` argument. `mode = "dark"` uses light
text and grid lines on a transparent background, for a page with a dark
background. On this page, which is light, its text would not show, so
the code is not run here:

``` r

plot_timeseries(spx, mode = "dark")
```

## Save or change a chart

The charts are plotly objects, so the functions of the plotly and
htmlwidgets packages work on them. To save a chart as a web page that
opens in any browser:

``` r

chart <- plot_compare(prices)
htmlwidgets::saveWidget(chart, "compare.html")
```

To change the layout, for example to add a title:

``` r

plotly::layout(chart,
  title = "The S&P 500, the Euro Stoxx 50 and the Nikkei 225 over the last year")
```
