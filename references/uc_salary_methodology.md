# UC Salary Source Review and Analytic Design Lock

This document locks the analytic design for the repository before any further major rewrites. It explains what each source can support, what each pay field means, which comparisons are analytically defensible, and which year-comparability rules govern the repository.

## Design status

As of March 31, 2026, the repository should be treated as being in a design-lock phase rather than a "just make it work" phase. That means:

- source documentation comes before major analysis rewrites;
- each cohort definition must be explicit and machine-readable;
- each figure must identify whether it uses person-level realized pay, title-summary estimates, UCOP benchmark scales, or a documented combination of those sources;
- multi-year analysis must be structured as an annual panel, not as pooled years treated as extra sample size.

## Source hierarchy

The repository uses the following source hierarchy.

1. Transparent California individual records

Use this when the cohort scrape is tractable, auditable, and complete enough to verify row counts against the public search interface.

2. Transparent California UC job-title-summary pages

Use this for annual title-series comparisons when person-level deep pagination is unstable or too large to scrape cleanly.

3. UCOP salary scales

Use these as benchmark, floor, or range references only. Do not treat them as realized pay.

4. California State Controller Government Compensation in California documentation

Use this to verify reporting-period conventions and compensation-field meanings for University of California public-pay reporting.

5. BLS CPI-U annual average index

Use this if any multi-year summary is converted to constant dollars or if a real-dollar companion series is added.

For licensing and reuse boundaries, see the repository LICENSE file and the README “License and data-use note” section, which clarify that the repository license covers original code and original written documentation, not necessarily third-party source data or source-derived outputs.

## Transparent California source review

### What Transparent California provides

Transparent California publishes annual public employee compensation records and annual job-title summaries for many California public employers, including the University of California.

- University of California salary database:
  <https://transparentcalifornia.com/salaries/university-of-california/>
- Latest available 2024 University of California page:
  <https://transparentcalifornia.com/salaries/2024/university-of-california/>
- UC job-title summary page pattern:
  <https://transparentcalifornia.com/salaries/2024/university-of-california/job_title_summary/>

### Transparent California pay fields

Transparent California's person-level University of California pages expose these pay fields.

- `regular_pay`
- `overtime_pay`
- `other_pay`
- `total_pay`
- `benefits`
- `total_pay_benefits`

For repository purposes, those fields should be interpreted as follows.

- `regular_pay`: annual regular wages or salary reported for the record year.
- `overtime_pay`: annual overtime compensation reported for the record year.
- `other_pay`: annual non-regular compensation reported for the record year.
- `total_pay`: annual realized cash compensation from regular pay, overtime pay, and other pay.
- `benefits`: employer-paid benefit cost, not take-home pay.
- `total_pay_benefits`: annual realized compensation plus employer-paid benefits.

The repository must not describe benefits as take-home pay and must not imply that `total_pay_benefits` is cash received by the worker.

### Transparent California reporting basis and data provenance

Transparent California states in its FAQ and source notes that:

- values are annual amounts for the reported year;
- some agencies report on a calendar-year basis and others on a fiscal-year basis;
- benefits reflect employer-paid benefit costs;
- the platform relies on agency-reported data.

That means year comparability cannot be assumed generically across all employers without checking source documentation.

### University of California year basis

For University of California specifically, the California State Controller's Government Compensation in California site provides the cleanest reporting-period guidance.

- GCC reporting page:
  <https://publicpay.ca.gov/Reporting>
- Example University of California detail page:
  <https://publicpay.ca.gov/Reports/HigherEducations/UCEntity.aspx?entityid=8248&rpt=3&year=2024>

The State Controller's University of California detail pages state that:

- average values are based on all W-2 employees and board members reported for the calendar year;
- partial-year and part-time employees are still counted as full-time employees in those averages;
- some employees included in those averages do not receive retirement and/or health benefits.

For this repository, the defensible rule is:

- treat University of California Transparent California annual records as annual values for the reported year;
- treat UC multi-year series as annual panels indexed by year;
- document that the latest available 2024 Transparent California UC page is still marked `Data Collection in Progress` and is therefore not a finalized census.

### Transparent California job-title-summary pages

The UC job-title-summary pages expose, by title and year:

- `Count`
- `Avg Regular pay`
- `Avg Overtime pay`
- `Avg Other pay`
- `Avg Total pay`
- `Avg Benefits`
- `Avg Total pay & benefits`

The page note states:

- averages are designed to capture only those who have worked a full year;
- part-time, seasonal, and partial-year cases are excluded from those averages.

That means the repository must treat title-summary payroll reconstruction as an estimate rather than an exact person-level payroll sum. If count times average is used to reconstruct annual title-group payroll, the resulting quantities must be labeled as estimated payroll.

### Transparent California source limits

Transparent California supports the following analytically defensible uses in this repository.

- exact annual person-level realized pay for small, auditable cohorts where complete scraping is tractable;
- annual title-series estimates when title-summary pages are available and person-level deep pagination is unstable;
- annual totals, annual medians, annual ratios, and cumulative spending totals with source-type caveats.

Transparent California does not support the following without stronger justification.

- pretending the in-progress 2024 UC page is a finalized census;
- treating title-summary estimates as exact audited payroll totals;
- pooling person-year records across years and calling the result a larger independent sample;
- silently mixing person-level records and title-summary estimates in the same figure without labeling the source difference.

## UCOP salary-scale source review

### What UCOP salary scales support

UCOP academic salary scales are official compensation schedules. They are appropriate for:

- benchmark floors;
- benchmark ranges;
- salary-structure interpretation;
- title-code and pay-table mapping;
- bargaining and organizing references to official compensation systems.

They are not direct substitutes for realized pay and should never be labeled as observed compensation.

### Relevant UCOP sources

- Academic pay schedules index:
  <https://www.ucop.edu/academic-personnel-programs/compensation/academic-pay-schedules/index.html>
- 2024-25 historic salary scales page:
  <https://ucop.edu/academic-personnel-programs/compensation/historic-academic-salary-scales/2024-25-academic-salary-scales.html>
- Academic titles sorted by salary scale table number:
  <https://www.ucop.edu/academic-personnel-programs/_files/acad-title-codes/academic-titles-sorted-salary-table.pdf>

### Table mapping rules for this repository

The repository should use these benchmark-source mappings.

- `Teaching assistants` and `Teaching fellows`:
  Table 18, Student Titles.
  This table separates `Group 1` and `Group 2`, where Group 1 covers campuses outside Berkeley, Los Angeles, and San Francisco and Group 2 covers Berkeley, Los Angeles, and San Francisco.

- `Graduate student researchers`:
  Table 22, Student Titles, Graduate Student Researcher, Fiscal Year.

- `Postdoctoral scholars`:
  Table 23, Postdoctoral Scholar salary scales, Fiscal Year.

- `Ladder-rank professor benchmarks`:
  use the correct professor-series table for the intended benchmark and label it precisely.
  If the benchmark is a generic ladder-rank academic-year professor reference, Table 1 is acceptable only if the figure or table says it is an academic-year professor-series benchmark rather than a substitute for all realized professor compensation.

- `Unit 18 lecturers`:
  Tables 15 and 16, which are separate compensation systems and should not be collapsed into ladder-rank professor analysis without an explicit substantive reason.

### UCOP time basis and effective dates

The UCOP salary-scale pages make clear that the relevant tables have different time bases and effective dates.

- Table 22 and Table 23 are fiscal-year scales with stated effective dates.
- Table 18 student-title scales also carry explicit effective dates and group structure.
- Ladder-rank and lecturer scales have stated effective dates and can differ by appointment basis and system.

That means the repository must:

- label benchmarks as salary-scale floors or ranges, not realized annual pay;
- preserve the underlying table codes and effective-date logic;
- avoid implying that all faculty systems are interchangeable.

## Comparison rules locked for the repository

### Allowed comparison types

These comparisons are analytically defensible if labeled clearly.

- person-level annual medians or totals for small, tractable Transparent California cohorts;
- annual title-summary estimates for police versus broad librarian title-series cohorts;
- observed annual compensation versus benchmark floor or range figures, if the source-type difference is explicit;
- cumulative police spending totals, if labeled as cumulative nominal spending rather than annual compensation.

### Disallowed or restricted comparison types

These should not appear without additional methodological work.

- pooled multi-year average salaries treated as if years were extra sample size;
- nominal multi-year summaries presented as real compensation change;
- direct substitution of UCOP salary-scale values for realized pay;
- collapsing ladder-rank professors, Unit 18 lecturers, graduate-worker titles, and executives into one generic `faculty` bucket without prominent caveats;
- treating missing or zero benefits as substantively meaningful without checking reporting behavior for that year.

## Multi-year design rules

### Annual panel, not pooled years

Multi-year analysis in this repository must use an annual panel design.

- each year is a separate time point;
- annual metrics should be computed within year;
- the repository should compare trajectories, year-over-year changes, annual medians, annual totals, and cumulative totals across years.

Years are not extra sample size. Time is not replication.

### Inflation and across-year summary rules

Do not average salary values across years in nominal dollars.

If the repository needs one summary number across years, it must:

1. convert all monetary values to constant dollars using one explicit index and one explicit base year;
2. state the exact estimand;
3. label the result as a mean of annual cohort-level metrics, not a pooled person-level average.

The recommended price index for this repository is:

- BLS CPI-U annual average, U.S. city average, all items;
- one consistent base year, preferably `2024 = 100%` in repository narrative or an equivalent deflator ratio.

If constant-dollar series are not implemented in a multi-year output, the figure and caption must say the values are nominal dollars.

### Cumulative totals

Cumulative totals are allowed for spending analysis because they answer a different question than annual compensation.

- annual medians answer a pay-level question;
- annual totals answer an annual spending question;
- cumulative totals answer a period-spending question.

The repository must not blur those estimands together.

## Cohort design rules

### Main 2024 cross-sectional report

The main latest-available 2024 report should use:

- person-level Transparent California realized pay for:
  `Police employees`, `Librarians`, `Chancellors`, and `UC president`;
- UCOP benchmark scales for:
  `ASE instructional titles`, `Graduate student researchers`, `Postdoctoral scholars`, and explicitly labeled ladder-rank professor benchmark cohorts.

### Teaching assistant and teaching fellow recodes

Grouping teaching assistants and teaching fellows into the broader analytic `ASE instructional titles` cohort is defensible if:

- the original source labels are preserved;
- the `Group 1` and `Group 2` distinction remains available in a machine-readable crosswalk;
- the recode is explicitly named;
- the report explains why the groups are collapsed for public-facing clarity.

### Lecturer handling

Lecturers with SOE, senior lecturers with SOE, and related Unit 18 lecturer titles should be removed from the main ladder-rank professor comparison. They may remain in supplemental analysis, but they should not be mixed into the core professor benchmark without explicit justification.

### Police versus librarian multi-year comparison

The defensible over-time comparison is:

- police annual payroll versus broad librarian-series annual payroll, estimated from the title-summary pages rather than pooled person-level employee-years;
- librarian title definitions grounded in an explicit observed-title crosswalk, with current 2024 librarian title matches kept as an audit aid rather than a substitute for the historical crosswalk;
- broad inclusion of university, law, assistant, associate, career, potential-career, temporary, and visiting librarian titles documented explicitly;
- validation of title-summary police estimates against exact police person-level totals before relying on the same method for librarian payroll estimates.

## Machine-readable documentation requirements

The repository should include these machine-readable reference files.

- cohort crosswalks showing source title strings, cleaned title strings, recoded analytic cohorts, and exclusion flags;
- benchmark mapping tables linking cohorts to UCOP table numbers, codes, effective dates, and rationale;
- title crosswalks for ladder-rank professor comparisons showing included and excluded title variants;
- QA logs that record missing columns, scrape row-count changes, crosswalk join failures, and schema mismatches.

## Reporting requirements

Every final table or figure must identify:

- the source type:
  person-level Transparent California,
  Transparent California job-title-summary estimate,
  UCOP salary benchmark,
  or a documented combination;
- the year coverage;
- whether values are nominal or constant dollars;
- the cohort definition;
- the estimand:
  annual median,
  annual total,
  annual ratio,
  or cumulative total.

Every final report and README section should explain:

- what `regular pay`, `overtime pay`, `other pay`, `total pay`, `benefits`, and `total pay & benefits` mean;
- why title groups were combined or excluded;
- why multi-year work is handled as an annual panel;
- why police-versus-librarian over-time analysis uses title-summary estimates rather than treating pooled employee-years as added sample size;
- what the outputs can and cannot support in advocacy work.

## Current locked design summary

The repository's locked design is therefore:

- latest-available 2024 cross-sectional comparison for small, tractable person-level UC cohorts;
- UCOP salary-scale benchmarks used only as official structural references, not realized pay;
- annual `2011-2024` panel logic for over-time analysis;
- title-summary estimates for annual police-versus-librarian title-series comparisons when long-run person-level librarian panel scraping is not the chosen auditable design;
- no pooled nominal multi-year averaging of salaries;
- explicit cohort crosswalks, exclusion rules, source hierarchy, and caption-level source disclosure throughout the repository.
