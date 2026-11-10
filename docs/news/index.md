# Changelog

## golemstockindices 0.1.0

- First version: a ‘shiny’ app for exploring 44 major stock market
  indices of the US (S&P 500, Dow Jones, Nasdaq Composite, NYSE
  Composite, Russell 2000), the rest of the Americas (S&P/TSX Composite,
  Bovespa, IPC Mexico), Europe (STOXX Europe 600, Euro Stoxx 50, FTSE
  100, DAX, CAC 40, IBEX 35, FTSE MIB, SMI, Euronext 100, BEL 20, AEX,
  ATX, ISEQ All Share, PSI, OMX Stockholm 30, OMX Copenhagen 25, OMX
  Helsinki 25, OSEBX, OMX Tallinn, OMX Riga, OMX Vilnius, Athens
  General, BIST 100) and Asia-Pacific (Nikkei 225, Shanghai Composite,
  Hang Seng, KOSPI, Taiwan Weighted, Sensex, Straits Times, ASX 200, All
  Ordinaries, NZX 50, IDX Composite, FTSE Bursa Malaysia KLCI), and the
  VIX, with daily prices from Yahoo Finance and no API key. The Bovespa
  starts in 1995, after Brazil’s hyperinflation. Start it with
  [`run_app()`](https://sedzinfo.github.io/golemstockindices/reference/run_app.md).
- Tabs:
  - **Overview** shows which exchanges are open now and where every
    index stands (its last close with a line of its last year, the
    change on the day, this year and over a year, and how far it is
    below its all-time high).
    [`market_status()`](https://sedzinfo.github.io/golemstockindices/reference/market_status.md),
    [`index_summary()`](https://sedzinfo.github.io/golemstockindices/reference/index_summary.md)
    and
    [`overview_table()`](https://sedzinfo.github.io/golemstockindices/reference/overview_table.md)
    do the same from R.
  - **Performance** charts the indices side by side over a day, a week,
    1, 3, 6 or 9 months, this year or a year, the best at the top.
    [`plot_performance()`](https://sedzinfo.github.io/golemstockindices/reference/plot_performance.md)
    does the same from R.
  - **Timeseries** plots the whole history of an index as candles, with
    the volume, the 50- and 200-day moving averages and the drawdown.
  - **Compare** plots up to 10 indices from a chosen start date, each
    starting at 100, on a linear or log scale.
  - **Returns calendar** shows the monthly returns by year.
  - **Seasonality** asks whether some days of the week, weeks of the
    year, months or years of the US presidential cycle bring better
    returns than others, with a Kruskal-Wallis test of whether the
    differences could be chance.
  - **Volatility** says whether the volatility of the last weeks and the
    move of the last days are normal, against the index’s history and a
    GARCH(1,1) model, and forecasts the next 5 trading days with the
    value at risk.
  - **Drawdowns** says how far the index is below its all-time high and
    how long its earlier falls took to recover, with a chart and a table
    of the falls.
  - **About** explains what each index measures and how every number of
    the app is calculated.
- The prices of the indices are downloaded at the same time (8 requests
  at once) instead of one after the other, so the Overview opens in
  about 4 seconds the first time instead of 13, and in about 2 instead
  of 6 when the kept prices are more than an hour old.
- The analysis code comes from golemcrypto, adapted to markets that
  close at weekends and on holidays: the windows count trading days, a
  year is 252 of them, a day’s return runs from the trading day before,
  and the forecast skips weekends.
- The data, calculations and charts can be used directly from R:
  [`get_indices()`](https://sedzinfo.github.io/golemstockindices/reference/get_indices.md),
  [`get_history()`](https://sedzinfo.github.io/golemstockindices/reference/get_history.md),
  [`index_summary()`](https://sedzinfo.github.io/golemstockindices/reference/index_summary.md),
  [`normalize_prices()`](https://sedzinfo.github.io/golemstockindices/reference/normalize_prices.md),
  [`monthly_returns()`](https://sedzinfo.github.io/golemstockindices/reference/monthly_returns.md),
  [`seasonality_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/seasonality_analysis.md),
  [`volatility_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/volatility_analysis.md),
  [`drawdown_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/drawdown_analysis.md),
  their `*_text()` functions, and the `plot_*()` and `*_table()`
  functions.
- Each index’s history is downloaded once and kept on disk between R
  sessions; after an hour only its last two weeks are downloaded again.
  Set `options(stockindices.cache_dir = )` to keep it elsewhere.
- `run_app(analytics = TRUE)` adds Google Analytics, through the cookie
  banner of the sedzinfo.github.io sites, which loads it only after the
  visitor accepts; `app.R` turns it on for the public deployment.
