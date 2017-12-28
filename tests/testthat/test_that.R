#testing that function make_filename(year) produces a file name with the year as part of it
library(testthat)
expect_that(make_filename(2013), matches("accident_2013.csv.bz2"))
