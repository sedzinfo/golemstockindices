##########################################################################################
#
##########################################################################################
# Launch the ShinyApp (Do not remove this comment)
# To deploy, run: rsconnect::deployApp()

pkgload::load_all(export_all = FALSE, helpers = FALSE, attach_testthat = FALSE)
options(stockindices.cache_dir = file.path(tempdir(), "stockindices-cache"))
run_app(analytics = TRUE, keep_alive = FALSE)

# rsconnect::writeManifest(appDir = ".", appPrimaryDoc = "app.R")
