# Which exchanges are open

For each exchange of the indices: its local time, and whether it is
open, at lunch or closed, with when that changes, from its regular
sessions on weekdays. Holidays are not known, so on a holiday an
exchange shows as open.

## Usage

``` r
market_status(now = Sys.time())
```

## Arguments

- now:

  The time to judge, now by default.

## Value

A data frame with a row per exchange, from west to east: `exchange`,
`local_time` (such as "10:42"), `state` ("open", "lunch" or "closed"),
`text`, when that changes (such as "closes 16:00", "reopens 12:30" or
"opens Mon 09:30"), `hours`, the regular sessions of the day (such as
"09:00–11:30, 12:30–15:30"), `time_zone` and `indices`, the labels of
its indices joined by commas.

## Examples

``` r
market_status()
#>        exchange local_time  state            text                    hours           time_zone                                                                 indices
#> 1   Mexico City      12:28 closed opens Mon 08:30              08:30–15:00 America/Mexico_City                                                              IPC Mexico
#> 2       Toronto      13:28 closed opens Mon 09:30              09:30–16:00     America/Toronto                                                       S&P/TSX Composite
#> 3      New York      13:28 closed opens Mon 09:30              09:30–16:00    America/New_York S&P 500, Dow Jones, Nasdaq Composite, NYSE Composite, Russell 2000, VIX
#> 4     São Paulo      15:28 closed opens Mon 10:00              10:00–18:00   America/Sao_Paulo                                                                 Bovespa
#> 5        London      18:28 closed opens Mon 08:00              08:00–16:30       Europe/London                                                                FTSE 100
#> 6     Frankfurt      19:28 closed opens Mon 09:00              09:00–17:30       Europe/Berlin                                    DAX, Euro Stoxx 50, STOXX Europe 600
#> 7         Paris      19:28 closed opens Mon 09:00              09:00–17:30        Europe/Paris                                                    CAC 40, Euronext 100
#> 8      Brussels      19:28 closed opens Mon 09:00              09:00–17:30     Europe/Brussels                                                                  BEL 20
#> 9        Madrid      19:28 closed opens Mon 09:00              09:00–17:30       Europe/Madrid                                                                 IBEX 35
#> 10        Milan      19:28 closed opens Mon 09:00              09:00–17:30         Europe/Rome                                                                FTSE MIB
#> 11       Zurich      19:28 closed opens Mon 09:00              09:00–17:30       Europe/Zurich                                                                     SMI
#> 12       Athens      20:28 closed opens Mon 10:00              10:00–17:20       Europe/Athens                                                          Athens General
#> 13       Mumbai      23:58 closed opens Mon 09:15              09:15–15:30        Asia/Kolkata                                                                  Sensex
#> 14      Jakarta      01:28 closed     opens 09:00 09:00–12:00, 13:30–15:50        Asia/Jakarta                                                           IDX Composite
#> 15 Kuala Lumpur      02:28 closed     opens 09:00 09:00–12:30, 14:30–17:00   Asia/Kuala_Lumpur                                                FTSE Bursa Malaysia KLCI
#> 16    Singapore      02:28 closed     opens 09:00              09:00–17:00      Asia/Singapore                                                           Straits Times
#> 17     Shanghai      02:28 closed     opens 09:30 09:30–11:30, 13:00–15:00       Asia/Shanghai                                                      Shanghai Composite
#> 18    Hong Kong      02:28 closed     opens 09:30 09:30–12:00, 13:00–16:00      Asia/Hong_Kong                                                               Hang Seng
#> 19       Taipei      02:28 closed     opens 09:00              09:00–13:30         Asia/Taipei                                                         Taiwan Weighted
#> 20        Seoul      03:28 closed     opens 09:00              09:00–15:30          Asia/Seoul                                                                   KOSPI
#> 21        Tokyo      03:28 closed     opens 09:00 09:00–11:30, 12:30–15:30          Asia/Tokyo                                                              Nikkei 225
#> 22       Sydney      05:28 closed     opens 10:00              10:00–16:00    Australia/Sydney                                                 ASX 200, All Ordinaries
#> 23   Wellington      07:28 closed     opens 10:00              10:00–16:45    Pacific/Auckland                                                                  NZX 50
# a Monday at 15:00 UTC: New York, London and the euro area are open
market_status(as.POSIXct("2026-11-09 15:00", tz = "UTC"))
#>        exchange local_time  state            text                    hours           time_zone                                                                 indices
#> 1   Mexico City      09:00   open    closes 15:00              08:30–15:00 America/Mexico_City                                                              IPC Mexico
#> 2       Toronto      10:00   open    closes 16:00              09:30–16:00     America/Toronto                                                       S&P/TSX Composite
#> 3      New York      10:00   open    closes 16:00              09:30–16:00    America/New_York S&P 500, Dow Jones, Nasdaq Composite, NYSE Composite, Russell 2000, VIX
#> 4     São Paulo      12:00   open    closes 18:00              10:00–18:00   America/Sao_Paulo                                                                 Bovespa
#> 5        London      15:00   open    closes 16:30              08:00–16:30       Europe/London                                                                FTSE 100
#> 6     Frankfurt      16:00   open    closes 17:30              09:00–17:30       Europe/Berlin                                    DAX, Euro Stoxx 50, STOXX Europe 600
#> 7         Paris      16:00   open    closes 17:30              09:00–17:30        Europe/Paris                                                    CAC 40, Euronext 100
#> 8      Brussels      16:00   open    closes 17:30              09:00–17:30     Europe/Brussels                                                                  BEL 20
#> 9        Madrid      16:00   open    closes 17:30              09:00–17:30       Europe/Madrid                                                                 IBEX 35
#> 10        Milan      16:00   open    closes 17:30              09:00–17:30         Europe/Rome                                                                FTSE MIB
#> 11       Zurich      16:00   open    closes 17:30              09:00–17:30       Europe/Zurich                                                                     SMI
#> 12       Athens      17:00   open    closes 17:20              10:00–17:20       Europe/Athens                                                          Athens General
#> 13       Mumbai      20:30 closed opens Tue 09:15              09:15–15:30        Asia/Kolkata                                                                  Sensex
#> 14      Jakarta      22:00 closed opens Tue 09:00 09:00–12:00, 13:30–15:50        Asia/Jakarta                                                           IDX Composite
#> 15 Kuala Lumpur      23:00 closed opens Tue 09:00 09:00–12:30, 14:30–17:00   Asia/Kuala_Lumpur                                                FTSE Bursa Malaysia KLCI
#> 16    Singapore      23:00 closed opens Tue 09:00              09:00–17:00      Asia/Singapore                                                           Straits Times
#> 17     Shanghai      23:00 closed opens Tue 09:30 09:30–11:30, 13:00–15:00       Asia/Shanghai                                                      Shanghai Composite
#> 18    Hong Kong      23:00 closed opens Tue 09:30 09:30–12:00, 13:00–16:00      Asia/Hong_Kong                                                               Hang Seng
#> 19       Taipei      23:00 closed opens Tue 09:00              09:00–13:30         Asia/Taipei                                                         Taiwan Weighted
#> 20        Seoul      00:00 closed     opens 09:00              09:00–15:30          Asia/Seoul                                                                   KOSPI
#> 21        Tokyo      00:00 closed     opens 09:00 09:00–11:30, 12:30–15:30          Asia/Tokyo                                                              Nikkei 225
#> 22       Sydney      02:00 closed     opens 10:00              10:00–16:00    Australia/Sydney                                                 ASX 200, All Ordinaries
#> 23   Wellington      04:00 closed     opens 10:00              10:00–16:45    Pacific/Auckland                                                                  NZX 50
```
