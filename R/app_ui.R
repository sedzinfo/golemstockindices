##########################################################################################
# 
##########################################################################################
#' @title The application user interface
#' @description A navbar page with one tab per module, a light/dark mode toggle
#' and, with `keep_alive`, a hidden output that answers the keep-alive pings.
#' @param indices Data frame of indices from `get_indices()`, for the index
#'   pickers.
#' @param analytics `TRUE` to add Google Analytics and its cookie banner,
#'   see `analytics_resources()`.
#' @param keep_alive `TRUE` to ping the server every 15 seconds while the
#'   page is open, so that proxies do not close idle connections.
#' @return A `tagList` with the whole page.
#' @noRd
#' @examples
#' \dontrun{
#' indices <- get_indices()
#' shiny::shinyApp(ui = app_ui(indices), server = app_server(indices))
#' }
app_ui <- function(indices, analytics = FALSE, keep_alive = TRUE) {
  app_name <- "Stock Market Indices"
  tagList(
    add_external_resources(analytics, keep_alive),
    bslib::page_navbar(
      title = app_name,
      window_title = app_name,
      theme = bslib::bs_theme(version = 5, primary = "#0E7490"),
      # keep the fixed plot heights instead of squeezing the plots to the window
      fillable = FALSE,
      footer = if (analytics) analytics_footer(),
      tabPanel("Overview", mod_overview_ui("overview")),
      tabPanel("Performance", mod_performance_ui("performance")),
      tabPanel("Timeseries", mod_timeseries_ui("timeseries", indices)),
      tabPanel("Compare", mod_compare_ui("compare", indices)),
      tabPanel("Returns calendar", mod_returns_calendar_ui("returns_calendar")),
      tabPanel("Seasonality", mod_seasonality_ui("seasonality")),
      tabPanel("Volatility", mod_volatility_ui("volatility")),
      tabPanel("Drawdowns", mod_drawdowns_ui("drawdowns")),
      tabPanel("About", mod_about_ui("about")),
      bslib::nav_spacer(),
      bslib::nav_item(bslib::input_dark_mode(id = "dark_mode"))
    ),
    # rendering this output makes the server answer the keep-alive pings
    if (keep_alive) div(style = "display:none", textOutput("keep_alive"))
  )
}
##########################################################################################
# 
##########################################################################################
#' @title Where the app lives, and how it describes itself to search engines and link previews
#' @description The address of the live app, a sentence of at most 160
#' characters for the description and Open Graph tags of the page, and the
#' screenshot of the Overview tab on GitHub for the preview image.
#' @noRd
app_url <- "https://sedzinfo-golemstockindices.share.connect.posit.cloud/"
#' @noRd
app_description <- paste(
  "Follow the major stock market indices of the Americas, Europe and Asia-Pacific:",
  "where each stands, its history, seasonality, volatility and falls."
)
#' @noRd
app_image <- "https://raw.githubusercontent.com/sedzinfo/golemstockindices/main/screenshots/stock1.png"
##########################################################################################
# 
##########################################################################################
#' @title Add external resources to the application
#' @description Serves `inst/app/www` under the `www/` path and adds the
#' description and Open Graph tags of the page, the favicon and the
#' stylesheet to its head, and the keep-alive
#' script and Google Analytics when asked for.
#' @param analytics `TRUE` to add Google Analytics and its cookie banner.
#' @param keep_alive `TRUE` to add the script that pings the server every 15
#'   seconds.
#' @return A `tags$head()` tag.
#' @noRd
#' @examples
#' \dontrun{
#' # called from inside app_ui():
#' shiny::tagList(add_external_resources(), bslib::page_navbar())
#' }
add_external_resources <- function(analytics = FALSE, keep_alive = TRUE) {
  addResourcePath("www", app_sys("app/www"))
  tags$head(
    tags$meta(name = "description", content = app_description),
    tags$meta(property = "og:type", content = "website"),
    tags$meta(property = "og:site_name", content = "sedzinfo"),
    tags$meta(property = "og:title", content = "Stock Market Indices"),
    tags$meta(property = "og:description", content = app_description),
    tags$meta(property = "og:url", content = app_url),
    tags$meta(property = "og:image", content = app_image),
    tags$meta(name = "twitter:card", content = "summary_large_image"),
    tags$link(rel = "icon", type = "image/svg+xml", href = "www/favicon.svg"),
    shared_css(),
    tags$link(rel = "stylesheet", href = "www/styles.css"),
    # on a phone the tabs are in a menu behind the navbar toggle, which Bootstrap leaves open after
    # a tab is picked, covering the tab: close it when a tab link in it is clicked
    # (on wider screens the tabs are not in an opened menu, and nothing happens)
    tags$script(HTML(
      "document.addEventListener('click', function (e) {
        var menu = document.querySelector('.navbar-collapse.show');
        if (menu && e.target.closest('.navbar-collapse a[data-bs-toggle=\"tab\"]'))
          bootstrap.Collapse.getOrCreateInstance(menu).hide();
      });"
    )),
    if (keep_alive) tags$script(src = paste0(shared_url, "keep_alive.js")),
    if (analytics) analytics_resources()
  )
}
