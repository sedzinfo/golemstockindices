# TODO

Ideas for golemstockindices. Unless noted, each uses only the daily
prices the app already downloads.

## New tabs

**Correlations**: heatmap of the correlations of the daily returns of
the indices over a chosen period, and the rolling 1-year correlation of
two indices (do markets move together more in crises?)

**Holding periods**: for every start day, the return of holding for 1,
5, 10 or 20 years: how often it lost money, and the best, worst and
median yearly return

**Risk vs return**: scatter of the yearly return against the volatility
of every index, with the return per unit of risk, in the chosen currency

**Return distribution**: histogram of the daily returns against the
normal curve, with the skew, the fat tails and the biggest up and down
days

**What happened next**: the returns 1, 3 and 12 months after the index
fell X% from its high, or after the VIX rose above 30 (builds on
[`drawdown_episodes()`](https://sedzinfo.github.io/golemstockindices/reference/drawdown_episodes.md))

## Existing tabs

**Seasonality**: turn of the month, days before holidays, “Sell in May”
(May–October against November–April), the Santa rally

**Compare**: ratio mode (A ÷ B) for relative strength, such as
Nasdaq/S&P 500, Russell 2000/S&P 500, Euro Stoxx 50/S&P 500

**Overview**: distance from the 52-week high and low, above or below the
200-day average, the current up or down streak

**Timeseries**: optional RSI and Bollinger bands (the log scale was
already there)

## New data

**Dividends included**: total-return indices from Yahoo Finance, such as
`^SP500TR`, to show the price return against the total return

**After inflation**: monthly CPI from FRED (CSV download, no API key)
for real returns

**VIX term structure**: `^VIX9D`, `^VIX3M` and `^VIX6M`

**Market context**: the 10-year Treasury yield (`^TNX`), gold and the
dollar index as reference lines
