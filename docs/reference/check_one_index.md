# Stop when a price history holds more than one index

For the functions that work on one index at a time, so that a history of
several indices gives a clear error instead of a wrong result.

## Usage

``` r
check_one_index(history)
```

## Arguments

- history:

  Price history from
  [`get_history()`](https://sedzinfo.github.io/golemstockindices/reference/get_history.md).

## Value

`history`, invisibly, when it holds at most one index.

## Examples

``` r
history <- data.frame(label = c("Alpha (A)", "Beta (B)"))
try(golemstockindices:::check_one_index(history))
#> Error : history holds 2 indices, keep one of them first, for example history[history$label == "Alpha (A)", ]
```
