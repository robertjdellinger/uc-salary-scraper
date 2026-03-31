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

## Main analytic questions

- What do selected latest-available `2024` person-level UC compensation cohorts look like for police employees, librarians, chancellors, and the UC president?
- How do those observed `2024` compensation levels compare with official `2024-25` UCOP benchmark scales for ASE instructional titles, GSRs, postdoctoral scholars, and ladder-rank professor series?
- How has UC police annual and cumulative spending changed from `2011` through the latest available `2024` year?
- What do annual police payroll estimates look like relative to annual librarian payroll estimates over `2011-2024` when long-run person-level librarian scraping is not the chosen auditable design?

## Central interpretive limits

This repository does not:

- estimate take-home pay;
- treat Transparent California title-summary payroll estimates as exact person-level payroll censuses;
- treat UCOP benchmark scales as realized earnings;
- treat the current `2024` Transparent California UC page as a finalized census.

## Method lock and source review

The source review and analytic rules that govern the project are documented in [references/uc_salary_methodology.md](references/uc_salary_methodology.md).

That methods file locks:

- what each source can and cannot support;
- what `regular_pay`, `overtime_pay`, `other_pay`, `total_pay`, `benefits`, and `total_pay_benefits` mean;
- how University of California year comparability should be handled;
- why multi-year analysis is treated as an annual panel rather than pooled years used as extra sample size;
- when the repository uses person-level Transparent California data, title-summary estimates, or UCOP salary benchmarks.

## Source hierarchy

The repository uses a strict source hierarchy:

1. Transparent California individual records for small, tractable, auditable cohorts.
2. Transparent California UC job-title-summary pages for annual title-series comparisons when deep pagination makes person-level scraping unstable.
3. UCOP salary scales as benchmark or floor/range references only, not as direct substitutes for realized pay.
4. State Controller and other official documentation to verify reporting-period and field-meaning rules.
5. A single explicit price index if any output is converted from nominal to constant dollars.

For the title-summary branch of that hierarchy, Transparent California notes that title-year averages are designed to capture only full-year workers and exclude part-time, seasonal, and partial-year cases. This repository therefore treats count-times-average payroll reconstruction as an annual title-summary estimate rather than an exact person-level payroll census.

## Pay-field meanings

The repository uses Transparent California pay fields in the following way:

- `regular_pay`: annual regular wages or salary reported for the year.
- `overtime_pay`: annual overtime compensation reported for the year.
- `other_pay`: annual non-regular compensation reported for the year.
- `total_pay`: annual realized cash compensation.
- `benefits`: employer-paid benefit cost, not take-home pay.
- `total_pay_benefits`: annual realized compensation plus employer-paid benefits.

## Multi-year comparability rules

Multi-year work in this repository is handled as an annual panel, not as pooled person-years.

- Years are not treated as extra sample size.
- Nominal salary values are not averaged casually across years.
- Annual medians, annual totals, annual ratios, and cumulative totals answer different questions and are labeled separately.
- Cumulative totals are period-spending measures, not annual compensation measures.
- If a single cross-year summary is ever reported, it must be a mean of annual metrics in constant dollars with one explicit price index and one explicit base year.

## Empirical findings

### Latest-available 2024 cross-sectional findings

Observed person-level `2024` results from the focused Transparent California branch:

- UC president median total pay and benefits: `$1,250,206`
- Chancellor median total pay and benefits: `$765,687`
- Police employee median total pay and benefits: `$192,366`
- Librarian median total pay and benefits: `$143,157.50`

Official `2024-25` UCOP benchmark ranges used in the cross-sectional branch:

- ASE instructional titles annual scale range: `$68,000` to `$86,644`
- GSR annual scale range: `$69,129` to `$100,406`
- Postdoctoral scholar annual scale range: `$66,737` to `$80,034`
- Assistant professor annual scale range: `$78,200` to `$101,400`
- Associate professor annual scale range: `$96,500` to `$121,600`
- Professor annual scale range: `$112,900` to `$205,400`

### UC police spending findings, 2011-2024

- Annual UC police `total_pay` rose from `$36.2 million` in 2011 to `$79.9 million` in 2024, an increase of about `120.8%`
- Cumulative UC police `total_pay` from 2011 through 2024 reached `$716.2 million`
- Cumulative UC police `total_pay_benefits` from 2011 through 2024 reached `$821.3 million`
- The overtime share of UC police `total_pay` rose from about `10.3%` in 2011 to `17.3%` in 2024
- `2011` and `2012` show zero reported benefits in Transparent California, so long-run salary-spending graphics emphasize `total_pay` as the most consistent series

### Police versus librarian payroll estimate findings, 2011-2024

- Estimated librarian `total_pay` was about `$46.6 million` in 2011 and `$105.7 million` in 2024
- Estimated police `total_pay` was about `$35.9 million` in 2011 and `$79.2 million` in 2024
- Estimated `2024` police payroll equaled about `74.9%` of estimated `2024` librarian payroll
- Cumulative estimated `2011-2024` police `total_pay` reached about `$710.1 million`
- Cumulative estimated `2011-2024` librarian `total_pay` reached about `$1.209 billion`
- Estimated `2024` police payroll equaled about `664.8` same-year average librarian payrolls
- The maximum absolute validation gap between title-summary police `total_pay` and exact person-level police `total_pay` was about `1.6%`

## Analytical branches and authoritative outputs

### Branch 1: Latest-available 2024 cross-sectional comparison

- `Purpose:` build the focused `2024` person-level scrape, classify tractable cohorts, and compare observed compensation with official UCOP benchmark scales.
- `Scripts:` [scripts/01_scrape_transparent_california_2024.Rmd](scripts/01_scrape_transparent_california_2024.Rmd), [scripts/02_clean_and_classify_uc_salaries_2024.Rmd](scripts/02_clean_and_classify_uc_salaries_2024.Rmd), [scripts/03_uc_salary_analysis_2024.Rmd](scripts/03_uc_salary_analysis_2024.Rmd)
- `Authoritative report:` [outputs/reports/03_uc_salary_analysis_2024.html](outputs/reports/03_uc_salary_analysis_2024.html)
- `Key tables:` [outputs/tables/uc_salary_2024_actual_median_compensation.csv](outputs/tables/uc_salary_2024_actual_median_compensation.csv), [outputs/tables/uc_salary_2024_benchmark_ranges.csv](outputs/tables/uc_salary_2024_benchmark_ranges.csv), [outputs/tables/uc_salary_2024_benchmark_mapping.csv](outputs/tables/uc_salary_2024_benchmark_mapping.csv), [outputs/tables/uc_salary_2024_actual_vs_benchmark_comparison.csv](outputs/tables/uc_salary_2024_actual_vs_benchmark_comparison.csv)
- `Key figures:` [outputs/figures/uc_salary_2024_actual_medians.png](outputs/figures/uc_salary_2024_actual_medians.png), [outputs/figures/uc_salary_2024_benchmark_ranges.png](outputs/figures/uc_salary_2024_benchmark_ranges.png), [outputs/figures/uc_salary_2024_actual_vs_benchmark.png](outputs/figures/uc_salary_2024_actual_vs_benchmark.png), [outputs/figures/uc_salary_2024_ratio_to_gsr_floor.png](outputs/figures/uc_salary_2024_ratio_to_gsr_floor.png), [outputs/figures/uc_salary_2024_police_pay_components.png](outputs/figures/uc_salary_2024_police_pay_components.png)

The cross-sectional branch uses these focused observed cohorts because they remain small enough to scrape cleanly from the public UC search interface:

- Police employees
- Librarians
- Chancellors
- UC president

Large academic and graduate-worker cohorts are represented with official `2024-25` UCOP scales. The public-facing benchmark cohorts are:

- ASE instructional titles
- Graduate student researchers
- Postdoctoral scholars
- Assistant professors
- Associate professors
- Professors

The benchmark mapping table retains the underlying UCOP detail for `Teaching assistants (Group 1 and Group 2)` and `Teaching fellows (Group 1 and Group 2)`, but the public-facing comparison collapses those rows into one broader `ASE instructional titles` benchmark. Lecturer rows from `T015` and `T016` are retained in the benchmark mapping table as documented exclusions rather than plotted in the main comparison.

### Branch 2: UC police spending annual panel

- `Purpose:` trace person-level UC police annual and cumulative spending from `2011` through the latest available `2024` year.
- `Script:` [scripts/04_spending_over_time.Rmd](scripts/04_spending_over_time.Rmd)
- `Authoritative report:` [outputs/reports/04_spending_over_time.html](outputs/reports/04_spending_over_time.html)
- `Key data and tables:` [data/processed/uc_police_spending_2011_2024_detail.csv](data/processed/uc_police_spending_2011_2024_detail.csv), [outputs/tables/uc_police_spending_2011_2024_annual_summary.csv](outputs/tables/uc_police_spending_2011_2024_annual_summary.csv), [outputs/tables/uc_police_spending_2011_2024_component_summary.csv](outputs/tables/uc_police_spending_2011_2024_component_summary.csv), [outputs/tables/uc_police_spending_2011_2024_role_summary.csv](outputs/tables/uc_police_spending_2011_2024_role_summary.csv)
- `Key figures:` [outputs/figures/uc_police_spending_2011_2024_annual_salary_spending.png](outputs/figures/uc_police_spending_2011_2024_annual_salary_spending.png), [outputs/figures/uc_police_spending_2011_2024_cumulative_salary_spending.png](outputs/figures/uc_police_spending_2011_2024_cumulative_salary_spending.png), [outputs/figures/uc_police_spending_2011_2024_annual_component_mix.png](outputs/figures/uc_police_spending_2011_2024_annual_component_mix.png)

### Branch 3: Police versus librarian payroll estimates

- `Purpose:` estimate annual police and librarian payroll from UC job-title-summary pages, validate the police estimate branch against the exact person-level police series, and keep the librarian side explicit as a broad title-series estimate rather than a census.
- `Script:` [scripts/05_comparison_spending_over_time.Rmd](scripts/05_comparison_spending_over_time.Rmd)
- `Authoritative report:` [outputs/reports/05_comparison_spending_over_time.html](outputs/reports/05_comparison_spending_over_time.html)
- `Key data and tables:` [data/processed/uc_police_vs_librarian_2011_2024_title_summary_detail.csv](data/processed/uc_police_vs_librarian_2011_2024_title_summary_detail.csv), [outputs/tables/uc_police_vs_librarian_2011_2024_title_group_reference.csv](outputs/tables/uc_police_vs_librarian_2011_2024_title_group_reference.csv), [outputs/tables/uc_police_vs_librarian_2011_2024_annual_summary.csv](outputs/tables/uc_police_vs_librarian_2011_2024_annual_summary.csv), [outputs/tables/uc_police_vs_librarian_2011_2024_comparison_summary.csv](outputs/tables/uc_police_vs_librarian_2011_2024_comparison_summary.csv), [outputs/tables/uc_police_vs_librarian_2011_2024_police_validation.csv](outputs/tables/uc_police_vs_librarian_2011_2024_police_validation.csv)
- `Key figures:` [outputs/figures/uc_police_vs_librarian_2011_2024_annual_estimated_payroll.png](outputs/figures/uc_police_vs_librarian_2011_2024_annual_estimated_payroll.png), [outputs/figures/uc_police_vs_librarian_2011_2024_payroll_share.png](outputs/figures/uc_police_vs_librarian_2011_2024_payroll_share.png), [outputs/figures/uc_police_vs_librarian_2011_2024_librarian_equivalent_payrolls.png](outputs/figures/uc_police_vs_librarian_2011_2024_librarian_equivalent_payrolls.png)

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

## License and data-use note

Unless otherwise noted, the original code and original written documentation in this repository are licensed under the MIT License.

This repository uses or derives from third-party public-records data sources, including Transparent California and UC salary-scale materials. Those source records, scraped records, and source-derived outputs may not be covered by the repository's code license. Users are responsible for reviewing upstream source documentation, source terms, and applicable public-records rules before redistributing data or derived data products.

This repository should be understood as licensing the code and original explanatory materials, not automatically relicensing upstream public-records compilations or third-party source datasets.

## Current repository status

The repository is in a current-release state rather than a draft handoff state. The active `2024` and `2011-2024` workflows have been rerun from a clean derived-output state, stale `2023` and professor-comparison artifacts have been removed, and the lowercase `data/`, `outputs/`, `references/`, and `scripts/` structure is the canonical repository layout.

Rendered HTML reports, PNG figures, processed CSVs, and QA logs are committed in Git as reproducible public-facing artifacts alongside the source workflow. The main public-facing reports are [outputs/reports/03_uc_salary_analysis_2024.html](outputs/reports/03_uc_salary_analysis_2024.html), [outputs/reports/04_spending_over_time.html](outputs/reports/04_spending_over_time.html), and [outputs/reports/05_comparison_spending_over_time.html](outputs/reports/05_comparison_spending_over_time.html).

## Core sources

- Transparent California UC salary database: <https://transparentcalifornia.com/salaries/university-of-california/>
- Transparent California 2024 UC page: <https://transparentcalifornia.com/salaries/2024/university-of-california/>
- UCOP academic pay schedules: <https://www.ucop.edu/academic-personnel-programs/compensation/academic-pay-schedules/index.html>
- UCOP 2024-25 salary scales:
  <https://www.ucop.edu/academic-personnel-programs/_files/2024-25/oct-2024-scales/t1.pdf>
  <https://www.ucop.edu/academic-personnel-programs/_files/2024-25/july-2024-scales/t15.pdf>
  <https://www.ucop.edu/academic-personnel-programs/_files/2024-25/july-2024-scales/t16.pdf>
  <https://www.ucop.edu/academic-personnel-programs/_files/2024-25/oct-2024-scales/t18.pdf>
  <https://www.ucop.edu/academic-personnel-programs/_files/2024-25/oct-2024-scales/t22.pdf>
  <https://www.ucop.edu/academic-personnel-programs/_files/2024-25/oct-2024-scales/t23.pdf>
- UCnet pay transparency guidance: <https://ucnet.universityofcalifornia.edu/compensation/compensation-guidelines/pay-transparency/>
- UCnet protective-services job specification example: <https://ucnet.universityofcalifornia.edu/job/class-j-protective-services/police-sergeant-supervisor-2/>

## Contact

Robert J. Dellinger  
Ph.D. Student, Atmospheric & Oceanic Sciences, UCLA  
rjdellinger[at]ucla.edu
