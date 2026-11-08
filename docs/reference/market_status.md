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
#>     exchange local_time  state            text                    hours         time_zone                                                 indices
#> 1    Toronto      13:48 closed opens Mon 09:30              09:30–16:00   America/Toronto                                       S&P/TSX Composite
#> 2   New York      13:48 closed opens Mon 09:30              09:30–16:00  America/New_York S&P 500, Dow Jones, Nasdaq Composite, Russell 2000, VIX
#> 3  São Paulo      15:48 closed opens Mon 10:00              10:00–18:00 America/Sao_Paulo                                                 Bovespa
#> 4     London      18:48 closed opens Mon 08:00              08:00–16:30     Europe/London                                                FTSE 100
#> 5  Frankfurt      19:48 closed opens Mon 09:00              09:00–17:30     Europe/Berlin                    DAX, Euro Stoxx 50, STOXX Europe 600
#> 6      Paris      19:48 closed opens Mon 09:00              09:00–17:30      Europe/Paris                                                  CAC 40
#> 7     Madrid      19:48 closed opens Mon 09:00              09:00–17:30     Europe/Madrid                                                 IBEX 35
#> 8      Milan      19:48 closed opens Mon 09:00              09:00–17:30       Europe/Rome                                                FTSE MIB
#> 9     Zurich      19:48 closed opens Mon 09:00              09:00–17:30     Europe/Zurich                                                     SMI
#> 10    Athens      20:48 closed opens Mon 10:00              10:00–17:20     Europe/Athens                                          Athens General
#> 11    Mumbai      00:18 closed     opens 09:15              09:15–15:30      Asia/Kolkata                                                  Sensex
#> 12  Shanghai      02:48 closed     opens 09:30 09:30–11:30, 13:00–15:00     Asia/Shanghai                                      Shanghai Composite
#> 13 Hong Kong      02:48 closed     opens 09:30 09:30–12:00, 13:00–16:00    Asia/Hong_Kong                                               Hang Seng
#> 14     Seoul      03:48 closed     opens 09:00              09:00–15:30        Asia/Seoul                                                   KOSPI
#> 15     Tokyo      03:48 closed     opens 09:00 09:00–11:30, 12:30–15:30        Asia/Tokyo                                              Nikkei 225
#> 16    Sydney      05:48 closed     opens 10:00              10:00–16:00  Australia/Sydney                                                 ASX 200
# a Monday at 15:00 UTC: New York, London and the euro area are open
market_status(as.POSIXct("2026-11-09 15:00", tz = "UTC"))
#>     exchange local_time  state            text                    hours         time_zone                                                 indices
#> 1    Toronto      10:00   open    closes 16:00              09:30–16:00   America/Toronto                                       S&P/TSX Composite
#> 2   New York      10:00   open    closes 16:00              09:30–16:00  America/New_York S&P 500, Dow Jones, Nasdaq Composite, Russell 2000, VIX
#> 3  São Paulo      12:00   open    closes 18:00              10:00–18:00 America/Sao_Paulo                                                 Bovespa
#> 4     London      15:00   open    closes 16:30              08:00–16:30     Europe/London                                                FTSE 100
#> 5  Frankfurt      16:00   open    closes 17:30              09:00–17:30     Europe/Berlin                    DAX, Euro Stoxx 50, STOXX Europe 600
#> 6      Paris      16:00   open    closes 17:30              09:00–17:30      Europe/Paris                                                  CAC 40
#> 7     Madrid      16:00   open    closes 17:30              09:00–17:30     Europe/Madrid                                                 IBEX 35
#> 8      Milan      16:00   open    closes 17:30              09:00–17:30       Europe/Rome                                                FTSE MIB
#> 9     Zurich      16:00   open    closes 17:30              09:00–17:30     Europe/Zurich                                                     SMI
#> 10    Athens      17:00   open    closes 17:20              10:00–17:20     Europe/Athens                                          Athens General
#> 11    Mumbai      20:30 closed opens Tue 09:15              09:15–15:30      Asia/Kolkata                                                  Sensex
#> 12  Shanghai      23:00 closed opens Tue 09:30 09:30–11:30, 13:00–15:00     Asia/Shanghai                                      Shanghai Composite
#> 13 Hong Kong      23:00 closed opens Tue 09:30 09:30–12:00, 13:00–16:00    Asia/Hong_Kong                                               Hang Seng
#> 14     Seoul      00:00 closed     opens 09:00              09:00–15:30        Asia/Seoul                                                   KOSPI
#> 15     Tokyo      00:00 closed     opens 09:00 09:00–11:30, 12:30–15:30        Asia/Tokyo                                              Nikkei 225
#> 16    Sydney      02:00 closed     opens 10:00              10:00–16:00  Australia/Sydney                                                 ASX 200
```
