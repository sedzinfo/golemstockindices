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
#>         <strong>Mexico City</strong>
#>       </td>
#>       <td class="market-indices">IPC Mexico</td>
#>       <td class="market-time">05:46</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 08:30</td>
#>       <td class="market-time">08:30–15:00</td>
#>       <td class="text-body-secondary text-nowrap">America/Mexico_City</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Toronto</strong>
#>       </td>
#>       <td class="market-indices">S&amp;P/TSX Composite</td>
#>       <td class="market-time">06:46</td>
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
#>       <td class="market-indices">S&amp;P 500, Dow Jones, Nasdaq Composite, NYSE Composite, Russell 2000, VIX</td>
#>       <td class="market-time">06:46</td>
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
#>       <td class="market-time">08:46</td>
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
#>         <strong>Lisbon</strong>
#>       </td>
#>       <td class="market-indices">PSI</td>
#>       <td class="market-time">11:46</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 08:00</td>
#>       <td class="market-time">08:00–16:30</td>
#>       <td class="text-body-secondary text-nowrap">Europe/Lisbon</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Dublin</strong>
#>       </td>
#>       <td class="market-indices">ISEQ All Share</td>
#>       <td class="market-time">11:46</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 08:00</td>
#>       <td class="market-time">08:00–16:30</td>
#>       <td class="text-body-secondary text-nowrap">Europe/Dublin</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>London</strong>
#>       </td>
#>       <td class="market-indices">FTSE 100, FTSE 250</td>
#>       <td class="market-time">11:46</td>
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
#>       <td class="market-indices">DAX, MDAX, SDAX, TecDAX, Euro Stoxx 50, STOXX Europe 600</td>
#>       <td class="market-time">12:46</td>
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
#>       <td class="market-indices">CAC 40, Euronext 100, Next 150</td>
#>       <td class="market-time">12:46</td>
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
#>         <strong>Brussels</strong>
#>       </td>
#>       <td class="market-indices">BEL 20</td>
#>       <td class="market-time">12:46</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 09:00</td>
#>       <td class="market-time">09:00–17:30</td>
#>       <td class="text-body-secondary text-nowrap">Europe/Brussels</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Amsterdam</strong>
#>       </td>
#>       <td class="market-indices">AEX</td>
#>       <td class="market-time">12:46</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 09:00</td>
#>       <td class="market-time">09:00–17:30</td>
#>       <td class="text-body-secondary text-nowrap">Europe/Amsterdam</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Madrid</strong>
#>       </td>
#>       <td class="market-indices">IBEX 35</td>
#>       <td class="market-time">12:46</td>
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
#>       <td class="market-time">12:46</td>
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
#>       <td class="market-time">12:46</td>
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
#>         <strong>Oslo</strong>
#>       </td>
#>       <td class="market-indices">OSEBX</td>
#>       <td class="market-time">12:46</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 09:00</td>
#>       <td class="market-time">09:00–16:20</td>
#>       <td class="text-body-secondary text-nowrap">Europe/Oslo</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Copenhagen</strong>
#>       </td>
#>       <td class="market-indices">OMX Copenhagen 25</td>
#>       <td class="market-time">12:46</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 09:00</td>
#>       <td class="market-time">09:00–17:00</td>
#>       <td class="text-body-secondary text-nowrap">Europe/Copenhagen</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Vienna</strong>
#>       </td>
#>       <td class="market-indices">ATX</td>
#>       <td class="market-time">12:46</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 09:00</td>
#>       <td class="market-time">09:00–17:30</td>
#>       <td class="text-body-secondary text-nowrap">Europe/Vienna</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Stockholm</strong>
#>       </td>
#>       <td class="market-indices">OMX Stockholm 30</td>
#>       <td class="market-time">12:46</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 09:00</td>
#>       <td class="market-time">09:00–17:30</td>
#>       <td class="text-body-secondary text-nowrap">Europe/Stockholm</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Baltics</strong>
#>       </td>
#>       <td class="market-indices">OMX Tallinn, OMX Riga, OMX Vilnius</td>
#>       <td class="market-time">13:46</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 10:00</td>
#>       <td class="market-time">10:00–16:00</td>
#>       <td class="text-body-secondary text-nowrap">Europe/Riga</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Helsinki</strong>
#>       </td>
#>       <td class="market-indices">OMX Helsinki 25</td>
#>       <td class="market-time">13:46</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 10:00</td>
#>       <td class="market-time">10:00–18:30</td>
#>       <td class="text-body-secondary text-nowrap">Europe/Helsinki</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Athens</strong>
#>       </td>
#>       <td class="market-indices">Athens General</td>
#>       <td class="market-time">13:46</td>
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
#>         <strong>Istanbul</strong>
#>       </td>
#>       <td class="market-indices">BIST 100</td>
#>       <td class="market-time">14:46</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 10:00</td>
#>       <td class="market-time">10:00–18:00</td>
#>       <td class="text-body-secondary text-nowrap">Europe/Istanbul</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Mumbai</strong>
#>       </td>
#>       <td class="market-indices">Sensex</td>
#>       <td class="market-time">17:16</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 09:15</td>
#>       <td class="market-time">09:15–15:30</td>
#>       <td class="text-body-secondary text-nowrap">Asia/Kolkata</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Jakarta</strong>
#>       </td>
#>       <td class="market-indices">IDX Composite</td>
#>       <td class="market-time">18:46</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 09:00</td>
#>       <td class="market-time">09:00–12:00, 13:30–15:50</td>
#>       <td class="text-body-secondary text-nowrap">Asia/Jakarta</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Kuala Lumpur</strong>
#>       </td>
#>       <td class="market-indices">FTSE Bursa Malaysia KLCI</td>
#>       <td class="market-time">19:46</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 09:00</td>
#>       <td class="market-time">09:00–12:30, 14:30–17:00</td>
#>       <td class="text-body-secondary text-nowrap">Asia/Kuala_Lumpur</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Singapore</strong>
#>       </td>
#>       <td class="market-indices">Straits Times</td>
#>       <td class="market-time">19:46</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 09:00</td>
#>       <td class="market-time">09:00–17:00</td>
#>       <td class="text-body-secondary text-nowrap">Asia/Singapore</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Shanghai</strong>
#>       </td>
#>       <td class="market-indices">Shanghai Composite</td>
#>       <td class="market-time">19:46</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 09:30</td>
#>       <td class="market-time">09:30–11:30, 13:00–15:00</td>
#>       <td class="text-body-secondary text-nowrap">Asia/Shanghai</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Hong Kong</strong>
#>       </td>
#>       <td class="market-indices">Hang Seng</td>
#>       <td class="market-time">19:46</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 09:30</td>
#>       <td class="market-time">09:30–12:00, 13:00–16:00</td>
#>       <td class="text-body-secondary text-nowrap">Asia/Hong_Kong</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Taipei</strong>
#>       </td>
#>       <td class="market-indices">Taiwan Weighted</td>
#>       <td class="market-time">19:46</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 09:00</td>
#>       <td class="market-time">09:00–13:30</td>
#>       <td class="text-body-secondary text-nowrap">Asia/Taipei</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Seoul</strong>
#>       </td>
#>       <td class="market-indices">KOSPI</td>
#>       <td class="market-time">20:46</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 09:00</td>
#>       <td class="market-time">09:00–15:30</td>
#>       <td class="text-body-secondary text-nowrap">Asia/Seoul</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Tokyo</strong>
#>       </td>
#>       <td class="market-indices">Nikkei 225</td>
#>       <td class="market-time">20:46</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 09:00</td>
#>       <td class="market-time">09:00–11:30, 12:30–15:30</td>
#>       <td class="text-body-secondary text-nowrap">Asia/Tokyo</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Sydney</strong>
#>       </td>
#>       <td class="market-indices">ASX 200, All Ordinaries</td>
#>       <td class="market-time">22:46</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 10:00</td>
#>       <td class="market-time">10:00–16:00</td>
#>       <td class="text-body-secondary text-nowrap">Australia/Sydney</td>
#>     </tr>
#>     <tr>
#>       <td class="text-nowrap">
#>         <strong>Wellington</strong>
#>       </td>
#>       <td class="market-indices">NZX 50</td>
#>       <td class="market-time">00:46</td>
#>       <td>
#>         <span class="market-state closed">
#>           <span class="market-dot" aria-hidden="true"></span>
#>           Closed
#>         </span>
#>       </td>
#>       <td class="text-nowrap">opens Mon 10:00</td>
#>       <td class="market-time">10:00–16:45</td>
#>       <td class="text-body-secondary text-nowrap">Pacific/Auckland</td>
#>     </tr>
#>   </tbody>
#> </table>
```
