# Convert the prices of indices to one currency

Each price, in the money of the shares of its index, is multiplied by
the rate of its day, the units of the new currency that a unit of that
money buys, worked out through the US dollar from the rates of Yahoo
Finance (see
[`currency_rates()`](https://sedzinfo.github.io/golemstockindices/reference/currency_rates.md)):
a price in yen, for example, becomes
`price × (euros per dollar) / (yen per dollar)` euros. A day without a
rate of its own takes the last rate of the week before it; the days
without one, as before the rates start, between 1996 and 2006 depending
on the currency, are left out. The volume, the VIX, which is not in the
money of any shares, and the indices already in the currency are left as
they are. The daily rates are not taken at the close of each exchange,
so the change of a single day mixes in a few hours of the moves of the
currency; over weeks and months this matters little.

## Usage

``` r
convert_prices(
  history,
  to = c("local", "USD", "EUR"),
  indices = get_indices(),
  rates = NULL
)
```

## Arguments

- history:

  Price history from
  [`get_history()`](https://sedzinfo.github.io/golemstockindices/reference/get_history.md).

- to:

  `"local"` to leave every index in the money of its shares, `"USD"` for
  US dollars or `"EUR"` for euros.

- indices:

  Data frame of indices from
  [`get_indices()`](https://sedzinfo.github.io/golemstockindices/reference/get_indices.md),
  for the currency of each.

- rates:

  Exchange rates from
  [`currency_rates()`](https://sedzinfo.github.io/golemstockindices/reference/currency_rates.md),
  downloaded when `NULL`.

## Value

`history`, with `open`, `high`, `low` and `close` in the currency,
without the days that have no rate.

## Examples

``` r
history <- data.frame(
  label = "Nikkei 225", timestamp = as.Date(c("2024-01-04", "2024-01-05")),
  open = 33000, high = 33500, low = 32800, close = c(33288, 33377), volume = 0
)
rates <- data.frame(
  currency = c("JPY", "JPY", "EUR", "EUR"),
  timestamp = as.Date(c("2024-01-04", "2024-01-05", "2024-01-04", "2024-01-05")),
  per_usd = c(144.6, 144.6, 0.913, 0.915)
)
convert_prices(history, "USD", rates = rates)
#>        label  timestamp     open     high      low    close volume
#> 1 Nikkei 225 2024-01-04 228.2158 231.6736 226.8326 230.2075      0
#> 2 Nikkei 225 2024-01-05 228.2158 231.6736 226.8326 230.8230      0
convert_prices(history, "EUR", rates = rates)
#>        label  timestamp     open     high      low    close volume
#> 1 Nikkei 225 2024-01-04 208.3610 211.5180 207.0982 210.1794      0
#> 2 Nikkei 225 2024-01-05 208.8174 211.9813 207.5519 211.2030      0
if (FALSE) { # interactive()
# the S&P 500 and the DAX in euros, each starting at 100
euros <- convert_prices(get_history(c("S&P 500", "DAX")), "EUR")
plot_compare(normalize_prices(euros), currency = "EUR")
}
```
