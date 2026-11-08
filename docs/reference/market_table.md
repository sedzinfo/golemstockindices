# The table of the exchanges and their trading hours

A row per exchange, from west to east: its indices, its local time,
whether it is open, at lunch or closed, with the dot of the strip of
[`market_strip()`](https://sedzinfo.github.io/golemstockindices/reference/market_strip.md),
when that changes, its regular sessions and its time zone.

## Usage

``` r
market_table(status)
```

## Arguments

- status:

  The result of
  [`market_status()`](https://sedzinfo.github.io/golemstockindices/reference/market_status.md).

## Value

A `table` of Shiny UI elements.

## Examples

``` r
golemstockindices:::market_table(market_status())
#> <table class="table table-sm align-middle market-table">
#>   <thead>
#>     <tr>
#>       <th class="text-nowrap">Exchange</th>
#>       <th>Indices</th>
#>       <th class="text-nowrap">Local time</th>
#>       <th class="text-nowrap">Now</th>
#>       <th class="text-nowrap">Next</th>
#>       <th class="text-nowrap">Regular hours</th>
#>       <th class="text-nowrap">Time zone</th>
#>     </tr>
#>   </thead>
#>   <tbody>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Toronto</strong>
#>       </td>
#>       <td class="market-indices">S&amp;P/TSX Composite</td>
#>       <td class="market-time">13:48</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 09:30</td>
#>       <td class="market-time">09:30–16:00</td>
#>       <td class="text-body-secondary text-nowrap">America/Toronto</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>New York</strong>
#>       </td>
#>       <td class="market-indices">S&amp;P 500, Dow Jones, Nasdaq Composite, Russell 2000, VIX</td>
#>       <td class="market-time">13:48</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 09:30</td>
#>       <td class="market-time">09:30–16:00</td>
#>       <td class="text-body-secondary text-nowrap">America/New_York</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>São Paulo</strong>
#>       </td>
#>       <td class="market-indices">Bovespa</td>
#>       <td class="market-time">15:48</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 10:00</td>
#>       <td class="market-time">10:00–18:00</td>
#>       <td class="text-body-secondary text-nowrap">America/Sao_Paulo</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>London</strong>
#>       </td>
#>       <td class="market-indices">FTSE 100</td>
#>       <td class="market-time">18:48</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 08:00</td>
#>       <td class="market-time">08:00–16:30</td>
#>       <td class="text-body-secondary text-nowrap">Europe/London</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Frankfurt</strong>
#>       </td>
#>       <td class="market-indices">DAX, Euro Stoxx 50, STOXX Europe 600</td>
#>       <td class="market-time">19:48</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 09:00</td>
#>       <td class="market-time">09:00–17:30</td>
#>       <td class="text-body-secondary text-nowrap">Europe/Berlin</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Paris</strong>
#>       </td>
#>       <td class="market-indices">CAC 40</td>
#>       <td class="market-time">19:48</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 09:00</td>
#>       <td class="market-time">09:00–17:30</td>
#>       <td class="text-body-secondary text-nowrap">Europe/Paris</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Madrid</strong>
#>       </td>
#>       <td class="market-indices">IBEX 35</td>
#>       <td class="market-time">19:48</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 09:00</td>
#>       <td class="market-time">09:00–17:30</td>
#>       <td class="text-body-secondary text-nowrap">Europe/Madrid</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Milan</strong>
#>       </td>
#>       <td class="market-indices">FTSE MIB</td>
#>       <td class="market-time">19:48</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 09:00</td>
#>       <td class="market-time">09:00–17:30</td>
#>       <td class="text-body-secondary text-nowrap">Europe/Rome</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Zurich</strong>
#>       </td>
#>       <td class="market-indices">SMI</td>
#>       <td class="market-time">19:48</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 09:00</td>
#>       <td class="market-time">09:00–17:30</td>
#>       <td class="text-body-secondary text-nowrap">Europe/Zurich</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Athens</strong>
#>       </td>
#>       <td class="market-indices">Athens General</td>
#>       <td class="market-time">20:48</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 10:00</td>
#>       <td class="market-time">10:00–17:20</td>
#>       <td class="text-body-secondary text-nowrap">Europe/Athens</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Mumbai</strong>
#>       </td>
#>       <td class="market-indices">Sensex</td>
#>       <td class="market-time">00:18</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens 09:15</td>
#>       <td class="market-time">09:15–15:30</td>
#>       <td class="text-body-secondary text-nowrap">Asia/Kolkata</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Shanghai</strong>
#>       </td>
#>       <td class="market-indices">Shanghai Composite</td>
#>       <td class="market-time">02:48</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens 09:30</td>
#>       <td class="market-time">09:30–11:30, 13:00–15:00</td>
#>       <td class="text-body-secondary text-nowrap">Asia/Shanghai</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Hong Kong</strong>
#>       </td>
#>       <td class="market-indices">Hang Seng</td>
#>       <td class="market-time">02:48</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens 09:30</td>
#>       <td class="market-time">09:30–12:00, 13:00–16:00</td>
#>       <td class="text-body-secondary text-nowrap">Asia/Hong_Kong</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Seoul</strong>
#>       </td>
#>       <td class="market-indices">KOSPI</td>
#>       <td class="market-time">03:48</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens 09:00</td>
#>       <td class="market-time">09:00–15:30</td>
#>       <td class="text-body-secondary text-nowrap">Asia/Seoul</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Tokyo</strong>
#>       </td>
#>       <td class="market-indices">Nikkei 225</td>
#>       <td class="market-time">03:48</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens 09:00</td>
#>       <td class="market-time">09:00–11:30, 12:30–15:30</td>
#>       <td class="text-body-secondary text-nowrap">Asia/Tokyo</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Sydney</strong>
#>       </td>
#>       <td class="market-indices">ASX 200</td>
#>       <td class="market-time">05:48</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens 10:00</td>
#>       <td class="market-time">10:00–16:00</td>
#>       <td class="text-body-secondary text-nowrap">Australia/Sydney</td>
#>     </tr>
#>   </tbody>
#> </table>
```
