Stock Market Indices shows the daily prices of the major stock market indices of the Americas, Europe and Asia-Pacific, from <a href="https://finance.yahoo.com" target="_blank" rel="noopener">Yahoo Finance</a>. This page explains what each index measures, what each tab shows and how its numbers are calculated. The CSV button of each tab downloads the data behind it, unrounded. The app is for exploring market data; it is not investment advice.

**On this page:** [The indices](#about-indices) · [Overview](#about-overview) · [Performance](#about-performance) · [Timeseries](#about-timeseries) · [Compare](#about-compare) · [Linear and log scales](#about-scales) · [Returns calendar](#about-calendar) · [Seasonality](#about-seasonality) · [Volatility](#about-volatility) · [Drawdowns](#about-drawdowns) · [Data and updates](#about-data)

<h3 id="about-indices">The indices</h3>

A stock market index follows the prices of a basket of shares as one number, in points. Its level means nothing by itself, as each index started at a number of its own choosing; its changes, in percent, are what count.

| Index | What it follows | Weighted by |
|---|---|---|
| S&P 500 | 500 large US companies | market value |
| Dow Jones | 30 large US companies | share price |
| Nasdaq Composite | the thousands of companies listed on the Nasdaq exchange, many of them in technology | market value |
| NYSE Composite | all the common stocks listed on the New York Stock Exchange, about 1,900 companies | market value |
| Russell 2000 | 2,000 smaller US companies | market value |
| VIX | the volatility of the S&P 500 that traders expect over the next 30 days, from the prices of its options | – |
| S&P/TSX Composite | the largest companies listed in Toronto, Canada | market value |
| Bovespa | the most traded companies listed in São Paulo, Brazil, with their dividends reinvested | market value |
| IPC Mexico | about 35 of the most traded companies listed in Mexico City | market value |
| STOXX Europe 600 | 600 large, mid-sized and small companies of 17 European countries, in and outside the euro area | market value |
| Euro Stoxx 50 | 50 large companies of the euro area | market value |
| FTSE 100 | the 100 largest companies listed in London | market value |
| DAX | the 40 largest German companies, with their dividends reinvested | market value |
| CAC 40 | 40 large French companies | market value |
| IBEX 35 | the 35 most traded Spanish companies | market value |
| FTSE MIB | 40 large Italian companies | market value |
| SMI | the 20 largest Swiss companies, such as Nestlé, Novartis and Roche | market value |
| Euronext 100 | the 100 largest and most traded companies listed on the Euronext exchanges of Paris, Amsterdam, Brussels, Lisbon and others | market value |
| BEL 20 | the 20 largest companies listed in Brussels, Belgium | market value |
| AEX | the 25 most traded companies listed in Amsterdam, the Netherlands, such as ASML and Shell | market value |
| ATX | the 20 largest companies listed in Vienna, Austria | market value |
| ISEQ All Share | all the Irish companies listed in Dublin, Ireland | market value |
| PSI | the largest companies listed in Lisbon, Portugal | market value |
| OMX Stockholm 30 | the 30 most traded companies listed in Stockholm, Sweden | market value |
| OMX Copenhagen 25 | the 25 most traded companies listed in Copenhagen, Denmark, such as Novo Nordisk | market value |
| OMX Helsinki 25 | the 25 most traded companies listed in Helsinki, Finland | market value |
| OSEBX | the benchmark index of Oslo, Norway: a selection of its most traded companies, with their dividends reinvested | market value |
| OMX Tallinn | all the companies of the main list of Tallinn, Estonia, with their dividends reinvested | market value |
| OMX Riga | all the companies of the main list of Riga, Latvia, with their dividends reinvested | market value |
| OMX Vilnius | all the companies of the main list of Vilnius, Lithuania, with their dividends reinvested | market value |
| Athens General | the largest companies listed on the Athens Exchange | market value |
| BIST 100 | the 100 largest companies listed in Istanbul, Turkey | market value |
| Nikkei 225 | 225 large Japanese companies | share price |
| Shanghai Composite | all the companies listed in Shanghai, China | market value |
| Hang Seng | the largest companies listed in Hong Kong | market value |
| KOSPI | all the companies of the main market of South Korea, such as Samsung | market value |
| Taiwan Weighted | all the companies listed on the Taiwan Stock Exchange, led by TSMC | market value |
| Sensex | 30 large companies listed in Mumbai, India | market value |
| Straits Times | the 30 largest companies listed in Singapore | market value |
| ASX 200 | the 200 largest companies listed in Sydney, Australia | market value |
| All Ordinaries | the 500 largest companies listed in Sydney, Australia | market value |
| NZX 50 | the 50 largest companies listed in New Zealand, with their dividends reinvested | market value |
| IDX Composite | all the companies listed on the Indonesia Stock Exchange, in Jakarta | market value |
| FTSE Bursa Malaysia KLCI | the 30 largest companies listed in Kuala Lumpur, Malaysia | market value |

A few of them are not like the rest. The **DAX**, the **Bovespa**, the **NZX 50**, the **OSEBX** and the three Baltic indices, **OMX Tallinn**, **OMX Riga** and **OMX Vilnius**, are performance indices: the dividends of their companies are added to them, while the others leave them out, so over long periods they rise faster than an index of the same shares would. The **VIX** is not a basket of shares but a measure of fear, in percent a year: it jumps when stocks fall sharply and sinks in calm markets, so its "falls" and "returns" mean something else than those of a stock index. The **Bovespa** starts in 1995 here: before the real, Brazil's currency since July 1994, inflation ran at thousands of percent a year, and the index rose as fast in the money of the time, which would swamp every return, seasonality and volatility of its history.

Each index is in the money of its shares (US, Canadian, Australian, New Zealand, Hong Kong, Singapore and Taiwan dollars, euros, pounds, Swiss francs, Swedish kronor, Danish and Norwegian kroner, Turkish lira, Mexican pesos, reais, yen, yuan, won, rupees, rupiah or ringgit), and none is converted, so comparing indices of different currencies mixes in the moves of the currencies, and an index of a country with high inflation rises partly because its money loses value: the BIST 100 rose from about 20 points in 1998 to thousands, while the lira lost most of its value.

<h3 id="about-overview">Overview</h3>

Where every index stands, in one table, grouped by region.

**The exchanges.** The labels at the top, from west to east, say which exchanges are open, with a green dot, at lunch, with an amber one (Jakarta, Kuala Lumpur, Shanghai, Hong Kong and Tokyo pause at midday), or closed, with a grey one. Hover over a label for its local time, when that changes and its indices; the Euro Stoxx 50 and the STOXX Europe 600, made of shares of many countries, go with Frankfurt, the Euronext 100, made of shares of several Euronext exchanges, with Paris, and the exchanges of Tallinn, Riga and Vilnius, which trade as one market, share the label Baltics. The table of the exchanges at the bottom of the page, which the link after the labels leads to, has all of it: the indices, the local time, the state now, the next opening or closing, the regular hours and the time zone of each exchange. Mexico City and São Paulo keep in step with New York: while the US is on summer time, Mexico City trades from 07:30 to 14:00 instead of 08:30 to 15:00, and São Paulo closes at 17:00 instead of 18:00. The regular weekday sessions are all the app knows: on a holiday an exchange shows as open, the longer Friday lunch of Jakarta is not known, and the indices are computed on their own schedules, the VIX for example also outside the hours of New York. While an exchange is open, its index shows the close of the day before. Yahoo Finance keeps the indices of Copenhagen and the Baltics on the hours of New York, so their close of the day shows only once New York has closed too.

**The table.** The line above it gives the day most indices last closed on, and the indices whose last close is of another day: the exchanges of Asia-Pacific close hours before those of Europe and the Americas, a holiday on one exchange leaves its last close a day behind the others, and a special session can put one a day ahead, even on a weekend, such as the hour of trading of Mumbai on the evening of Diwali.

| Column | What it is |
|---|---|
| `Index` | The name of the index, as in the pickers of the other tabs |
| `Region` | US, Americas (the rest of them), Europe or Asia-Pacific |
| `Close` | The last close, in points |
| `Last year` | The closes of the last 365 days as a small line, green when the year ended higher than it began and red when lower; each line has its own scale, from its lowest to its highest close |
| `Date` | The day of that close, on the calendar of the exchange |
| `Day` | The change from the close before, in percent |
| `Year to date` | The change since the last close of last year |
| `1 year` | The change since the last close a year or more ago |
| `From high` | How far the last close is below the highest close in the history, the drawdown of the Timeseries tab |
| `High` | That highest close |
| `High on` | Its day |
| `Currency` | The money of the shares in the index; none for the VIX |
| `Since` | The first day of the history |

The changes are shaded red for falls and green for rises, and the distance from the high red. Each column has a scale of its own, from no color near zero to the deepest shade at its largest value, as a day's moves are much smaller than a year's.

The CSV button downloads the table with the changes over a week and a month too.

<h3 id="about-performance">Performance</h3>

How the indices compare, in one chart: the change of each over the period picked above it, the best at the top, green for rises and red for falls. The periods are those of the Overview table: the day (since the close before), a week or a month (since the last close a week or a month before), this year (since the last close of last year) or a year (since the last close a year or more ago). Each index counts from its own last close, so after a holiday on one exchange its day can be a day older than the others'. An index whose history is shorter than the period is left out, and so is the VIX: it measures fear rather than the value of shares, and its swings of tens of percent would squeeze the others into slivers. Each change is in the currency of the index (see [The indices](#about-indices)). The CSV button downloads the changes of the chart, best first, with the region, currency, date and close of each index.

<h3 id="about-timeseries">Timeseries</h3>

The daily prices of one index over its whole history, up to the last day that has ended. Pick the index in the box above the chart; the Returns calendar, Seasonality, Volatility and Drawdowns tabs use the index picked here.

**Candles.** One per trading day. The body spans the open and the close, and the thin lines reach the day's high and low. A green candle closed above its open, a red one below it. Hover over a day for its four prices. For their first years, Yahoo Finance has only the close of some indices (the S&P 500 until 1962, the Nasdaq Composite until 1984, the Nikkei 225 until 1988, the Straits Times until 1992, the IDX Composite until 1995, the NYSE Composite until 2003), so their candles are flat lines there.

**close** (the orange line) is the last level of each day. Every calculation in the app starts from it.

**50-day and 200-day average** are simple moving averages of the close:

```
average(t) = (close(t) + close(t−1) + … + close(t−n+1)) / n        n = 50 or 200
```

Each day's value is the mean of the last n closes, that day included, so the first n − 1 days have none. The days are trading days, so 200 days are about ten months. The averages smooth out the daily swings: an index above its average trades above its recent trend. Traders call the 50-day average crossing above the 200-day one a *golden cross*, and crossing below it a *death cross*. Both lag the index by design, the 200-day average more.

**Volume** is the number of shares traded in the stocks of the index that day, as Yahoo Finance reports it. It is missing, and shows as 0, for the early years of most indices, and the VIX, which is not traded itself, has none, so its chart has no volume panel.

**From high**, the drawdown, is how far each close is below the highest close up to that day:

```
from high(t) = (close(t) / highest close up to t − 1) × 100
```

It is 0% on a day that closes at a new high, and −50% at half of it. The high is taken over the whole history, so zooming in does not change it. A fall needs a larger rise to recover: from −50% the index has to double (+100%), from −80% rise fivefold (+400%), from −90% tenfold (+900%):

```
rise needed = (100 / (100 + from high) − 1) × 100
```

**Zoom** with the buttons above the chart (7 days to all) or the slider under it; the averages and the drawdown always use the whole history. The buttons count back from the right edge of the chart as it is, so after dragging the slider, *7 days* shows the week before the new edge, and *all* brings back the whole history. Each vertical axis follows the days in view, from their lowest to their highest value, so the candles of a week fill the chart and their lows and highs can be compared; the volume and the drawdown keep 0 in view. Click a legend entry to hide or show its line.

**Linear and Log** switch the axis of the prices (see [Linear and log scales](#about-scales)). Over the whole history the log axis is the fairer view: on the linear one the S&P 500 of the 1950s, between 17 and 60 points, lies flat next to today's thousands, while on the log axis a 10% move is equally tall in any decade.

<h3 id="about-compare">Compare</h3>

Up to 10 indices on one chart, each starting at 100, so that indices at very different levels can be compared:

```
index(t) = 100 × close(t) / close(t₀)
```

t₀ is the first day, on or after the start date, on which every selected index has a price; an index whose history starts after the start date moves t₀ to its first day. The chart title shows t₀. The exchanges have holidays of their own, so on some days a line has no new point.

The result has no unit: it is the close as a percentage of the close on t₀. Read it as what 100 put into the index at the close of t₀ would be worth, before fees and, except for the performance indices (see [The indices](#about-indices)), without the dividends: 150 means +50% since t₀, 80 means −20%, and 1,000 means ten times as much. The ratio of two lines compares two indices: when A is at 300 and B at 150, A has done twice as well as B since t₀. Each index is in its own currency.

The average growth per year (the compound annual growth rate) after d calendar days is

```
growth per year = ((index(t) / 100) ^ (365 / d) − 1) × 100
```

For example, 400 after two years (730 days) is +100% a year, as 4 ^ (365 / 730) = 2: the money doubled twice.

<h3 id="about-scales">Linear and log scales</h3>

The Linear and Log buttons above the Compare chart change how the vertical axis is drawn, not the data.

- **Linear**: equal distances on the axis are equal differences. 100 → 200 is as tall as 1,000 → 1,100, a rise of 100 points either way, although the first doubled the money and the second added 10%.
- **Log** (logarithmic): equal distances are equal ratios, because each value sits at the height of its logarithm, log₁₀(index). 100 → 200 is as tall as 1,000 → 2,000, as both doubled, and 100 → 1,000 as tall as 1,000 → 10,000. Between powers of ten, plotly may label the gridlines with their first digit only: 2 and 5 after 100 stand for 200 and 500.

<!-- scales example -->

Two made-up indices on both axes: one doubles every year, the other grows by 25% a year. On the linear axis the slower one looks flat, and the faster one seems to take off only at the end, although both grow at a steady rate. On the log axis both are straight lines, and the steeper line is the faster growth.

A log axis helps when:

- **the moves are large**: over long periods, or for indices that rose tenfold next to indices that rose by half. On a linear axis the largest line squeezes the others into a flat band at the bottom.
- **percentages matter more than points**: a 50% fall is equally tall at any level, so crashes that started from different heights can be compared.
- **you judge the trend**: a steady growth rate is a straight line, and its slope is the rate. A line that curves upwards grows faster and faster; one that bends down is slowing.
- **you compare indices**: the vertical gap between two lines is the ratio of their values, so lines that run parallel performed the same over that stretch, however far apart they are.

A log axis cannot show 0 or negative values, which the lines never reach. A linear axis is the better choice for short periods and small moves, within about ±20% of 100, where the two look almost the same, and when you want the gain in points: on the Compare chart, points are the gain on 100 put in.

<h3 id="about-calendar">Returns calendar</h3>

The monthly returns of the index picked in the Timeseries tab, a row per year and a column per month:

```
return(month) = (last close of the month / last close of the month before − 1) × 100
```

The last close of a month is that of its last trading day. The index's first month has no month before it and stays empty, as do the months to come. The current month is the return so far, up to the latest close, and changes until the month ends.

Returns compound; they do not add up. A year's return is

```
return(year) = ((1 + r₁ / 100) × (1 + r₂ / 100) × … × (1 + r₁₂ / 100) − 1) × 100
```

so +50% in one month and −50% in the next leave −25%, not 0.

The colors are red for losses and green for gains, symmetric around 0, and reach their deepest at the 95th percentile of the index's monthly returns in absolute value. They are scaled to the index's own swings, so the same shade means a bigger move for a volatile index than for a calm one. Reading down a column compares the same month across years; whether a pattern there is more than chance, the Seasonality tab tests.

<h3 id="about-seasonality">Seasonality</h3>

Do some days, weeks, months or years bring better returns than others? The tab answers for the index picked in the Timeseries tab, for the returns picked above the cards:

| Returns of | Grouped by |
|---|---|
| days | the day of the week, Monday to Friday |
| weeks | the week of the year, Monday to Sunday, numbered as in ISO 8601: week 1 holds the first Thursday of the year, so the first days of January can belong to week 52 or 53 of the year before, and only some years have a week 53 |
| months | the month |
| years | the year of the 4-year US presidential cycle |

Each return covers a whole period, from the last close of the period before to the last close of the period:

```
return(period) = (last close of the period / last close of the period before − 1) × 100
```

The markets close at weekends and on holidays, so a day's return runs from the close of the trading day before: a Monday's return is the move from Friday's close, the weekend included, and the day after a holiday covers the holiday too. A day more than 4 calendar days after the trading day before, which only a gap in the data or a long closure leaves, is left out. The monthly returns are those of the Returns calendar. Only complete periods count: a period has ended when the history goes on after it, or when its last close is on its last weekday, and the period before must be the one just before it. So the index's first period, which has none before it, and the current one, which has not ended, are left out.

**The presidential cycle.** US presidential elections come every four years, in years divisible by 4, and many investors see a 4-year cycle in the market around them: weak in the first two years of a presidency, strong in the year before the next election. The tab puts each year in it: *Post-election* (2017, 2021, 2025), *Midterm*, the year of the elections to Congress (2018, 2022, 2026), *Pre-election* (2019, 2023, 2027) and *Election year* (2016, 2020, 2024). The cycle is American, but as the other markets tend to follow Wall Street, it is applied to every index. Only the S&P 500 goes back far enough for about 24 returns per year of the cycle; for the indices that start in the 1990s or later, each year of the cycle has a handful, too few for firm conclusions.

**Best and worst.** The first card names the groups with the highest and lowest mean return, with their median and how often they rose. The mean is the average return, and one huge month can carry it, as a crash or a rebound does; the median, the middle return, is the typical one. When the two disagree, the median is the safer guide. Groups with fewer than half the returns of the others, such as week 53, are left out of the best and the worst, as a group of one or two returns ranks by luck. The last point gives the same numbers for all the returns together, to compare each group with.

**Chance.** Any history has a best and a worst group, so the second card asks whether the differences are larger than chance would give. The Kruskal-Wallis test compares the ranks of the returns of the groups rather than their values, so a few extreme returns do not decide it. Its p-value is the probability of differences at least as large as these in a history in which the group made no difference: below 0.05 they are unlikely to be chance alone, above it they could well be. A p-value says nothing about the size of a difference, nor whether it will last: the "weekend effect", Mondays weaker than the other days, was strong in the S&P 500 for decades and has faded since it became widely known. The test takes the returns as independent, which market returns are only roughly, as calm and wild stretches come in runs, and the more groups there are, the more one of them stands out by luck: with 52 weeks to choose from, the best week of an index's history usually looks remarkable.

**The chart.** At the top, the mean return of each group as a bar, green for gains and red for losses, with the median as a diamond. At the bottom, the share of the group's returns that were gains, with a dashed line at 50%. Hover over a bar for all the numbers of its group.

**The table** lists the groups in their natural order: the returns counted, the mean and the median, the share up, and the best and the worst return. The mean and the median are shaded red below 0 and green above it, and the share up red below 50% and green above it, more strongly the further they are from the middle. The CSV button downloads it, unrounded.

<h3 id="about-volatility">Volatility</h3>

Is the index's recent volatility normal, and what may the next days bring? The tab answers for the index picked in the Timeseries tab, in words in three cards and in a chart. Everything starts from the daily log returns,

```
r(t) = log(close(t) / close(t−1))
```

from the close of one trading day to the next, which add up over days; the percentages shown are converted back, (e^r − 1) × 100. All the windows count trading days, about 21 a month and 252 a year. An index needs more than a year of history for the tab.

**The windows.** The first card looks at the last month (21 trading days) and the second at the move of the last 2 trading days, unless other windows are picked above the cards: *Volatility over* 1 week (5 trading days), 2 weeks (10), 1 month (21), 2 months (42) or 3 months (63), and *Recent move* over 1, 2 or 3 trading days or a week (5). The text below uses the defaults. Each window is compared with every past window of the same length, so the verdicts stay fair at any length, but a short window is noisier: the volatility of a week has about twice the random error of that of a month, so its level jumps around more, while 3 months are steadier and slower to react.

**The last month.** The volatility is the standard deviation of the 21 daily returns, annualized with the 252 trading days of a year:

```
volatility = sd(r over 21 days) × √252 × 100        in % a year
```

The card compares it with the year before the month, and with every 21-day period in the index's history: its percentile among them gives the level, *normal* below the 60th, *elevated* to the 85th, *high* to the 95th and *extreme* above. Two tests ask whether the month varied more than the year before: the F test of their variances, which a few extreme days can sway, and the Fligner-Killeen test, which they cannot. When only the F test finds a difference (p < 0.05), a few large days made the month look rough, not the month as a whole. The largest day is measured in standard deviations of the year before it, and the card says how often days moved that many of their own year's standard deviations in the index's history. Last, the return of the month is placed among all 21-day returns.

**The last 2 trading days.** Three measures of how rare the move of the last two days is:

1. **History**: the share of all 2-day moves in the index's history that were as large in the same direction, as times a year.
2. **Against the year before**: the move in standard deviations of the year before it, z = (r₁ + r₂) / (sd × √2), and how often 2-day moves reached as many standard deviations of their own year. Over n days, the sum of the n returns is divided by sd × √n.
3. **GARCH**: a model of how volatility clusters, the most used in finance. Each day's variance is expected from the day before:

```
σ²(t) = ω + α × e(t−1)² + β × σ²(t−1)        e = r − μ
```

so a large move raises the volatility the model expects for the next days, which then fades at the rate β. The daily moves e / σ follow a Student-t distribution, whose fat tails allow more extreme days than the normal distribution. The model is fitted by maximum likelihood to the 4 years before the two days, so it judges them against the volatility it expected without having seen them. The probability of a move at least as large, p, gives *about 1 in 1/p trading days*. The verdict follows it: *normal* for about once a month or more often (under 21 trading days), *unusual* for less than monthly but more than once a year (under 252), *rare* for once in 1 to 10 years, and *very rare* beyond. The card also judges the most extreme of the two days alone, as a large move can hide in a 2-day total when the other day went the opposite way. An index with less than 500 trading days before the two days has no model, and the verdict comes from the second measure.

**Volume.** The last point of the card compares each day's volume, the shares traded, with the median volume of the 21 trading days before it, whatever window is picked:

```
volume ratio(t) = volume(t) / median(volume(t−21), …, volume(t−1))
```

2 is twice the usual volume of the time and 0.5 half of it. The median keeps a single busy day from raising the bar, and the ratio follows the index's volume as it grows over the years. How unusual a ratio is comes from the index's history: the share of days whose own ratio was at least as high, or as low for a quiet day, with the same words and thresholds as for the moves. A large move on unusually high volume had many traders behind it; on normal or low volume it happened in a thinner market. Days without volume, which the early years of most indices and the whole history of the VIX have, are left out.

The history measures say how large a move is; the standard deviations and the model say how large it is given the volatility of the time, as a 2% day is a shock in a calm market and routine in a rough one. The probabilities hold if the model holds: in crashes the tails are often fatter still, so *1 in N days* tends to overstate how rare a move is.

**The next days.** The third card looks ahead with the same model, its variance brought up to the last day. The variance of the next day follows from the last day, and later days fall back towards the model's long-run level at the rate α + β a day:

```
σ²(T+1) = ω + α × e(T)² + β × σ²(T)
σ²(T+h) = σ²∞ + (α + β)^(h−1) × (σ²(T+1) − σ²∞)        σ²∞ = ω / (1 − α − β)
```

The half-life, log(0.5) / log(α + β), is the number of trading days the volatility takes to get half-way back to that level. The card compares the next day's volatility with it rather than with the volatility of the first card: with fat tails, the model's standard deviation counts the rare extreme days, which a calm month may not have had, so it runs higher than the volatility measured over a month.

The forecast covers the next 5 trading days, the weekdays after the last close; holidays are not known, so one of them can fall on a holiday. The range of the next day comes straight from the model's Student-t distribution. The ranges of the next 5 days come from 50,000 simulated paths of the model, in which a large day raises the volatility of the days after it; the paths start from a fixed seed, so the numbers do not change when the chart is drawn again. A 95% range leaves 2.5% of the outcomes below it and 2.5% above.

The value at risk (VaR) is the loss exceeded on the worst 5% of days, and the expected shortfall (ES) the average loss on those days. The card gives both for the next day, from the model, and for the last 252 trading days, from the daily returns themselves:

```
VaR = −(5th percentile of the daily returns)        ES = −(average of the returns below it)
```

Losses are falls of the index in percent. The 95% range and the 95% VaR differ: the range leaves out 2.5% on each side, the VaR 5% on the downside alone, so the VaR is the smaller loss. The last point checks the model's VaR against the last 252 trading days with the Kupiec test: a well-calibrated VaR is exceeded on about 5% of the days, some 13 a year, and a p-value below 0.05 means it was exceeded more often, so the model understates the risk, or less often, so it overstates it. The forecast assumes that the model holds. It cannot foresee news: its ranges say how far the index usually moves at this level of volatility, not where it will go.

**The chart.** At the top, the volatility of the window over the whole history, with its median and 95th percentile. In the middle, each of the last 63 trading days in the standard deviations the model expected, with dashed lines at ±2 and dotted ones at ±4. At the bottom, the last 21 closes and the forecast of the next 5 trading days: the median close, the middle half of the outcomes (50%) and the 95% range; hover over the median for a day's ranges. The CSV button downloads the data day by day: the daily return, the volume and its ratio, the volatility of the window, the standard deviation and value at risk the model expected, and the forecast of the days ahead.

<h3 id="about-drawdowns">Drawdowns</h3>

How far is the index below its all-time high, and how long did its earlier falls take to recover? The tab answers for the index picked in the Timeseries tab, in two cards, a chart and a table. It splits the history into **falls**: a fall starts on the last close at an all-time high, the *peak*, goes down to its lowest close, the *trough*, and ends on the first close back at or above the peak. The depth of a fall is

```
fall = (trough / peak − 1) × 100
```

and its days are calendar days: from the peak to the trough, from the trough back to the high, and in all. The highs are those of the history Yahoo Finance has: the S&P 500's goes back to 1927, so its deepest fall is the crash of 1929, which took the index until 1954 to recover, while the Dow Jones starts only in 1992 here.

**Now.** How far the last close is below the all-time high, and the rise it needs to get back there (the formula of the Timeseries tab). The lowest close since the high gives the depth of the current fall so far, which ranks it among all the falls of the history, and the card lists the earlier falls that went at least as deep: how many days they took to get back to their high, from the peak and from the trough. Every earlier fall did get back, as only the last fall can still be open. The days of the earlier falls describe the past, not when the current one will end.

**The history.** The falls of 10%, 20% (the default), 30% or 50% or more, as picked above the cards: how many there were, the deepest, the median fall with the median days to its trough and back to its high, the share of trading days that closed that far below the high, and the days that closed at a new all-time high.

**The chart.** At the top, the close on a log scale, on which equal distances are equal percentages, with the all-time high so far as a dotted line. At the bottom, how far each close is below that high, with a dashed line at the depth picked. Each fall of that depth or more is shaded from its peak to its recovery, the current one in amber, and its trough carries its rank; hover over a trough for its dates.

**The table** lists the falls, the deepest first, with the rank of the chart; the current fall is in bold and has no recovery yet. The CSV button downloads it, with the dates and levels unrounded.

<h3 id="about-data">Data and updates</h3>

- The daily prices come from Yahoo Finance, which offers them free and without a key, for personal use. It is not an official source: its data can have gaps and errors, and it can change how it serves them without notice, so a chart may at times fail to appear.
- The dates are those of each exchange, and a day counts once its exchange has closed: while a market is open, its index shows the close of the day before.
- An index's whole history is downloaded the first time it is picked and kept on the server. It is brought up to date when it is more than {{history_minutes}} minutes old: its last two weeks are downloaded again, which also picks up any correction of the last days.
- Weekends and holidays have no prices. The holidays of each exchange are its own, which is why the indices of different regions have different numbers of trading days.
