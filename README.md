# UC Salary Scraper and Pay-Equity Analysis

This repository is a publication-quality University of California salary analysis project for organizers, student affairs workers, union researchers, and anyone who needs reusable salary evidence for pay-equity work. It is organized around three linked analytical branches rather than a single scrape: a focused latest-available `2024` observed-compensation branch, a UC police spending over-time branch, and a police-versus-librarian payroll-estimate branch.

At a glance, the repository asks:

- what selected latest-available `2024` realized compensation looks like for small, tractable UC cohorts;
- how those observed `2024` values compare with official `2024-25` UCOP salary-scale benchmarks for academic labor categories;
- how UC police annual and cumulative spending changed over `2011-2024`;
- how estimated police payroll compares with estimated librarian payroll over the same period when using Transparent California title-summary pages.

Core caution: the current Transparent California University of California agency page is `2024`, but it is still labeled `Data Collection in Progress`. This repository therefore treats `2024` as the latest available UC year, not a finalized census, and keeps three source types separate throughout:

- person-level observed compensation from Transparent California individual records;
- title-summary payroll estimates from Transparent California UC job-title-summary pages;
- UCOP salary-scale benchmarks used as floor or range references rather than realized pay.

These source types are analytically related but not interchangeable.

## Design and interpretation

The source review and analytic rules that govern the project are documented in [references/uc_salary_methodology.md](references/uc_salary_methodology.md). In short, the repository uses Transparent California individual records for small, tractable, auditable cohorts; Transparent California UC job-title-summary pages for annual title-series comparisons when deep pagination makes person-level scraping unstable; and UCOP salary scales only as benchmark or floor/range references rather than realized pay.

Transparent California pay fields are treated as annual reported-year values. In this repository, `regular_pay`, `overtime_pay`, and `other_pay` are annual cash-pay components; `total_pay` is annual realized cash compensation; `benefits` is employer-paid benefit cost rather than take-home pay; and `total_pay_benefits` is annual realized compensation plus employer-paid benefits.

Multi-year work is handled as an annual panel, not as pooled person-years. Years are not treated as extra sample size, nominal salary values are not averaged casually across years, and annual medians, annual totals, annual ratios, and cumulative totals are kept distinct because they answer different questions. Cumulative totals are period-spending measures, not annual compensation measures.

This repository does not estimate take-home pay, does not treat Transparent California title-summary payroll estimates as exact person-level payroll censuses, does not treat UCOP benchmark scales as realized earnings, and does not treat the current `2024` Transparent California UC page as a finalized census.

## Workflow branches

The latest-available `2024` cross-sectional branch runs through [scripts/01_scrape_transparent_california_2024.Rmd](scripts/01_scrape_transparent_california_2024.Rmd), [scripts/02_clean_and_classify_uc_salaries_2024.Rmd](scripts/02_clean_and_classify_uc_salaries_2024.Rmd), and [scripts/03_uc_salary_analysis_2024.Rmd](scripts/03_uc_salary_analysis_2024.Rmd). It builds the focused person-level candidate pool, resolves cohort assignment, and compares observed compensation with official UCOP benchmark scales. Its main public-facing output is [outputs/reports/03_uc_salary_analysis_2024.html](outputs/reports/03_uc_salary_analysis_2024.html).

The UC police spending branch runs through [scripts/04_spending_over_time.Rmd](scripts/04_spending_over_time.Rmd). It produces a person-level annual panel of UC police spending from `2011` through the latest available `2024` year, with annual and cumulative nominal series kept analytically distinct. Its main public-facing output is [outputs/reports/04_spending_over_time.html](outputs/reports/04_spending_over_time.html).

The police-versus-librarian comparison branch runs through [scripts/05_comparison_spending_over_time.Rmd](scripts/05_comparison_spending_over_time.Rmd). It reconstructs annual payroll estimates from Transparent California title-summary pages, validates the police estimate branch against the exact person-level police series, and keeps the librarian side explicit as a title-summary estimate rather than a census. Its main public-facing output is [outputs/reports/05_comparison_spending_over_time.html](outputs/reports/05_comparison_spending_over_time.html).

## Current outputs

The repository includes a latest-available `2024` cross-sectional branch, a `2011-2024` police spending branch, and a police-versus-librarian payroll estimate branch. The three authoritative HTML reports are [outputs/reports/03_uc_salary_analysis_2024.html](outputs/reports/03_uc_salary_analysis_2024.html), [outputs/reports/04_spending_over_time.html](outputs/reports/04_spending_over_time.html), and [outputs/reports/05_comparison_spending_over_time.html](outputs/reports/05_comparison_spending_over_time.html).

## Artifact map

- [outputs/reports/](outputs/reports/) contains the rendered HTML reports.
- [outputs/tables/](outputs/tables/) contains publication-ready tables and benchmark mappings.
- [outputs/figures/](outputs/figures/) contains exported PNG figures.
- [outputs/logs/](outputs/logs/) contains QA summaries, scrape manifests, and join audits.
- [data/processed/](data/processed/) contains cleaned and analysis-ready data products consumed by the reports.

## Project structure

```text
uc-salary-scraper/
|-- README.md
|-- data/
|   |-- raw/
|   |   |-- transparent_california/
|   |   `-- uc_reference/
|   `-- processed/
|-- outputs/
|   |-- figures/
|   |-- logs/
|   |   |-- joins/
|   |   `-- qa/
|   |-- reports/
|   `-- tables/
|-- references/
|-- scripts/
|   `-- functions/
`-- uc-salary-scraper.Rproj
```

This structure keeps raw data in `data/raw/`, cleaned and analysis-ready data in `data/processed/`, rendered public outputs in `outputs/`, and the canonical R Markdown workflow in `scripts/`.

## How to rerun

Install required R packages into the local project library:

```bash
mkdir -p .Rlib
R_LIBS_USER="$PWD/.Rlib" Rscript -e "install.packages(c('dplyr','ggplot2','glue','janitor','knitr','purrr','readr','rmarkdown','rvest','scales','stringr','tibble','tidyr','xml2'), repos='https://cloud.r-project.org')"
```

Render the latest-available 2024 pipeline from the project root:

```bash
R_LIBS_USER="$PWD/.Rlib" Rscript -e "rmarkdown::render('scripts/01_scrape_transparent_california_2024.Rmd', output_dir='outputs/reports'); rmarkdown::render('scripts/02_clean_and_classify_uc_salaries_2024.Rmd', output_dir='outputs/reports'); rmarkdown::render('scripts/03_uc_salary_analysis_2024.Rmd', output_dir='outputs/reports'); rmarkdown::render('scripts/04_spending_over_time.Rmd', output_dir='outputs/reports'); rmarkdown::render('scripts/05_comparison_spending_over_time.Rmd', output_dir='outputs/reports')"
```

## Reuse and repository status

The repository is in a current-release state rather than a draft handoff state. The active `2024` and `2011-2024` workflows have been rerun from a clean derived-output state, stale `2023` and professor-comparison artifacts have been removed, and the lowercase `data/`, `outputs/`, `references/`, and `scripts/` structure is the canonical repository layout. Rendered HTML reports, PNG figures, processed CSVs, and QA logs are committed in Git as reproducible public-facing artifacts alongside the source workflow.

Unless otherwise noted, the original code and original written documentation in this repository are licensed under the MIT License. This repository uses or derives from third-party public-records data sources, including Transparent California and UC salary-scale materials, and those source records, scraped records, and source-derived outputs may not be covered by the repository's code license. Users are responsible for reviewing upstream source documentation, source terms, and applicable public-records rules before redistributing data or derived data products. See [LICENSE](LICENSE) for the repository license boundary.

## Source families

The repository draws primarily on three source families: Transparent California UC individual salary records, Transparent California UC job-title-summary pages, and official UCOP academic salary-scale materials. The source review, reporting-period rules, pay-field meanings, and citation inventory are documented in [references/uc_salary_methodology.md](references/uc_salary_methodology.md) and [references/uc_salary_sources.bib](references/uc_salary_sources.bib).

## Contact
**Robert J. Dellinger**  
**Ph.D. Student, Atmospheric & Oceanic Sciences, UCLA**  
**rjdellinger[at]ucla.edu**  

[![GitHub](https://img.shields.io/badge/GitHub-rob--dellinger-181717?logo=github&logoColor=white)](https://github.com/rob-dellinger)  

