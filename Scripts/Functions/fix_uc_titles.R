library(dplyr)
library(stringr)

# Load full abbreviation mappings based on PDF
uc_title_abbrev <- c(
  "CHAN" = "Chancellor",
  "CEO MED CTR" = "Chief Executive Officer – Medical Center",
  "CFO" = "Chief Financial Officer",
  "COO" = "Chief Operating Officer",
  "CCAO" = "Chief Compliance and Audit Officer",
  "CMO" = "Chief Medical Officer",
  "CIO" = "Chief Information Officer",
  "CPO" = "Chief Procurement Officer",
  "CSO" = "Chief Strategy Officer",
  "VP" = "Vice President",
  "VC" = "Vice Chancellor",
  "SVP" = "Senior Vice President",
  "AST VP" = "Assistant Vice President",
  "ASC VP" = "Associate Vice President",
  "EXEC VP" = "Executive Vice President",
  "EXEC DIR" = "Executive Director",
  "DIR" = "Director",
  "CHF" = "Chief",
  "SECR" = "Secretary",
  "PRESIDENT OF THE UNIV" = "President of the University",
  "SPC AST TO PRESIDENT" = "Special Assistant to the President",
  "GEN COUNSEL" = "General Counsel",
  "UNIV LIBRARIAN" = "University Librarian"
)

# Uppercase both keys (names) and values
names(uc_title_abbrev) <- toupper(names(uc_title_abbrev))
uc_title_abbrev <- toupper(uc_title_abbrev)

# Clean and expand titles function (no categorization)
fix_uc_titles <- function(df, title_col = "title_job_descr") {
  df %>%
    mutate(
      # Actually reference the column values
      title_expanded = str_replace_all(.data[[title_col]], uc_title_abbrev)
    )
}

# Example usage:
# cleaned_df <- fix_uc_titles(uc_titles_merged)
