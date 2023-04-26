---
output:
  github_document:
    html_preview: false
---



![rstanosl logo](man/figures/logo.png)

# rstanosl

`rstanosl` is an R package for fitting Optical Stimulated Luminescence (OSL) models using Stan.

## Installation

You can install the development version of `rstanosl` from GitHub with:


```r
devtools::install_github("zaandahl/rstanosl")
```

If you want you can also install the package with a vignette. This will take a few minutes to create:


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

Provide some examples of how to use your package with the example data, including any relevant functions and their parameters.

## Further Resources

- [Getting Started with rstanosl Vignette](link-to-vignette): A step-by-step guide to using the rstanosl package with example data.
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

Your package license information (e.g., MIT, GPL-3, etc.)
