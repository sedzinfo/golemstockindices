# Turn a label into a file name stem

Lower case, with every run of characters other than letters and digits
replaced by a hyphen, so that "S&P 500" becomes "s-p-500".

## Usage

``` r
file_stem(label)
```

## Arguments

- label:

  Character string, such as an index label.

## Value

A character string that can be used in a file name.

## Examples

``` r
golemstockindices:::file_stem("S&P 500")
#> [1] "s-p-500"
```
