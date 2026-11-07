# Shades of a table column, around a middle

5 shades of red below the middle and 5 of green above it, up to the
largest distance from it, and no color near it, for
[`DT::formatStyle()`](https://rdrr.io/pkg/DT/man/formatCurrency.html).

## Usage

``` r
shade_interval(values, middle)
```

## Arguments

- values:

  The numbers of the column, or of the columns that share the scale.

- middle:

  The value that gets no color, such as 0 for changes or 50 for a share
  in percent.

## Value

The JavaScript of
[`DT::styleInterval()`](https://rdrr.io/pkg/DT/man/styleInterval.html).

## Examples

``` r
golemstockindices:::shade_interval(c(-3, 1, 2.5), 0)
#> [1] "isNaN(parseFloat(value)) ? '' : value <= -2.7 ? \"rgba(220,53,69,0.750)\" : value <= -2.1 ? \"rgba(220,53,69,0.600)\" : value <= -1.5 ? \"rgba(220,53,69,0.450)\" : value <= -0.9 ? \"rgba(220,53,69,0.300)\" : value <= -0.3 ? \"rgba(220,53,69,0.150)\" : value <= 0.3 ? \"rgba(25,135,84,0.000)\" : value <= 0.9 ? \"rgba(25,135,84,0.150)\" : value <= 1.5 ? \"rgba(25,135,84,0.300)\" : value <= 2.1 ? \"rgba(25,135,84,0.450)\" : value <= 2.7 ? \"rgba(25,135,84,0.600)\" : \"rgba(25,135,84,0.750)\""
#> attr(,"class")
#> [1] "JS_EVAL"
```
