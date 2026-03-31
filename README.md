# UC Salary Scraper and Pay-Equity Analysis

This repository is a publication-quality University of California salary analysis project built for organizers, student affairs workers, union researchers, and anyone who needs reusable salary evidence for pay-equity work.

The repository now centers the latest available `2024` UC salary records from Transparent California and pairs them with official `2024-25` UCOP salary-scale benchmarks for academic and graduate-worker title series.

## Method lock

The repository is now in an explicit design-lock phase. The source review and analytic rules that govern the project are documented in:

- [`references/uc_salary_methodology.md`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/references/uc_salary_methodology.md)

That methods file now locks:

- what each source can and cannot support;
- what `regular_pay`, `overtime_pay`, `other_pay`, `total_pay`, `benefits`, and `total_pay_benefits` mean;
- how University of California year comparability should be handled;
- why multi-year analysis is treated as an annual panel rather than pooled years used as extra sample size;
- when the repository uses person-level Transparent California data, title-summary estimates, or UCOP salary benchmarks.

## Current analytic design

As of March 31, 2026, Transparent California publicly exposes a `2011-2024` University of California salary database, and the current UC agency page is `2024`. That page is still labeled `2024 Data Collection in Progress`, so this repository now treats 2024 as the latest available UC year rather than a finalized census.

That design is intentional:

- it uses the latest available public UC salary records for focused actual-pay cohorts that remain small enough to scrape cleanly;
- it uses official UCOP salary-scale tables for large academic and graduate-worker cohorts that Transparent California still does not expose cleanly through deep public pagination;
- it keeps the methodological caveat visible instead of pretending that "latest available" and "latest complete" are the same thing.

## Source hierarchy

The repository uses a strict source hierarchy:

1. Transparent California individual records for small, tractable, auditable cohorts.
2. Transparent California UC job-title-summary pages for annual title-series comparisons when deep pagination makes person-level scraping unstable.
3. UCOP salary scales as benchmark or floor/range references only, not as direct substitutes for realized pay.
4. State Controller and other official documentation to verify reporting-period and field-meaning rules.
5. A single explicit price index if any output is converted from nominal to constant dollars.

For the job-title-summary branch of that hierarchy, Transparent California notes that title-year averages are designed to capture full-year workers and exclude part-time, seasonal, and partial-year cases. This repository therefore treats count-times-average payroll reconstruction as an annual title-summary estimate rather than an exact person-level payroll census.

## Pay-field meanings

The repository uses Transparent California pay fields in the following way:

- `regular_pay`: annual regular wages or salary reported for the year.
- `overtime_pay`: annual overtime compensation reported for the year.
- `other_pay`: annual non-regular compensation reported for the year.
- `total_pay`: annual realized cash compensation.
- `benefits`: employer-paid benefit cost, not take-home pay.
- `total_pay_benefits`: annual realized compensation plus employer-paid benefits.

## Multi-year rules

Multi-year work in this repository is handled as an annual panel, not as pooled person-years.

- Years are not treated as extra sample size.
- Nominal salary values are not averaged casually across years.
- Annual medians, annual totals, annual ratios, and cumulative totals answer different questions and are labeled separately.
- If a single cross-year summary is ever reported, it must be a mean of annual metrics in constant dollars with one explicit price index and one explicit base year.

## What this repo contains

- Main R Markdown pipeline:
  [`scripts/01_scrape_transparent_california_2024.Rmd`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/scripts/01_scrape_transparent_california_2024.Rmd)
  [`scripts/02_clean_and_classify_uc_salaries_2024.Rmd`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/scripts/02_clean_and_classify_uc_salaries_2024.Rmd)
  [`scripts/03_uc_salary_analysis_2024.Rmd`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/scripts/03_uc_salary_analysis_2024.Rmd)
- Standalone police-spending workflow:
  [`scripts/04_spending_over_time.Rmd`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/scripts/04_spending_over_time.Rmd)
- Standalone police-versus-librarian payroll workflow:
  [`scripts/05_comparison_spending_over_time.Rmd`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/scripts/05_comparison_spending_over_time.Rmd)
- Shared helper functions:
  [`scripts/functions/uc_salary_utils.R`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/scripts/functions/uc_salary_utils.R)
- UC reference data:
  [`data/raw/uc_reference/uc_salary_query_registry.csv`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/data/raw/uc_reference/uc_salary_query_registry.csv)
  [`data/raw/uc_reference/uc_2024_25_pay_scale_benchmarks.csv`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/data/raw/uc_reference/uc_2024_25_pay_scale_benchmarks.csv)
- Methodology and citations:
  [`references/uc_salary_methodology.md`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/references/uc_salary_methodology.md)
  [`references/uc_salary_sources.bib`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/references/uc_salary_sources.bib)

## Focused actual-pay cohorts

The latest-available 2024 Transparent California pipeline uses these actual-pay cohorts:

- Police employees
- Librarians
- Chancellors
- UC president

These cohorts are retained because they remain small enough to scrape cleanly from the public UC search interface.

## Official benchmark cohorts

Large academic and graduate-worker cohorts are represented with official `2024-25` UCOP scales. The main cross-sectional comparison uses these grouped benchmark cohorts:

- ASE instructional titles
- Graduate student researchers
- Postdoctoral scholars
- Assistant professors
- Associate professors
- Professors

The benchmark mapping table retains the underlying UCOP detail for `Teaching assistants (Group 1 and Group 2)` and `Teaching fellows (Group 1 and Group 2)`, but the public-facing comparison collapses those rows into one broader `ASE instructional titles` benchmark. Lecturer rows from `T015` and `T016` are also retained in the benchmark mapping table as documented exclusions rather than plotted in the main comparison.

## Key 2024 outputs

### Actual medians from the latest 2024 build

- UC president median total pay and benefits: `$1,250,206`
- Chancellor median total pay and benefits: `$765,687`
- Police employee median total pay and benefits: `$192,366`
- Librarian median total pay and benefits: `$143,157.50`

Source table:
[`outputs/tables/uc_salary_2024_actual_median_compensation.csv`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/outputs/tables/uc_salary_2024_actual_median_compensation.csv)

### Official 2024-25 salary-scale benchmarks in the latest build

- ASE instructional titles annual scale range: `$68,000` to `$86,644`
- GSR annual scale range: `$69,129` to `$100,406`
- Postdoctoral scholar annual scale range: `$66,737` to `$80,034`
- Assistant professor annual scale range: `$78,200` to `$101,400`
- Associate professor annual scale range: `$96,500` to `$121,600`
- Professor annual scale range: `$112,900` to `$205,400`

Source table:
[`outputs/tables/uc_salary_2024_benchmark_ranges.csv`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/outputs/tables/uc_salary_2024_benchmark_ranges.csv)

Benchmark mapping table with preserved Group 1 and Group 2 codes plus documented lecturer exclusions:
[`outputs/tables/uc_salary_2024_benchmark_mapping.csv`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/outputs/tables/uc_salary_2024_benchmark_mapping.csv)

### Publication-ready 2024 figures

- [`outputs/figures/uc_salary_2024_actual_medians.png`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/outputs/figures/uc_salary_2024_actual_medians.png)
- [`outputs/figures/uc_salary_2024_benchmark_ranges.png`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/outputs/figures/uc_salary_2024_benchmark_ranges.png)
- [`outputs/figures/uc_salary_2024_actual_vs_benchmark.png`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/outputs/figures/uc_salary_2024_actual_vs_benchmark.png)
- [`outputs/figures/uc_salary_2024_ratio_to_gsr_floor.png`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/outputs/figures/uc_salary_2024_ratio_to_gsr_floor.png)
- [`outputs/figures/uc_salary_2024_police_pay_components.png`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/outputs/figures/uc_salary_2024_police_pay_components.png)

### Rendered 2024 reports

- [`outputs/reports/01_scrape_transparent_california_2024.html`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/outputs/reports/01_scrape_transparent_california_2024.html)
- [`outputs/reports/02_clean_and_classify_uc_salaries_2024.html`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/outputs/reports/02_clean_and_classify_uc_salaries_2024.html)
- [`outputs/reports/03_uc_salary_analysis_2024.html`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/outputs/reports/03_uc_salary_analysis_2024.html)

## Standalone police spending workflow

The repository also includes a separate multi-year police-spending report in
[`scripts/04_spending_over_time.Rmd`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/scripts/04_spending_over_time.Rmd).

That report now uses the latest available `2011-2024` UC police series, including the in-progress `2024` page, rather than ending the series at `2023`.

### Headline police spending results

- Annual UC police `total_pay` rose from `$36.2 million` in 2011 to `$79.9 million` in 2024, an increase of about `120.8%`
- Cumulative UC police `total_pay` from 2011 through 2024 reached `$716.2 million`
- Cumulative UC police `total_pay_benefits` from 2011 through 2024 reached `$821.3 million`
- The overtime share of UC police `total_pay` rose from about `10.3%` in 2011 to `17.3%` in 2024
- The `POLICE` title filter removed `6` non-police rows across the full 2011-2024 candidate pool
- `2011` and `2012` still show zero reported benefits in Transparent California, so long-run salary-spending graphics emphasize `total_pay` as the most consistent series

### Police-spending outputs

- Detail dataset:
  [`data/processed/uc_police_spending_2011_2024_detail.csv`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/data/processed/uc_police_spending_2011_2024_detail.csv)
- Annual summary table:
  [`outputs/tables/uc_police_spending_2011_2024_annual_summary.csv`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/outputs/tables/uc_police_spending_2011_2024_annual_summary.csv)
- Component summary table:
  [`outputs/tables/uc_police_spending_2011_2024_component_summary.csv`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/outputs/tables/uc_police_spending_2011_2024_component_summary.csv)
- Role summary table:
  [`outputs/tables/uc_police_spending_2011_2024_role_summary.csv`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/outputs/tables/uc_police_spending_2011_2024_role_summary.csv)
- Annual spending figure:
  [`outputs/figures/uc_police_spending_2011_2024_annual_salary_spending.png`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/outputs/figures/uc_police_spending_2011_2024_annual_salary_spending.png)
- Cumulative spending figure:
  [`outputs/figures/uc_police_spending_2011_2024_cumulative_salary_spending.png`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/outputs/figures/uc_police_spending_2011_2024_cumulative_salary_spending.png)
- Annual component figure:
  [`outputs/figures/uc_police_spending_2011_2024_annual_component_mix.png`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/outputs/figures/uc_police_spending_2011_2024_annual_component_mix.png)
- Rendered report:
  [`outputs/reports/04_spending_over_time.html`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/outputs/reports/04_spending_over_time.html)

## Standalone police versus librarian payroll workflow

The repository also includes a separate over-time police-versus-librarian payroll report in
[`scripts/05_comparison_spending_over_time.Rmd`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/scripts/05_comparison_spending_over_time.Rmd).

That workflow uses Transparent California's annual UC job-title-summary pages to estimate annual police and librarian payroll, validates the police title-summary totals against the exact person-level police series, and keeps the librarian side explicit as a broad title-series cohort rather than pretending it is an exact audited person-level census.

### Headline police versus librarian results

- Estimated librarian `total_pay` was about `$46.6 million` in 2011 and `$105.7 million` in 2024
- Estimated police `total_pay` was about `$35.9 million` in 2011 and `$79.2 million` in 2024
- Estimated 2024 police payroll equaled about `74.9%` of estimated 2024 librarian payroll
- Cumulative estimated `2011-2024` police `total_pay` reached about `$710.1 million`
- Cumulative estimated `2011-2024` librarian `total_pay` reached about `$1.209 billion`
- Estimated 2024 police payroll equaled about `664.8` same-year average librarian payrolls
- The maximum absolute validation gap between title-summary police `total_pay` and exact person-level police `total_pay` was about `1.6%`

### Police versus librarian outputs

- Title-summary detail dataset:
  [`data/processed/uc_police_vs_librarian_2011_2024_title_summary_detail.csv`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/data/processed/uc_police_vs_librarian_2011_2024_title_summary_detail.csv)
- Librarian title crosswalk:
  [`outputs/tables/uc_police_vs_librarian_2011_2024_title_group_reference.csv`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/outputs/tables/uc_police_vs_librarian_2011_2024_title_group_reference.csv)
- Annual comparison summary:
  [`outputs/tables/uc_police_vs_librarian_2011_2024_annual_summary.csv`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/outputs/tables/uc_police_vs_librarian_2011_2024_annual_summary.csv)
- Comparison summary:
  [`outputs/tables/uc_police_vs_librarian_2011_2024_comparison_summary.csv`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/outputs/tables/uc_police_vs_librarian_2011_2024_comparison_summary.csv)
- Police validation table:
  [`outputs/tables/uc_police_vs_librarian_2011_2024_police_validation.csv`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/outputs/tables/uc_police_vs_librarian_2011_2024_police_validation.csv)
- Annual payroll figure:
  [`outputs/figures/uc_police_vs_librarian_2011_2024_annual_estimated_payroll.png`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/outputs/figures/uc_police_vs_librarian_2011_2024_annual_estimated_payroll.png)
- Payroll-share figure:
  [`outputs/figures/uc_police_vs_librarian_2011_2024_payroll_share.png`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/outputs/figures/uc_police_vs_librarian_2011_2024_payroll_share.png)
- Payroll-equivalent figure:
  [`outputs/figures/uc_police_vs_librarian_2011_2024_librarian_equivalent_payrolls.png`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/outputs/figures/uc_police_vs_librarian_2011_2024_librarian_equivalent_payrolls.png)
- Rendered report:
  [`outputs/reports/05_comparison_spending_over_time.html`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/outputs/reports/05_comparison_spending_over_time.html)

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
R_LIBS_USER="$PWD/.Rlib" Rscript -e "install.packages(c('rvest','janitor','here','lubridate'), repos='https://cloud.r-project.org')"
```

Render the latest-available 2024 pipeline from the project root:

```bash
R_LIBS_USER="$PWD/.Rlib" Rscript -e "rmarkdown::render('scripts/01_scrape_transparent_california_2024.Rmd', output_dir='outputs/reports')"
R_LIBS_USER="$PWD/.Rlib" Rscript -e "rmarkdown::render('scripts/02_clean_and_classify_uc_salaries_2024.Rmd', output_dir='outputs/reports')"
R_LIBS_USER="$PWD/.Rlib" Rscript -e "rmarkdown::render('scripts/03_uc_salary_analysis_2024.Rmd', output_dir='outputs/reports')"
R_LIBS_USER="$PWD/.Rlib" Rscript -e "rmarkdown::render('scripts/04_spending_over_time.Rmd', output_dir='outputs/reports')"
R_LIBS_USER="$PWD/.Rlib" Rscript -e "rmarkdown::render('scripts/05_comparison_spending_over_time.Rmd', output_dir='outputs/reports')"
```

## License and data-use note

Unless otherwise noted, the original code and original written documentation in this repository are licensed under the MIT License.

This repository uses or derives from third-party public-records data sources, including Transparent California and UC salary-scale materials. Those source records, scraped records, and source-derived outputs may not be covered by the repository's code license. Users are responsible for reviewing upstream source documentation, source terms, and applicable public-records rules before redistributing data or derived data products.

This repository should be understood as licensing the code and original explanatory materials, not automatically relicensing upstream public-records compilations or third-party source datasets.

### Data notice

This repository includes code, documentation, and outputs built from public-records-based salary data and related institutional materials.

### What the repository license covers

The MIT License in this repository applies to the repository's original code and original written documentation unless otherwise noted.

### What the repository license may not cover

Third-party source data, scraped records, public-records compilations, and source-derived outputs may be subject to separate source terms, source documentation, and legal constraints. In particular, upstream sources such as Transparent California may provide access to public-records compilations without granting a blanket open-data relicensing right.

Users are responsible for reviewing upstream source documentation and terms before redistributing raw data or derivative data products.

### Practical interpretation

You may generally reuse the code and original written materials in this repository under the MIT License. Reuse or redistribution of source-based datasets or source-derived outputs should be evaluated separately.

## Final handoff

This final publication pass removed stale 2023 and professor-comparison artifacts, reran the active 2024 and `2011-2024` workflows from a clean derived-output state, tightened figure captions and source notes, and aligned the repository to the locked analytic design.

The lowercase `data/`, `outputs/`, `references/`, and `scripts/` structure is the canonical repository layout. This repository is intended to ship with rendered HTML reports, PNG figures, processed CSVs, and QA logs committed in Git as reproducible public-facing artifacts alongside the source workflow.

The authoritative public-facing outputs are:

- [`outputs/reports/03_uc_salary_analysis_2024.html`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/outputs/reports/03_uc_salary_analysis_2024.html) for the latest-available 2024 realized-compensation versus benchmark comparison.
- [`outputs/reports/04_spending_over_time.html`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/outputs/reports/04_spending_over_time.html) for person-level UC police annual and cumulative spending.
- [`outputs/reports/05_comparison_spending_over_time.html`](/Users/rjdellinger/Documents/GitHub/uc-salary-scraper/outputs/reports/05_comparison_spending_over_time.html) for annual police-versus-librarian title-summary payroll estimates.

The main cautions are:

- `2024` is the latest available UC year in Transparent California, but the UC page is still marked `Data Collection in Progress`.
- Person-level Transparent California compensation is agency-reported annual pay and employer-paid benefits, not take-home pay.
- Title-summary police-versus-librarian outputs are reconstructed annual payroll estimates, not exact person-level payroll censuses.
- UCOP salary scales are benchmark floors or ranges, not observed realized pay.
- Multi-year figures in this repository are nominal-dollar annual panels or cumulative totals unless explicitly labeled otherwise.

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
