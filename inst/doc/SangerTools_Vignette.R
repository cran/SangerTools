## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.height= 5, 
  fig.width=7
)

## ----setup, echo=FALSE, include=FALSE-----------------------------------------
library(SangerTools)
library(dplyr)
library(ggplot2)
library(scales)

## ----load_data----------------------------------------------------------------
health_data <- SangerTools::PopHealthData
glimpse(health_data)

## ----categorical_column_chart-------------------------------------------------
# Group by Ethnicity
health_data %>% 
  dplyr::filter(Diabetes==1) %>% 
  SangerTools::categorical_col_chart(., Ethnicity)

# Group by Age Band
health_data %>% 
  dplyr::filter(Smoker==1) %>% 
  SangerTools::categorical_col_chart(AgeBand) + labs(x="Ethnicity", y="Patient Number")

# Group by Sex
health_data %>% 
  dplyr::filter(Diabetes==1) %>% 
  SangerTools::categorical_col_chart(Sex) + labs(x="Gender")

## ----crude_prev---------------------------------------------------------------
crude_prevalence <- SangerTools::crude_pr(health_data, health_data %>% dplyr::filter(Diabetes==1), Locality)
# Another way
print(crude_prevalence)


## ----copy_to_clipboard--------------------------------------------------------
#health_data %>%
 # slice(1:10) %>%
  #SangerTools::excel_clip(row.names = FALSE, col.names = TRUE) #Include column names


## ----multiple_csv_reader------------------------------------------------------
file_path = 'my_file_path_where_csvs_are_stored'

if (length(SangerTools::multiple_csv_reader(file_path))==0){
  message("This won't work without changing the variable input to a local file path with CSVs in")
}




## ----show_brand_palette-------------------------------------------------------

show_brand_palette()

## -----------------------------------------------------------------------------
show_extended_palette()

