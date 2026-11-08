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
#>   <span class="market closed" title="12:55 local time, opens Mon 08:30 · IPC Mexico">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Mexico City
#>   </span>
#>   <span class="market closed" title="13:55 local time, opens Mon 09:30 · S&amp;P/TSX Composite">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Toronto
#>   </span>
#>   <span class="market closed" title="13:55 local time, opens Mon 09:30 · S&amp;P 500, Dow Jones, Nasdaq Composite, NYSE Composite, Russell 2000, VIX">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     New York
#>   </span>
#>   <span class="market closed" title="15:55 local time, opens Mon 10:00 · Bovespa">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     São Paulo
#>   </span>
#>   <span class="market closed" title="18:55 local time, opens Mon 08:00 · PSI">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Lisbon
#>   </span>
#>   <span class="market closed" title="18:55 local time, opens Mon 08:00 · ISEQ All Share">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Dublin
#>   </span>
#>   <span class="market closed" title="18:55 local time, opens Mon 08:00 · FTSE 100">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     London
#>   </span>
#>   <span class="market closed" title="19:55 local time, opens Mon 09:00 · DAX, Euro Stoxx 50, STOXX Europe 600">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Frankfurt
#>   </span>
#>   <span class="market closed" title="19:55 local time, opens Mon 09:00 · CAC 40, Euronext 100">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Paris
#>   </span>
#>   <span class="market closed" title="19:55 local time, opens Mon 09:00 · BEL 20">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Brussels
#>   </span>
#>   <span class="market closed" title="19:55 local time, opens Mon 09:00 · AEX">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Amsterdam
#>   </span>
#>   <span class="market closed" title="19:55 local time, opens Mon 09:00 · IBEX 35">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Madrid
#>   </span>
#>   <span class="market closed" title="19:55 local time, opens Mon 09:00 · FTSE MIB">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Milan
#>   </span>
#>   <span class="market closed" title="19:55 local time, opens Mon 09:00 · SMI">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Zurich
#>   </span>
#>   <span class="market closed" title="19:55 local time, opens Mon 09:00 · OSEBX">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Oslo
#>   </span>
#>   <span class="market closed" title="19:55 local time, opens Mon 09:00 · OMX Copenhagen 25">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Copenhagen
#>   </span>
#>   <span class="market closed" title="19:55 local time, opens Mon 09:00 · ATX">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Vienna
#>   </span>
#>   <span class="market closed" title="19:55 local time, opens Mon 09:00 · OMX Stockholm 30">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Stockholm
#>   </span>
#>   <span class="market closed" title="20:55 local time, opens Mon 10:00 · OMX Tallinn, OMX Riga, OMX Vilnius">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Baltics
#>   </span>
#>   <span class="market closed" title="20:55 local time, opens Mon 10:00 · OMX Helsinki 25">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Helsinki
#>   </span>
#>   <span class="market closed" title="20:55 local time, opens Mon 10:00 · Athens General">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Athens
#>   </span>
#>   <span class="market closed" title="21:55 local time, opens Mon 10:00 · BIST 100">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Istanbul
#>   </span>
#>   <span class="market closed" title="00:25 local time, opens 09:15 · Sensex">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Mumbai
#>   </span>
#>   <span class="market closed" title="01:55 local time, opens 09:00 · IDX Composite">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Jakarta
#>   </span>
#>   <span class="market closed" title="02:55 local time, opens 09:00 · FTSE Bursa Malaysia KLCI">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Kuala Lumpur
#>   </span>
#>   <span class="market closed" title="02:55 local time, opens 09:00 · Straits Times">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Singapore
#>   </span>
#>   <span class="market closed" title="02:55 local time, opens 09:30 · Shanghai Composite">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Shanghai
#>   </span>
#>   <span class="market closed" title="02:55 local time, opens 09:30 · Hang Seng">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Hong Kong
#>   </span>
#>   <span class="market closed" title="02:55 local time, opens 09:00 · Taiwan Weighted">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Taipei
#>   </span>
#>   <span class="market closed" title="03:55 local time, opens 09:00 · KOSPI">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Seoul
#>   </span>
#>   <span class="market closed" title="03:55 local time, opens 09:00 · Nikkei 225">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Tokyo
#>   </span>
#>   <span class="market closed" title="05:55 local time, opens 10:00 · ASX 200, All Ordinaries">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Sydney
#>   </span>
#>   <span class="market closed" title="07:55 local time, opens 10:00 · NZX 50">
#>     <span class="market-dot" aria-hidden="true"></span>
#>     Wellington
#>   </span>
#> </div>
```
