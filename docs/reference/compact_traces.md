# Send a long chart to the browser in less data

plotly repeats a hover template or text that is the same for every point
once per point, and keeps the attributes the chart was built from, a
second copy of its data. For the 25,000 days of the S&P 500 that adds
megabytes to the page and seconds to the drawing. The chart is built,
each such hover attribute keeps its one value once, and the second copy
is dropped.

## Usage

``` r
compact_traces(p)
```

## Arguments

- p:

  A plotly object.

## Value

The built plotly object.

## Examples

``` r
p <- plotly::plot_ly(x = 1:3, y = 1:3, type = "scatter", mode = "lines", hovertemplate = "%{y}")
golemstockindices:::compact_traces(p)$x$data[[1]]$hovertemplate
#> [1] "%{y}"
```
