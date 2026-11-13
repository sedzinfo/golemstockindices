# Stock Market Indices

explore the major stock market indices

**[Open the live app](https://sedzinfo-golemstockindices.share.connect.posit.cloud/)** · [Website](https://sedzinfo.github.io/golemstockindices/)

An interactive R Shiny application for exploring the major stock market indices of the Americas, Europe and Asia-Pacific: where each stands today, its whole history, how it compares with the others, its seasonality, whether its recent volatility is normal and how far it is below its all-time high.

## Features

- **49 indices**: S&P 500, Dow Jones, Nasdaq Composite, NYSE Composite, Russell 2000 and the VIX in the US; S&P/TSX Composite, Bovespa and IPC Mexico in the Americas; STOXX Europe 600, Euro Stoxx 50, FTSE 100, FTSE 250, DAX, MDAX, SDAX, TecDAX, CAC 40, IBEX 35, FTSE MIB, SMI, Euronext 100, Next 150, BEL 20, AEX, ATX, ISEQ All Share, PSI, OMX Stockholm 30, OMX Copenhagen 25, OMX Helsinki 25, OSEBX, OMX Tallinn, OMX Riga, OMX Vilnius, Athens General and BIST 100 in Europe; Nikkei 225, Shanghai Composite, Hang Seng, KOSPI, Taiwan Weighted, Sensex, Straits Times, ASX 200, All Ordinaries, NZX 50, IDX Composite and FTSE Bursa Malaysia KLCI in Asia-Pacific
- **Overview**: Which exchanges are open now, every index in one table with a line of its last year, its last close, the change on the day, this year and over a year, and how far it is below its all-time high
- **Performance**: The indices side by side in one chart, the best at the top, over the day, a week, 1, 3, 6 or 9 months, this year or a year
- **Interactive Candlestick Charts**: The whole history of an index, back to 1927 for the S&P 500, with the volume, the 50- and 200-day moving averages and the drawdown
- **Index Comparison**: Compare up to 10 indices, each starting at 100, on a linear or log scale
- **Returns Calendar**: Monthly returns by year
- **Seasonality**: Whether some days of the week, weeks of the year, months or years of the US presidential cycle bring better returns than others, with a test of whether the differences could be chance
- **Volatility**: Whether the volatility of the last weeks and the move of the last days are normal, against the index's history and a GARCH model, and a forecast of the next 5 trading days with the value at risk
- **Drawdowns**: How far the index is below its all-time high, and how deep its earlier falls went and how long they took to recover
- **No API key**: Daily prices from Yahoo Finance, kept on disk and brought up to date once an hour
- **Light and Dark Mode**: Switch with the toggle in the navigation bar
- **CSV Downloads**: Download the data behind every tab as a CSV file
- **About Tab**: What every index measures, what every tab shows and how its numbers are calculated, with the formulas

# Quick Start

## Installation Instructions

### Prerequisites

- R (≥ 4.0.0) - [Download here](https://cran.r-project.org/)
- RStudio IDE (recommended) - [Download here](https://posit.co/downloads)

Open RStudio (or an R console) and run:
```r
# Install devtools if you haven't already
install.packages("devtools")
library(devtools)
# Install the package from GitHub
install_github("sedzinfo/golemstockindices")
```

Without devtools, install the source tarball of the [latest release](https://github.com/sedzinfo/golemstockindices/releases/tag/latest), which is rebuilt from `main` on every change, together with the PDF manual:

```r
install.packages(
  "https://github.com/sedzinfo/golemstockindices/releases/download/latest/golemstockindices_0.1.0.tar.gz",
  repos = NULL, type = "source"
)
```

## Usage
Launch the Shiny app with just two lines of code:

```r
library(golemstockindices)
run_app()
```

The application will open in your default web browser. No API key is needed. Any [`shiny::shinyApp()`](https://shiny.posit.co/r/reference/shiny/latest/shinyapp.html) option can be passed on, for example `run_app(options = list(port = 8080))`.

## Using the Functions in R

The data, calculations and charts of the app are also available as functions, for scripts and R Markdown reports:

```r
library(golemstockindices)

# the indices, and where each stands
get_indices()
all <- get_history(get_indices()$label, as.Date("1900-01-01"))
overview_table(index_summary(all))

# one index since 2020: candlestick chart and monthly returns
spx <- get_history("S&P 500", as.Date("2020-01-01"))
plot_timeseries(spx)
plot_returns_calendar(monthly_returns(spx), "S&P 500", mode = "dark")

# the whole history of the S&P 500, since 1927
spx <- get_history("S&P 500", as.Date("1900-01-01"))

# are some days, months or years of the presidential cycle better than others?
seasons <- seasonality_analysis(spx, "year")
seasonality_text(seasons)
plot_seasonality(seasons)

# is the recent volatility normal? (needs more than a year of history)
analysis <- volatility_analysis(spx)
volatility_text(analysis)
analysis$forecast$days   # the 95% range of the next 5 closes
plot_volatility(analysis)

# how far below its all-time high, against its earlier falls
falls <- drawdown_analysis(spx)
drawdown_text(falls)
plot_drawdowns(falls)

# several indices over the last year, starting at 100
history <- get_history(c("S&P 500", "Euro Stoxx 50", "Nikkei 225"))
plot_compare(normalize_prices(history))
```

Indices are picked by their label, such as `"S&P 500"`, and `get_indices()` lists all of them with their Yahoo Finance symbols. The histories are kept on disk between R sessions (see [Data Source](#data-source)).

## Application Overview

### Overview Tab
- Which exchanges are open, at lunch or closed right now, and at the bottom a table of their local times, next opening or closing and regular hours
- A table of all the indices, grouped by region: the last close and its date, a small line of the last year, the change on the day, this year and over a year, how far each is below its all-time high, that high and its date, the currency and the first day of the history
- The changes are shaded red for falls and green for rises

### Performance Tab
- A chart of the indices side by side over the day, a week, 1, 3, 6 or 9 months, this year or a year, the best at the top, green for rises and red for falls
- The VIX, and any index whose history is shorter than the period, is left out

### Timeseries Tab
- Pick an index; the Returns calendar, Seasonality, Volatility and Drawdowns tabs use it too
- Candlestick chart of the whole history, with zoom, pan, hover tooltips and date range buttons
- The vertical axes follow the days in view, so a week's candles fill the chart; a Linear/Log switch shows the whole history in proportion
- Volume chart synchronized with the main chart, when the index has volume
- 50- and 200-day moving averages; click a legend entry to hide or show a line
- Drawdown chart: how far the index is below its all-time high

### Compare Tab
- Pick up to 10 indices and a start date
- Each index's close starts at 100 on the first date all of them have data
- Switch between a linear and a log scale

### Returns Calendar Tab
- Monthly returns by year for the index selected in the Timeseries tab

### Seasonality Tab
- The returns of complete trading days, weeks, months or years, grouped by day of the week, ISO week of the year, month or year of the US presidential cycle
- Two cards name the best and the worst group and say whether the differences could be chance, with a Kruskal-Wallis test
- A chart and a table of the groups

### Volatility Tab
- Two cards say in words whether the volatility of the last month and the move of the last 2 trading days are normal: against the year before, against the index's whole history, and against a GARCH(1,1) model with Student-t errors fitted to the 4 years before, and whether their volume is unusual
- Pickers measure the volatility over 1 week to 3 months, and the recent move over 1 to 5 trading days
- A third card forecasts the next 5 trading days with the same model, with the value at risk and a Kupiec test of how well it held
- A chart of the volatility over the whole history, of the last 63 trading days in the standard deviations the model expected, and of the forecast

### Drawdowns Tab
- Two cards say how far the index is below its all-time high, the rise it needs to get back there, and how long the earlier falls that went as deep took to recover
- A chart of the close on a log scale and of how far it is below its high, with each fall of 10%, 20%, 30% or 50% or more shaded
- A table of those falls, the deepest first

### About Tab
- What each index measures and how it is weighted, what every tab shows and how its numbers are calculated
- The text is in `inst/app/about.md`, so it can be edited without touching the R code

## Screenshots

### Overview
![The 33 exchanges, from Mexico City to Wellington, with a dot for open or closed, and where the 49 indices stand: the last close with a line of the last year, the change on the day, this year and over a year, and the distance from the all-time high](https://github.com/sedzinfo/golemstockindices/raw/main/screenshots/stock1.png)

### Performance (dark mode)
![The 43 stock indices side by side by their change this year, the best at the top, green for rises and red for falls](https://github.com/sedzinfo/golemstockindices/raw/main/screenshots/stock2.png)

### Index Chart
![Candlestick, volume and drawdown chart of the S&P 500 since 1927, on a log scale](https://github.com/sedzinfo/golemstockindices/raw/main/screenshots/stock3.png)

### Zoomed In (dark mode)
![The last 3 months of the S&P 500, with the vertical axes fitted to the days in view](https://github.com/sedzinfo/golemstockindices/raw/main/screenshots/stock4.png)

### Index Comparison
![The S&P 500, the Euro Stoxx 50 and the Nikkei 225 over the last year, each starting at 100](https://github.com/sedzinfo/golemstockindices/raw/main/screenshots/stock5.png)

### Returns Calendar (dark mode)
![Monthly returns of the S&P 500 by year since 1927](https://github.com/sedzinfo/golemstockindices/raw/main/screenshots/stock6.png)

### Seasonality
![S&P 500 returns by year of the US presidential cycle since 1928, with a table of the years, the best and the worst year, and a Kruskal-Wallis test of whether the differences could be chance](https://github.com/sedzinfo/golemstockindices/raw/main/screenshots/stock7.png)

### Volatility (dark mode)
![The volatility of the S&P 500 since 1927, its last 63 trading days in GARCH standard deviations and the forecast of its next 5 trading days, with whether the volatility of its last month and the move of its last 2 trading days are normal, and the value at risk](https://github.com/sedzinfo/golemstockindices/raw/main/screenshots/stock8.png)

### Drawdowns
![How far the S&P 500 is below its all-time high and its 12 falls of 20% or more since 1927, on a log-scale chart, a chart of the distance from the high and a table of the falls](https://github.com/sedzinfo/golemstockindices/raw/main/screenshots/stock9.png)

## Dependencies

This package relies on several R packages:

- `shiny` - Web application framework
- `bslib` - Bootstrap 5 theme and the light/dark mode toggle
- `plotly` - Interactive plotting
- `DT` - Interactive tables
- `shinycssloaders` - Loading spinners
- `curl` and `jsonlite` - Downloads from Yahoo Finance
- `cachem` - The histories kept on disk

All dependencies will be automatically installed with the package.

## Data Source

The daily prices come from [Yahoo Finance](https://finance.yahoo.com/), which offers them free and without a key, for personal use. It is not an official source: it can change how it serves the data without notice.

Each index's whole history is downloaded in a single request the first time it is needed, and kept on disk between R sessions, in the folder given by `tools::R_user_dir("golemstockindices", "cache")`. When it is more than an hour old, only its last two weeks are downloaded again. To keep the downloads somewhere else, set `options(stockindices.cache_dir = "path/to/folder")`, and delete the folder to start over.

Markets close at weekends and on holidays, so the histories have a price for each trading day of the index's exchange, on the exchange's own dates. The last day counts once its exchange has closed.

## Development

The package follows the layout of a [golem](https://thinkr-open.github.io/golem/) app, without depending on golem, and shares its analysis code with [golemcrypto](https://github.com/sedzinfo/golemcrypto), adapted to trading days:

| File | Contents |
|---|---|
| `R/run_app.R` | `run_app()`, which starts the app |
| `R/app_ui.R`, `R/app_server.R` | The page layout and the server, which connect the modules |
| `R/mod_*.R` | One Shiny module per tab |
| `R/fct_data.R` | The indices, and the downloads from Yahoo Finance with their cache |
| `R/fct_calc.R` | Calculations: normalized prices, monthly returns, and where each index stands |
| `R/fct_seasonality.R` | The returns by day, week, month and year of the presidential cycle, and their text |
| `R/fct_volatility.R` | The volatility analysis, with its GARCH model, forecast and value at risk, and its text |
| `R/fct_drawdown.R` | The falls from the all-time high and their text |
| `R/fct_plots.R` | The plotly charts and the tables |
| `R/utils_helpers.R` | Color scales and light/dark mode helpers |
| `inst/app/www/` | Favicon, styles and the keep-alive script |
| `inst/app/about.md` | The text of the About tab |
| `tests/testthat/` | Tests, which run offline on small sample data |

Run the tests with `devtools::test()`, and the full package check with `devtools::check()`.

### Deploying

`app.R` starts the app with Google Analytics behind the cookie banner of the sedzinfo.github.io sites, and without the keep-alive pings, so the app goes to sleep when nobody uses it. `.rscignore` keeps the upload to the files the app needs.

- **Posit Connect Cloud** deploys from the GitHub repository and its `manifest.json`. Make it with `rsconnect::writeManifest(appDir = ".", appPrimaryDoc = "app.R")` and commit it; make it again whenever files are added or the packages are updated.
- **shinyapps.io**: connect your account once, with the `rsconnect::setAccountInfo()` line from Account, Tokens, then run `rsconnect::deployApp(appName = "golemstockindices")` from the package folder.

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/sedzinfo/golemstockindices/issues).

---

![Stars](https://img.shields.io/github/stars/sedzinfo/golemstockindices)
![Watchers](https://img.shields.io/github/watchers/sedzinfo/golemstockindices)
![Repo Size](https://img.shields.io/github/repo-size/sedzinfo/golemstockindices)
![Open Issues](https://img.shields.io/github/issues/sedzinfo/golemstockindices)
![Forks](https://img.shields.io/github/forks/sedzinfo/golemstockindices)
![Last Commit](https://img.shields.io/github/last-commit/sedzinfo/golemstockindices)
![Contributors](https://img.shields.io/github/contributors/sedzinfo/golemstockindices)
![License](https://img.shields.io/github/license/sedzinfo/golemstockindices)
![Workflow Status](https://img.shields.io/github/actions/workflow/status/sedzinfo/golemstockindices/build-tarball.yml)
![R-CMD-check](https://github.com/sedzinfo/golemstockindices/actions/workflows/R-CMD-check.yaml/badge.svg)
