# otolithr
[![Travis build status](https://travis-ci.org/kikirinrin/otolithr.svg?branch=master)](https://travis-ci.org/kikirinrin/otolithr)
[![codecov](https://codecov.io/gh/kikirinrin/otolithr/branch/master/graph/badge.svg)](https://codecov.io/gh/kikirinrin/otolithr)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

```
# install.packages("devtools")
devtools::install_github("akikirinrin/otolithr")
library(otolithr)

path <- "YOUR_PATH_TO_HDR_FILES"
dat  <- hdr2df_in_dir(path, species = "maiwashi")
plot(dat)
```
