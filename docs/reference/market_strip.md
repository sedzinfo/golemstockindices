# The strip of the exchanges that are open

A row of small labels, one per exchange, with a green dot when it is
open, an amber one at lunch and a grey one when it is closed. Hovering
over a label gives its local time, when that changes and its indices;
the table of
[`market_table()`](https://sedzinfo.github.io/golemstockindices/reference/market_table.md)
has them all.

## Usage

``` r
market_strip(status, table_id = NULL)
```

## Arguments

- status:

  The result of
  [`market_status()`](https://sedzinfo.github.io/golemstockindices/reference/market_status.md).

- table_id:

  The id of that table on the page, for a link to it, or `NULL` for
  none.

## Value

A `div` of Shiny UI elements.

## Examples

``` r
golemstockindices:::market_strip(market_status())
#> <div class="market-strip">
#>   <span class="market closed" title="11:14 local time, opens Mon 09:30 · S&amp;P/TSX Composite">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Toronto
#>   </span>
#>   <span class="market closed" title="11:14 local time, opens Mon 09:30 · S&amp;P 500, Dow Jones, Nasdaq Composite, Russell 2000, VIX">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     New York
#>   </span>
#>   <span class="market closed" title="13:14 local time, opens Mon 10:00 · Bovespa">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     São Paulo
#>   </span>
#>   <span class="market closed" title="16:14 local time, opens Mon 08:00 · FTSE 100">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     London
#>   </span>
#>   <span class="market closed" title="17:14 local time, opens Mon 09:00 · DAX, Euro Stoxx 50, STOXX Europe 600">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Frankfurt
#>   </span>
#>   <span class="market closed" title="17:14 local time, opens Mon 09:00 · CAC 40">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Paris
#>   </span>
#>   <span class="market closed" title="17:14 local time, opens Mon 09:00 · IBEX 35">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Madrid
#>   </span>
#>   <span class="market closed" title="17:14 local time, opens Mon 09:00 · FTSE MIB">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Milan
#>   </span>
#>   <span class="market closed" title="17:14 local time, opens Mon 09:00 · SMI">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Zurich
#>   </span>
#>   <span class="market closed" title="18:14 local time, opens Mon 10:00 · Athens General">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Athens
#>   </span>
#>   <span class="market closed" title="21:44 local time, opens Mon 09:15 · Sensex">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Mumbai
#>   </span>
#>   <span class="market closed" title="00:14 local time, opens Mon 09:30 · Shanghai Composite">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Shanghai
#>   </span>
#>   <span class="market closed" title="00:14 local time, opens Mon 09:30 · Hang Seng">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Hong Kong
#>   </span>
#>   <span class="market closed" title="01:14 local time, opens Mon 09:00 · KOSPI">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Seoul
#>   </span>
#>   <span class="market closed" title="01:14 local time, opens Mon 09:00 · Nikkei 225">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Tokyo
#>   </span>
#>   <span class="market closed" title="03:14 local time, opens Mon 10:00 · ASX 200">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Sydney
#>   </span>
#> </div>
```
