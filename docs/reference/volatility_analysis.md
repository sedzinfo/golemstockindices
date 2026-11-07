# Volatility analysis of an index

Is the index's recent volatility normal? The analysis looks at the daily
log returns, `log(close(t) / close(t-1))`, from the close of one trading
day to the next, in two ways. All the windows count trading days, and a
year is 252 of them.

**The last month** (`month_days` trading days, 21 by default): its
volatility, the standard deviation of the daily returns times
`sqrt(252)`, against the year before it and against every past period of
the same length; an F test and the Fligner-Killeen test, which is robust
to a few extreme days, of whether its variance is larger than the year
before; its largest daily move, in standard deviations of the year
before; and its return against every past period of the same length.

**The last days** (`recent_days` days): their return against every past
period of as many days; the same, in standard deviations of the year
before; a GARCH(1,1) model with Student-t errors (see
[`garch_fit()`](https://sedzinfo.github.io/golemstockindices/reference/garch_fit.md)),
fitted to the `garch_years` years before them, which judges each day
against the volatility the model expected for it given the days before;
and each day's volume against the `volume_days` days before it (see
[`volume_ratio()`](https://sedzinfo.github.io/golemstockindices/reference/volume_ratio.md)),
judged by how often the index's volume was as far from usual.

**The next days** (`forecast_days` days): the same model, with its
variance brought up to the last day, forecasts the volatility and the
range of the price (see
[`garch_forecast()`](https://sedzinfo.github.io/golemstockindices/reference/garch_forecast.md)),
and gives the value at risk and the expected shortfall of the next day
(see
[`garch_risk()`](https://sedzinfo.github.io/golemstockindices/reference/garch_risk.md)).
A Kupiec test (see
[`kupiec_test()`](https://sedzinfo.github.io/golemstockindices/reference/kupiec_test.md))
checks how often the model's value at risk was exceeded over the last
year. The value at risk and expected shortfall of the last year's daily
returns are given without the model too.

## Usage

``` r
volatility_analysis(
  history,
  month_days = 21,
  recent_days = 2,
  garch_years = 4,
  forecast_days = 5,
  level = 0.95,
  volume_days = 21
)
```

## Arguments

- history:

  Price history of one index from
  [`get_history()`](https://sedzinfo.github.io/golemstockindices/reference/get_history.md),
  sorted by date. The comparisons use the whole history, so pass all of
  it.

- month_days:

  Trading days of the volatility window, the "month": 21, or for example
  5 for the last week or 63 for the last quarter.

- recent_days:

  Trading days in the recent move, such as 1 for the last day alone.

- garch_years:

  Years of history to fit the GARCH model to.

- forecast_days:

  Trading days to forecast, the weekdays after the last day.

- level:

  Probability of the forecast ranges, and of the value at risk: 0.95 is
  the 95% range and the worst 5% of days.

- volume_days:

  Trading days before each day whose median volume the day's volume is
  compared with.

## Value

`NULL` when the history is not longer than a year and the longer of
`month_days` and `recent_days`, or the price did not move at all in the
year before the month or the last days, otherwise a list with

- `index`, `first_date` and `last_date`;

- `month`: a list of the month's measures, see the code;

- `recent`: a list of the measures of the last days, with a `days` data
  frame of each day's return, GARCH measures, `volume`, `volume_ratio`
  and `volume_one_in_days` (`NA` without volume);

- `garch`: the fitted model, or `NULL` when it could not be fitted or
  there are fewer than 500 days before the last days;

- `forecast`: `NULL` without a model, otherwise a list with `days`, a
  data frame with a row per day ahead: its `date`, `sigma` (the daily
  standard deviation the model expects, in percent) and the closes
  `low`, `low_50`, `median`, `high_50` and `high` of the ranges (see
  [`garch_forecast()`](https://sedzinfo.github.io/golemstockindices/reference/garch_forecast.md));
  `sigma` and `sigma_long_run`, the daily standard deviation expected
  for the next day and in the long run; `half_life`, the days for the
  volatility to get half-way back to the long run; `var` and `es`, the
  value at risk and expected shortfall of the next day; and `backtest`,
  the `days`, `exceedances` and `p_value` of the Kupiec test;

- `history_risk`: `var` and `es` of the daily returns of the last
  `days` (252) trading days, in percent;

- `series`: a data frame with a row per day and the columns `date`,
  `close`, `volume`, `return_pct`, `volume_ratio` (see
  [`volume_ratio()`](https://sedzinfo.github.io/golemstockindices/reference/volume_ratio.md)),
  `volatility_month` (of the `month_days` days up to the day,
  annualized, in percent), `garch_sigma` (the daily standard deviation
  the model expected, in percent), `garch_z` (the day's move in those
  standard deviations) and `garch_var` (the model's value at risk for
  the day, in percent);

- `settings`: `month_days`, `recent_days`, `garch_years`,
  `forecast_days`, `level` and `volume_days`.

## Examples

``` r
if (FALSE) { # interactive()
spx <- get_history("S&P 500", as.Date("1950-01-01"))
analysis <- volatility_analysis(spx)
analysis$month$level
analysis$recent$days
analysis$forecast$days
volatility_text(analysis)
# the volatility of the last week, and the move of the last day
volatility_text(volatility_analysis(spx, month_days = 5, recent_days = 1))$month$headline
}
```
