## Introduction and example data

The `rstanosl` package provides functions for fitting ALMM, CDM, MXDM3 and MXDM4 models to optical stimulated luminescence (OSL) data. The `rstanosl` package is built on top of the `rstan` package, which provides a high-level interface to the Stan probabilistic programming language. 

We start off by loading the necessary libraries. The `rstanosl` package contains the functions for fitting the OSL models. The `dplyr` package contains functions for manipulating data frames. The `ggplot2` package contains functions for plotting data. The `bayesplot` package contains functions for plotting MCMC chains.

```{r setup, message = FALSE, warning = FALSE}
library(rstanosl)
library(dplyr)
library(ggplot2)
library(bayesplot)
```

### Load and examine the example data

```{r}
data(osl_data)
```

Next we load the example data. The `data` function loads the example data into the global environment. The `osl_data` data frame contains 4085 observations with the following columns:

* `Depth` - depth of the sample in centimeters
* `De` - equivalent dose
* `rel.err` - standard error
* `dose_rate` - dose rate

For the purposes of this vignette we will only analyse the data from the three shallowest depth layers. We use the `filter` function from the `dplyr` package to select the data from the three shallowest depth layers. We save the filtered data to the `osl_data` variable.

```{r} 
osl_data <- osl_data %>% filter(Depth %in% c(46,47,48))
```

## Fitting single depth layers and visualising the results

The primary functions from `rstanosl` are designed to fit data gathered from a single depth layer at a time. The example data were sampled at three depth layers, 46, 47 and 48 centimeters. In this section will fit two different models (CDM and ALMM) to a the shallowest depth layer, 46 centimeters and then visualise the results.

```{r}
osl_data_46 <- osl_data %>% filter(Depth == 46)
```

### Fitting a single depth layer using the `cdm` function

Now we fit a CDM model to the data with the shallowest depth layer. We use the `cdm` function to do this. The `cdm` function takes a data frame as input, and returns a `stanfit` object. The `cdm` function accepts two main arguments, `logged` and `sigma`. The `logged` argument specifies whether the data are in natural units (i.e. not logged) or in logged units. In our case the data are logged. The `sigma` argument specifies the standard deviation of the measurement error. If `sigma` is NULL then the value of `sigma` is estimated during sampling. We pass the argument `refresh` set to 0 to `rstan` to supress updates about the progress of the MCMC chains for brevity in this vignette. 

```{r}
cdm_fit <- cdm(osl_data_46, logged = T, sigma = NULL, refresh = 0)
```


### Fitting and plotting a single depth layer using the `almm` function

Similar to the example above, we can now fit an ALMM model to the data with the shallowest depth layer. We use the `almm` function to do this. The `almm` function has identical syntax but uses a different underlying Stan model. The `rstanosl` package also includes stan models and corresponding functions for `mxdm3` and `mxdm4` which operate in a similar way.

```{r}
almm_fit <- almm(osl_data_46, logged = T, sigma = NULL, refresh = 0)
```

## Fitting and visualising multiple depth layers

### Fitting multiple layers using the `cdm` function

First we fit a CDM model to each depth layer in the data. We use the `cdm` function to do this. The `cdm` function takes a data frame as input, and returns a `stanfit` object. The `cdm` function accepts two main arguments, `logged` and `sigma`. The `logged` argument specifies whether the data are in natural units (i.e. not logged) or in logged units. The `sigma` argument specifies the standard deviation of the measurement error. If `sigma` is NULL then the value of `sigma` is estimate during sampling. To make the output complete quiet the `messages` argument is set to 'F'. If the `messages` argument is set to 'T' then the output will echo infomration about the data and sigma selections.   

The `cdm` function also accepts a number of other arguments, which are passed to the `stan` function. For example, the `refresh` argument specifies how often the progress of the MCMC chain is printed to the console. The `cores` argument specifies the number of cores to use for parallel processing. 

Using `dplyr` we can group the data by depth, and then apply the `cdm` function to each group. The `group_map` function from the `dplyr` package is used to apply the `cdm` function to each group. The `group_map` function returns a list of `stanfit` objects, one for each depth layer. We save this list to the `cdm_list` variable.

```{r}
cdm_list <- osl_data %>% group_by(Depth) %>% group_map(~ cdm(.x, logged = T, refresh = 0, messages = 0, cores = 4))
```

To create the `d0_draws` data frame we use the `lapply` function to apply the `as.data.frame` function to each element of the `cdm_list`. The `as.data.frame` function converts the `stanfit` object to a data frame. The `cbind` function then binds the data frames together into a single data frame. The `colnames` function is used to set the column names of the data frame to the depth values.

```{r}
d0_draws <- do.call(cbind, lapply(cdm_list, function(x) as.data.frame(x)$delta_0))
colnames(d0_draws) <- osl_data$Depth %>% unique()
```

### Plotting multiple depth layers using the `mcmc_intervals` function from the `bayesplot` package

We can now plot the `d0_draws` data frame using the `mcmc_intervals` function from the `bayesplot` package. The `mcmc_intervals` function takes a data frame as input, and returns a `ggplot` object. The `mcmc_intervals` function accepts a number of arguments, which are passed to the `ggplot` function. For example, the `xlab` argument specifies the x-axis label, and the `ylab` argument specifies the y-axis label. The `ggtitle` function is used to add a title and subtitle to the plot. The `theme_minimal` function is used to remove the background grid lines from the plot.

```{r}
mcmc_intervals(d0_draws) + 
  xlab("age (ka)") + 
  ylab("depth (cm)") + 
  ggtitle("Example OSL CDM plot", 
    subtitle = "Data are synthetic samples from three distinct depth layers") + 
  theme_minimal()
```
