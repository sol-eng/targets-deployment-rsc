## Deployment of a `targets` pipeline to RStudio Connect

### Setup

You have to set your environment variables in the environment. If you are developing locally you do this by executing:

```r
Sys.setenv("CONNECT_SERVER" = "XXXXX")
Sys.setenv("CONNECT_API_KEY" = "XXXXX")
```

Then you need to install the `renv` package and restore the snapshot so that you have all of the packages you need available. 

```r
install.packages("renv")
renv::restore()
```

When you are publishing the pipeline to RStudio Connect, you deploy the content and the necessary environment variables will be in the environment without any human intervention. 

### Running the pipeline

The `driver.Rmd` file drives the whole infrastructure build. One you knit that document the pipeline gets built. This file will generate an HTML report that is uploaded to RStudio Connect.


### Architecture & Files

- `driver.Rmd` executes the pipeline and acts as the parent environment
- `_targets.R` lays down the pipeline and the settings for it
- `report/report.Rmd` contains the report that will be published to RStudio Connect
- `R/connect_helpers.R` hosts the function to publish content to RStudio Connect
- `config.yml` specifies where to store the cache
