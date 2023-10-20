


<img src="man/figures/logo.png" alt="rstanosl Hex Sticker" width="200" align="right"/>

# rstanosl

`rstanosl` is an R package for fitting Optical Stimulated Luminescence (OSL) models using Stan.

## Installation

You can install the development version of `rstanosl` from GitHub with:


```r
devtools::install_github("zaandahl/rstanosl")
```

If you want you can also install the package with a vignette. You need to install `bayesplot` prior to building the vignette. This will take a few minutes to create:


```r
devtools::install_github("zaandahl/rstanosl", build_vignettes = TRUE)
```

## Getting Started

Load the package:


```r
library(rstanosl)
```

Load the example data:


```r
library(rstanosl)
```

Fit a ALMM model to a single depth layer of the data:


```r
osl_data_46 <- osl_data %>% filter(Depth == 46)
almm_fit <- almm(osl_data_46, logged = T, sigma = NULL, refresh = 0)
```

## Further Resources

- [Getting Started with rstanosl Vignette](https://github.com/zaandahl/rstanosl/blob/main/vignettes/getting-started-with-rstanosl.md): A step-by-step guide to using the rstanosl package with example data.
- [Stan documentation](https://mc-stan.org/users/documentation/): Learn more about Stan, a probabilistic programming language for statistical modeling.

## Building this package with `devtools` README and vignette

You can build this package from a Docker container that runs RStudio Server with the following commands:


```bash
docker compose build
docker compose up
```

Then, open a web browser and navigate to http://localhost:8787. Log in with username `rstudio` and password `rstudio`. Then, run the following commands in the RStudio console:


```r
setwd("./package")
source("inst/logo/logo.R")
knitr::knit("README.Rmd", "README.md")
devtools::document()
devtools::build()
devtools::install(build_vignettes = TRUE)
```

After you have finished building the package you can load in RStudio and save it as a tarball:


```r
library(rstanosl)
save.image()
```

Then, you can exit the Docker container by pressing `Ctrl+C` in the terminal window where you ran `docker compose up`. Finally, you can remove the Docker container with the following command:


```bash
docker compose down
```


## License

BSD-3-Clause License (see LICENSE file)
