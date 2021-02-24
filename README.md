## Deployment of a `targets` pipeline to RStudio Connect

### Setup

You have to set your environment variables in the environment. If you are developing locally you do this by executing:

```r
Sys.setenv("AWS_ACCESS_KEY_ID" = "XXXXX")
Sys.setenv("AWS_SECRET_ACCESS_KEY" = "XXXXX")
Sys.setenv("AWS_DEFAULT_REGION" = "XXXXX")
Sys.setenv("AWS_BUCKET_NAME" = "XXXXX")
Sys.setenv("CONNECT_SERVER" = "XXXXX")
Sys.setenv("CONNECT_API_KEY" = "XXXXX")
```

Then you need to install the `renv` package and restore the snapshot so that you have all of the packages you need available. 

```r
install.packages("renv")
renv::restore()
```

If you are publishing the pipeline to RStudio Connect, you first have to deploy the content. Once available in RStudio Connect (the first deployment **will** fail), you have to go to the Variables tab within the content and set all of the above variables. Once all of the variables are set 

### Running the pipeline

The `driver.Rmd` file drives the whole infrastructure build. One you knit that document the pipeline gets built. This file will generate an HTML report that is uploaded to RStudio Connect.


### Architecture & Files

- `driver.Rmd` executes the pipeline and acts as the parent environment
- `_targets.R` lays down the pipeline and the settings for it
- `report/report.Rmd` contains the report that will be published to RStudio Connect
- `R/connect_helpers.R` hosts the function to publish content to RStudio Connect
