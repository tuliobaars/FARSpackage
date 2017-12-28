[![Travis-CI Build Status](https://travis-ci.org/tuliobaars/FARSpackage.svg?branch=master)](https://travis-ci.org/tuliobaars/FARSpackage)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/tuliobaars/FARSpackage?branch=master&svg=true)](https://ci.appveyor.com/project/tuliobaars/FARSpackage)



# FARSpackage
Graphs on a map of the USA accidents by State uses data from US National Highway Traffic Safety Administration

This package can be installed using the devtools package as follows:

```{r, eval = FALSE}
library(devtools)
install_github("tuliobaars/FARSpackage")
```

# Usage of the FARSpackage

This package is intended to graph information from from the US National Highway Traffic Safety Administration's Fatality Analysis Reporting System, which is a nationwide census providing the American public yearly data regarding fatal injuries suffered in motor vehicle traffic crashes.  This package shows fatalities by state.

Data can be downloaded from [https://www.nhtsa.gov/research-data/fatality-analysis-reporting-system-fars].

One way to use this package is to save your downloaded files into your working directory as follows:

```{r, eval = FALSE}
setwd("file path here")
```

There are two main formulas in this package:

-  fars_summarize_years(year)
-  fars_map_state(state, year)

The first formula summarizes fatalities by year and month.  The second formula displays fatalities in a map, depending of the state and year selected.  The following code will map fatalities for a selected year and for selected states.

```{r, eval= FALSE}
fars_map_state(state, year)
```
