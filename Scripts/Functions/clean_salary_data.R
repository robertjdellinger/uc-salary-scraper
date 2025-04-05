# clean_salary_data.R
library(janitor)  # <-- load packages
library(tidyverse)  # <-- load packages
library(stringr)  # <-- load packages

# Clean Salary Data
clean_salary_data <- function(df) {
  df_clean <- df %>%
    # Remove rows where every column is NA or ""
    filter(if_any(everything(), ~ !is.na(.x) & .x != "")) %>%
    rename(Raw_Job_Title = `Job title`) %>%
    mutate(
      University_System = str_to_upper(case_when(
        str_detect(Raw_Job_Title, "University of California") ~ "University of California",
        TRUE ~ NA_character_
      )),
      Year = str_extract(Raw_Job_Title, "\\b20\\d{2}\\b"),
      Title = str_to_upper(str_trim(str_remove_all(Raw_Job_Title, "University of California|\\b20\\d{2}\\b|,"))),
      Name = if_else(str_detect(Name, ","),
                     str_to_upper(str_trim(str_replace(Name, "(.*),\\s*(.*)", "\\2 \\1"))),
                     str_to_upper(Name))
    ) %>%
    select(-Raw_Job_Title) %>%
    relocate(Name, Title, University_System, Year)
  
  # Convert pay-related columns to numeric
  df_clean <- df_clean %>%
    mutate(across(c(`Regular pay`, `Overtime pay`, `Other pay`, `Total pay`, Benefits, `Total pay & benefits`),
                  ~ as.numeric(str_remove_all(na_if(.x, ""), "[$,]")))) %>% 
    janitor::clean_names() %>% # Clean column names
    mutate(title_job_descr=title, .keep = "unused") %>% # Create a new column with the title/job description
    select(name, title_job_descr, university_system, year, regular_pay, overtime_pay, other_pay, total_pay, benefits, total_pay_benefits)
  
  return(df_clean)
}
