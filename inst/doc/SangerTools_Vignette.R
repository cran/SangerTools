## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.height = 5, 
  fig.width = 8
)

## ----setup, echo=FALSE, include=FALSE-----------------------------------------
library(SangerTools)
library(dplyr)
library(ggplot2)
library(scales)
library(kableExtra)

## ----load_data----------------------------------------------------------------

health_data <- SangerTools::master_patient_index


## ----load_data_print, echo = FALSE--------------------------------------------
health_data %>% 
  head() %>% 
  kableExtra::kbl() %>%
  kableExtra::kable_styling(bootstrap_options = c("striped",
                                      "hover",
                                      "condensed",
                                      "responsive"))

## ----agebands-----------------------------------------------------------------
health_data <- SangerTools::age_bandizer(df = health_data,
                                         Age_col = Age)

health_data <- SangerTools::age_bandizer_2(df = health_data,
                                           Age_col = "Age",
                                           Age_band_size = 5)

## ----agebands_print, echo = FALSE---------------------------------------------
health_data %>% 
  select(Age,Ageband) %>%
  head() %>% 
  kableExtra::kbl() %>%
  kableExtra::kable_styling(bootstrap_options = c("striped", 
                                      "hover", 
                                      "condensed", 
                                      "responsive"))

## ----categorical_column_chart-------------------------------------------------
# Group by Ethnicity
diabetes_df <- health_data %>% 
  dplyr::filter(Diabetes==1)
  
  SangerTools::categorical_col_chart(df = diabetes_df,
                                     grouping_var = Ethnicity)+
  scale_fill_sanger()+ 
  labs(title = "Diabetic Patients by Ethnicity",
       subtitle = "Nearly All Diabetics are White",
       x = NULL, 
       y = "Number of Patients") + 
  coord_flip() 

# Group by Sex
health_data %>% 
  dplyr::filter(Diabetes==1) %>% 
  SangerTools::categorical_col_chart(Sex) + 
  scale_fill_sanger()+
  labs(title = "Diabetic Patients by Gender",
       x = NULL, 
       y = "Number of Patients")  

## ----crude_rates--------------------------------------------------------------
 crude_prevalence <- SangerTools::crude_rates(df = health_data,
                                              Condition =  Diabetes, 
                                              Locality)

## ----crude_rates_print, echo=FALSE--------------------------------------------
  kableExtra::kbl(crude_prevalence) %>%
  kableExtra::kable_styling(bootstrap_options = c("striped", 
                                      "hover", 
                                      "condensed", 
                                      "responsive"))


## ----ASR----------------------------------------------------------------------

asr_prevalence <- SangerTools::standardised_rates_df(df = health_data,
                                   Split_by = Locality,
                                   Condition = Diabetes, 
                                   Population_Standard = NULL,
                                   Granular = FALSE,
                                   Ageband )

## ----asr_print,echo=FALSE-----------------------------------------------------

  kableExtra::kbl(asr_prevalence) %>%
  kableExtra::kable_styling(bootstrap_options = c("striped", 
                                      "hover", 
                                      "condensed", 
                                      "responsive"))


## ----UK_pop-------------------------------------------------------------------

uk_pop18<- SangerTools::uk_pop_standard

names(uk_pop18) <- c("Pop_Weight","Ageband")


## ----UK_pop_print,echo = FALSE------------------------------------------------
uk_pop18 %>% 
  head() %>% 
  kableExtra::kbl(format.args = list(big.mark = ",")) %>%
  kableExtra::kable_styling(bootstrap_options = c("striped", 
                                      "hover", 
                                      "condensed", 
                                      "responsive"))


## ----ASR2---------------------------------------------------------------------
asr_uk <- SangerTools::standardised_rates_df(df = health_data,
                                   Split_by = Locality,
                                   Condition = Diabetes, 
                                   Population_Standard = uk_pop18,
                                   Granular = FALSE,
                                   Ageband )

## ----ASR2_print,echo = FALSE--------------------------------------------------
asr_uk %>% 
  kableExtra::kbl() %>%
  kableExtra::kable_styling(bootstrap_options = c("striped", 
                                      "hover", 
                                      "condensed", 
                                      "responsive"))

## ----combined_rates-----------------------------------------------------------
combined_rates <- crude_prevalence %>% 
  dplyr::left_join(asr_prevalence, by = c("Locality"))



## ----combined_rates_print, echo=FALSE-----------------------------------------
combined_rates %>% 
  kableExtra::kbl() %>%
  kableExtra::kable_styling(bootstrap_options = c("striped", 
                                      "hover", 
                                      "condensed", 
                                      "responsive"))


## ----copy_to_clipboard,eval=FALSE---------------------------------------------
#  
#  SangerTools::excel_clip(combined_rates)
#  

## ----multiple_csv_reader------------------------------------------------------
file_path = 'my_file_path_where_csvs_are_stored'

if (length(SangerTools::multiple_csv_reader(file_path))==0){
  message("This won't work without changing the variable input to a local file path with CSVs in")
}

## ----split_and_save,eval=FALSE------------------------------------------------
#  SangerTools::split_and_save(
#   df = health_data,
#   Split_by = "Locality",
#   file_path = "Inputs/",
#   prefix = NULL
#  )

## ----df_to_sql,eval = FALSE---------------------------------------------------
#  SangerTools::df_to_sql(df = combined_rates,
#                         driver = "SQL SERVER",
#                         server = "Org-sql-db",
#                         database = "MyReports",
#                         sql_table_name = "Diabetes_Prevalence",
#                         overwrite = FALSE)
#  
#  

## ----show_brand_palette-------------------------------------------------------

show_brand_palette()

## -----------------------------------------------------------------------------
show_extended_palette()

