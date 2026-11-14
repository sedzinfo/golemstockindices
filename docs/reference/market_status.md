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
#>        exchange local_time  state            text                    hours           time_zone                                                                             indices
#> 1   Mexico City      07:15 closed opens Mon 08:30              08:30–15:00 America/Mexico_City                                                                          IPC Mexico
#> 2       Toronto      08:15 closed opens Mon 09:30              09:30–16:00     America/Toronto                                                                   S&P/TSX Composite
#> 3      New York      08:15 closed opens Mon 09:30              09:30–16:00    America/New_York S&P 500, Dow Jones, Nasdaq Composite, Nasdaq-100, NYSE Composite, Russell 2000, VIX
#> 4     São Paulo      10:15 closed opens Mon 10:00              10:00–18:00   America/Sao_Paulo                                                                             Bovespa
#> 5        Lisbon      13:15 closed opens Mon 08:00              08:00–16:30       Europe/Lisbon                                                                                 PSI
#> 6        Dublin      13:15 closed opens Mon 08:00              08:00–16:30       Europe/Dublin                                                                      ISEQ All Share
#> 7        London      13:15 closed opens Mon 08:00              08:00–16:30       Europe/London                                                  FTSE 100, FTSE 250, FTSE All-Share
#> 8     Frankfurt      14:15 closed opens Mon 09:00              09:00–17:30       Europe/Berlin                            DAX, MDAX, SDAX, TecDAX, Euro Stoxx 50, STOXX Europe 600
#> 9         Paris      14:15 closed opens Mon 09:00              09:00–17:30        Europe/Paris                                                      CAC 40, Euronext 100, Next 150
#> 10     Brussels      14:15 closed opens Mon 09:00              09:00–17:30     Europe/Brussels                                                                              BEL 20
#> 11    Amsterdam      14:15 closed opens Mon 09:00              09:00–17:30    Europe/Amsterdam                                                                                 AEX
#> 12       Madrid      14:15 closed opens Mon 09:00              09:00–17:30       Europe/Madrid                                                                             IBEX 35
#> 13        Milan      14:15 closed opens Mon 09:00              09:00–17:30         Europe/Rome                                                                            FTSE MIB
#> 14       Zurich      14:15 closed opens Mon 09:00              09:00–17:30       Europe/Zurich                                                                                 SMI
#> 15         Oslo      14:15 closed opens Mon 09:00              09:00–16:20         Europe/Oslo                                                                               OSEBX
#> 16   Copenhagen      14:15 closed opens Mon 09:00              09:00–17:00   Europe/Copenhagen                                                                   OMX Copenhagen 25
#> 17       Vienna      14:15 closed opens Mon 09:00              09:00–17:30       Europe/Vienna                                                                                 ATX
#> 18    Stockholm      14:15 closed opens Mon 09:00              09:00–17:30    Europe/Stockholm                                                                    OMX Stockholm 30
#> 19      Baltics      15:15 closed opens Mon 10:00              10:00–16:00         Europe/Riga                                                  OMX Tallinn, OMX Riga, OMX Vilnius
#> 20     Helsinki      15:15 closed opens Mon 10:00              10:00–18:30     Europe/Helsinki                                                                     OMX Helsinki 25
#> 21       Athens      15:15 closed opens Mon 10:00              10:00–17:20       Europe/Athens                                                                      Athens General
#> 22 Johannesburg      15:15 closed opens Mon 09:00              09:00–17:00 Africa/Johannesburg                                                                     FTSE/JSE Top 40
#> 23     Istanbul      16:15 closed opens Mon 10:00              10:00–18:00     Europe/Istanbul                                                                            BIST 100
#> 24       Mumbai      18:45 closed opens Mon 09:15              09:15–15:30        Asia/Kolkata                                                                              Sensex
#> 25      Jakarta      20:15 closed opens Mon 09:00 09:00–12:00, 13:30–15:50        Asia/Jakarta                                                                       IDX Composite
#> 26 Kuala Lumpur      21:15 closed opens Mon 09:00 09:00–12:30, 14:30–17:00   Asia/Kuala_Lumpur                                                            FTSE Bursa Malaysia KLCI
#> 27    Singapore      21:15 closed opens Mon 09:00              09:00–17:00      Asia/Singapore                                                                       Straits Times
#> 28     Shanghai      21:15 closed opens Mon 09:30 09:30–11:30, 13:00–15:00       Asia/Shanghai                                                                  Shanghai Composite
#> 29     Shenzhen      21:15 closed opens Mon 09:30 09:30–11:30, 13:00–15:00       Asia/Shanghai                                                                  Shenzhen Component
#> 30    Hong Kong      21:15 closed opens Mon 09:30 09:30–12:00, 13:00–16:00      Asia/Hong_Kong                                              Hang Seng, Hang Seng China Enterprises
#> 31       Taipei      21:15 closed opens Mon 09:00              09:00–13:30         Asia/Taipei                                                                     Taiwan Weighted
#> 32        Seoul      22:15 closed opens Mon 09:00              09:00–15:30          Asia/Seoul                                                                       KOSPI, KOSDAQ
#> 33        Tokyo      22:15 closed opens Mon 09:00 09:00–11:30, 12:30–15:30          Asia/Tokyo                                                                          Nikkei 225
#> 34       Sydney      00:15 closed opens Mon 10:00              10:00–16:00    Australia/Sydney                                                             ASX 200, All Ordinaries
#> 35   Wellington      02:15 closed opens Mon 10:00              10:00–16:45    Pacific/Auckland                                                                              NZX 50
# a Monday at 15:00 UTC: New York, London and the euro area are open
market_status(as.POSIXct("2026-11-09 15:00", tz = "UTC"))
#>        exchange local_time  state            text                    hours           time_zone                                                                             indices
#> 1   Mexico City      09:00   open    closes 15:00              08:30–15:00 America/Mexico_City                                                                          IPC Mexico
#> 2       Toronto      10:00   open    closes 16:00              09:30–16:00     America/Toronto                                                                   S&P/TSX Composite
#> 3      New York      10:00   open    closes 16:00              09:30–16:00    America/New_York S&P 500, Dow Jones, Nasdaq Composite, Nasdaq-100, NYSE Composite, Russell 2000, VIX
#> 4     São Paulo      12:00   open    closes 18:00              10:00–18:00   America/Sao_Paulo                                                                             Bovespa
#> 5        Lisbon      15:00   open    closes 16:30              08:00–16:30       Europe/Lisbon                                                                                 PSI
#> 6        Dublin      15:00   open    closes 16:30              08:00–16:30       Europe/Dublin                                                                      ISEQ All Share
#> 7        London      15:00   open    closes 16:30              08:00–16:30       Europe/London                                                  FTSE 100, FTSE 250, FTSE All-Share
#> 8     Frankfurt      16:00   open    closes 17:30              09:00–17:30       Europe/Berlin                            DAX, MDAX, SDAX, TecDAX, Euro Stoxx 50, STOXX Europe 600
#> 9         Paris      16:00   open    closes 17:30              09:00–17:30        Europe/Paris                                                      CAC 40, Euronext 100, Next 150
#> 10     Brussels      16:00   open    closes 17:30              09:00–17:30     Europe/Brussels                                                                              BEL 20
#> 11    Amsterdam      16:00   open    closes 17:30              09:00–17:30    Europe/Amsterdam                                                                                 AEX
#> 12       Madrid      16:00   open    closes 17:30              09:00–17:30       Europe/Madrid                                                                             IBEX 35
#> 13        Milan      16:00   open    closes 17:30              09:00–17:30         Europe/Rome                                                                            FTSE MIB
#> 14       Zurich      16:00   open    closes 17:30              09:00–17:30       Europe/Zurich                                                                                 SMI
#> 15         Oslo      16:00   open    closes 16:20              09:00–16:20         Europe/Oslo                                                                               OSEBX
#> 16   Copenhagen      16:00   open    closes 17:00              09:00–17:00   Europe/Copenhagen                                                                   OMX Copenhagen 25
#> 17       Vienna      16:00   open    closes 17:30              09:00–17:30       Europe/Vienna                                                                                 ATX
#> 18    Stockholm      16:00   open    closes 17:30              09:00–17:30    Europe/Stockholm                                                                    OMX Stockholm 30
#> 19      Baltics      17:00 closed opens Tue 10:00              10:00–16:00         Europe/Riga                                                  OMX Tallinn, OMX Riga, OMX Vilnius
#> 20     Helsinki      17:00   open    closes 18:30              10:00–18:30     Europe/Helsinki                                                                     OMX Helsinki 25
#> 21       Athens      17:00   open    closes 17:20              10:00–17:20       Europe/Athens                                                                      Athens General
#> 22 Johannesburg      17:00 closed opens Tue 09:00              09:00–17:00 Africa/Johannesburg                                                                     FTSE/JSE Top 40
#> 23     Istanbul      18:00 closed opens Tue 10:00              10:00–18:00     Europe/Istanbul                                                                            BIST 100
#> 24       Mumbai      20:30 closed opens Tue 09:15              09:15–15:30        Asia/Kolkata                                                                              Sensex
#> 25      Jakarta      22:00 closed opens Tue 09:00 09:00–12:00, 13:30–15:50        Asia/Jakarta                                                                       IDX Composite
#> 26 Kuala Lumpur      23:00 closed opens Tue 09:00 09:00–12:30, 14:30–17:00   Asia/Kuala_Lumpur                                                            FTSE Bursa Malaysia KLCI
#> 27    Singapore      23:00 closed opens Tue 09:00              09:00–17:00      Asia/Singapore                                                                       Straits Times
#> 28     Shanghai      23:00 closed opens Tue 09:30 09:30–11:30, 13:00–15:00       Asia/Shanghai                                                                  Shanghai Composite
#> 29     Shenzhen      23:00 closed opens Tue 09:30 09:30–11:30, 13:00–15:00       Asia/Shanghai                                                                  Shenzhen Component
#> 30    Hong Kong      23:00 closed opens Tue 09:30 09:30–12:00, 13:00–16:00      Asia/Hong_Kong                                              Hang Seng, Hang Seng China Enterprises
#> 31       Taipei      23:00 closed opens Tue 09:00              09:00–13:30         Asia/Taipei                                                                     Taiwan Weighted
#> 32        Seoul      00:00 closed     opens 09:00              09:00–15:30          Asia/Seoul                                                                       KOSPI, KOSDAQ
#> 33        Tokyo      00:00 closed     opens 09:00 09:00–11:30, 12:30–15:30          Asia/Tokyo                                                                          Nikkei 225
#> 34       Sydney      02:00 closed     opens 10:00              10:00–16:00    Australia/Sydney                                                             ASX 200, All Ordinaries
#> 35   Wellington      04:00 closed     opens 10:00              10:00–16:45    Pacific/Auckland                                                                              NZX 50
```
