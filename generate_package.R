##########################################################################################
# DIRECTORIES
##########################################################################################
# R CMD check golemstockindices
# R CMD Rd2pdf golemstockindices
# R CMD build golemstockindices --resave-data
library(devtools)
library(roxygen2)
rm(list = ls())
graphics.off()
cat("\014")
##########################################################################################
# FUNCTIONS PACKAGE
##########################################################################################
directory <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(directory)
document()
if ("golemstockindices" %in% loadedNamespaces()) unloadNamespace("golemstockindices")
if ("golemstockindices" %in% rownames(installed.packages())) remove.packages("golemstockindices")
install()
library(golemstockindices)

pkgdown::build_site(getwd(), lazy = TRUE)
system("R CMD Rd2pdf . --force --no-preview --output=golemstockindices.pdf")
if (.Platform$OS.type == "windows") shell.exec("golemstockindices.pdf") else system("evince golemstockindices.pdf")
system("R CMD build . --resave-data")
rsconnect::writeManifest(appDir = ".", appPrimaryDoc = "app.R")

golemstockindices::run_app()



