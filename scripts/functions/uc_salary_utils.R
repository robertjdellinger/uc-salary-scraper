uc_salary_find_project_root <- function() {
  candidate_dirs <- c(".", "..", "../..")

  for (candidate_dir in candidate_dirs) {
    candidate_path <- normalizePath(candidate_dir, winslash = "/", mustWork = FALSE)

    if (file.exists(file.path(candidate_path, "uc-salary-scraper.Rproj"))) {
      return(candidate_path)
    }
  }

  stop("Could not locate the project root.")
}

uc_salary_project_root <- uc_salary_find_project_root()
uc_salary_local_library <- file.path(uc_salary_project_root, ".Rlib")
uc_salary_cache_version <- "2026-03-31-parser-v2"

if (dir.exists(uc_salary_local_library)) {
  .libPaths(c(uc_salary_local_library, .libPaths()))
}

uc_salary_load_packages <- function() {
  required_packages <- c(
    "dplyr",
    "ggplot2",
    "glue",
    "janitor",
    "knitr",
    "purrr",
    "readr",
    "rvest",
    "scales",
    "stringr",
    "tibble",
    "tidyr",
    "xml2"
  )

  missing_packages <- required_packages[!vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)]

  if (length(missing_packages) > 0) {
    stop(
      "The following packages are required but not installed: ",
      paste(missing_packages, collapse = ", "),
      "."
    )
  }

  invisible(
    suppressPackageStartupMessages(
      lapply(required_packages, library, character.only = TRUE)
    )
  )
}

uc_salary_path <- function(...) {
  file.path(uc_salary_project_root, ...)
}

uc_salary_relpath <- function(path) {
  project_root <- normalizePath(uc_salary_project_root, winslash = "/", mustWork = FALSE)
  project_root_prefix <- paste0(project_root, "/")

  vapply(
    as.character(path),
    function(one_path) {
      if (is.na(one_path) || identical(one_path, "")) {
        return(NA_character_)
      }

      normalized_path <- normalizePath(one_path, winslash = "/", mustWork = FALSE)

      if (identical(normalized_path, project_root)) {
        return(".")
      }

      if (startsWith(normalized_path, project_root_prefix)) {
        return(substring(normalized_path, nchar(project_root_prefix) + 1L))
      }

      normalized_path
    },
    character(1)
  )
}

uc_salary_ensure_directory <- function(path) {
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  invisible(path)
}

uc_salary_wrap_text <- function(text, width = 100) {
  if (is.null(text) || length(text) == 0) {
    return(text)
  }

  vapply(
    text,
    function(one_text) {
      if (is.na(one_text) || !nzchar(one_text)) {
        return(one_text)
      }

      stringr::str_wrap(one_text, width = width)
    },
    character(1)
  )
}

uc_salary_cache_is_current <- function(data_frame) {
  "cache_version" %in% names(data_frame) &&
    length(stats::na.omit(unique(data_frame$cache_version))) == 1 &&
    unique(stats::na.omit(data_frame$cache_version)) == uc_salary_cache_version
}

uc_salary_normalize_title <- function(x) {
  x %>%
    stringr::str_replace_all("&AMP;", "&") %>%
    stringr::str_replace_all("[_]+", " ") %>%
    stringr::str_replace_all("[[:space:]]+", " ") %>%
    stringr::str_trim() %>%
    stringr::str_to_upper()
}

uc_salary_normalize_name <- function(x) {
  x %>%
    stringr::str_replace_all("[[:space:]]+", " ") %>%
    stringr::str_trim() %>%
    stringr::str_to_upper()
}

uc_salary_parse_currency <- function(x) {
  cleaned_x <- as.character(x)
  cleaned_x <- stringr::str_trim(cleaned_x)
  cleaned_x <- stringr::str_replace_all(cleaned_x, "^\\((.*)\\)$", "-\\1")
  cleaned_x <- stringr::str_replace_all(cleaned_x, "\\$", "")
  cleaned_x <- stringr::str_replace_all(cleaned_x, ",", "")

  cleaned_x[cleaned_x %in% c("", "NA", "N/A", "NULL")] <- NA_character_

  suppressWarnings(as.numeric(cleaned_x))
}

uc_salary_read_title_reference <- function() {
  readr::read_csv(
    uc_salary_path("data", "raw", "uc_reference", "uc_academic_title_reference.csv"),
    show_col_types = FALSE
  ) %>%
    janitor::clean_names() %>%
    dplyr::mutate(
      title_job_code = stringr::str_pad(as.character(title_job_code), width = 4, side = "left", pad = "0"),
      title_job_descr = uc_salary_normalize_title(title_job_descr),
      cto_name = stringr::str_to_upper(cto_name)
    )
}

uc_salary_read_query_registry <- function() {
  readr::read_csv(
    uc_salary_path("data", "raw", "uc_reference", "uc_salary_query_registry.csv"),
    show_col_types = FALSE
  ) %>%
    dplyr::mutate(
      analysis_year = as.integer(analysis_year),
      priority = as.integer(priority)
    ) %>%
    dplyr::arrange(priority)
}

uc_salary_get_agency_year_status <- function(agency_slug = "university-of-california") {
  agency_url <- glue::glue("https://transparentcalifornia.com/salaries/{agency_slug}/")
  document <- uc_salary_read_html_with_retry(agency_url)

  page_heading <- rvest::html_text2(rvest::html_element(document, "h1"))
  page_year_values <- stringr::str_extract_all(page_heading, "\\b20\\d{2}\\b")[[1]]
  page_year <- max(as.integer(page_year_values), na.rm = TRUE)
  body_text <- rvest::html_text2(rvest::html_element(document, "body"))

  if (!is.finite(page_year)) {
    stop("Could not parse the current Transparent California page year for agency slug: ", agency_slug)
  }

  data_collection_in_progress <- stringr::str_detect(
    body_text,
    stringr::regex(
      paste0(page_year, "\\s+Data Collection in Progress|Data Collection in Progress"),
      ignore_case = TRUE
    )
  )

  latest_complete_year <- if (isTRUE(data_collection_in_progress)) {
    as.integer(page_year - 1L)
  } else {
    as.integer(page_year)
  }

  tibble::tibble(
    agency_slug = agency_slug,
    agency_url = agency_url,
    current_page_year = as.integer(page_year),
    data_collection_in_progress = data_collection_in_progress,
    latest_complete_year = latest_complete_year,
    status_note = dplyr::if_else(
      data_collection_in_progress,
      paste0(
        "Transparent California marks ",
        page_year,
        " data collection as in progress, so the latest available page year remains ",
        page_year,
        " while ",
        latest_complete_year,
        " is the most recent UC year not marked in progress."
      ),
      paste0(
        "Transparent California does not mark ",
        page_year,
        " as in progress, so it serves as both the latest available page year and the most recent UC year not marked in progress."
      )
    ),
    checked_at_utc = format(Sys.time(), tz = "UTC", usetz = TRUE)
  )
}

uc_salary_build_search_url <- function(search_term, year, page = 1, agency_slug = "university-of-california") {
  encoded_query <- utils::URLencode(search_term, reserved = TRUE)
  glue::glue("https://transparentcalifornia.com/salaries/search/?a={agency_slug}&q={encoded_query}&y={year}&page={page}")
}

uc_salary_build_job_title_summary_url <- function(year, page = 1, agency_slug = "university-of-california") {
  base_url <- glue::glue("https://transparentcalifornia.com/salaries/{year}/{agency_slug}/job_title_summary/")

  if (page <= 1) {
    return(base_url)
  }

  paste0(base_url, "?page=", page)
}

uc_salary_read_html_with_retry <- function(url, attempts = 6, quiet = FALSE) {
  last_error <- NULL
  options(timeout = max(300, getOption("timeout")))

  for (attempt in seq_len(attempts)) {
    result <- tryCatch(
      {
        temporary_html <- tempfile(fileext = ".html")
        on.exit(unlink(temporary_html), add = TRUE)
        utils::download.file(url = url, destfile = temporary_html, quiet = TRUE, mode = "wb")
        xml2::read_html(temporary_html)
      },
      error = function(error) {
        last_error <<- error
        NULL
      }
    )

    if (!is.null(result)) {
      return(result)
    }

    Sys.sleep(attempt * 1.5)
  }

  if (!quiet) {
    message("Failed to read URL after ", attempts, " attempts: ", url)
  }

  stop(last_error)
}

uc_salary_parse_page_metadata <- function(document, fallback_rows = NA_integer_) {
  subtitle_node <- rvest::html_element(document, ".page_subtitle")

  if (inherits(subtitle_node, "xml_missing")) {
    return(tibble::tibble(total_records = fallback_rows, total_pages = 1L, subtitle_text = NA_character_))
  }

  subtitle_text <- rvest::html_text2(subtitle_node)

  tibble::tibble(
    total_records = readr::parse_number(subtitle_text),
    total_pages = dplyr::if_else(
      stringr::str_detect(subtitle_text, "Page"),
      readr::parse_number(stringr::str_extract(subtitle_text, "of\\s+[0-9,]+")),
      1
    ),
    subtitle_text = subtitle_text
  )
}

uc_salary_parse_pagination_total_pages <- function(document) {
  heading_text <- rvest::html_text2(rvest::html_element(document, "h3"))
  heading_total_pages <- readr::parse_number(stringr::str_extract(heading_text, "of\\s+[0-9,]+"))

  pagination_links <- rvest::html_elements(document, "a[href*='page=']")
  pagination_hrefs <- rvest::html_attr(pagination_links, "href")
  link_total_pages <- readr::parse_number(stringr::str_extract(pagination_hrefs, "page=[0-9,]+"))

  total_page_candidates <- c(heading_total_pages, link_total_pages, 1)
  total_page_candidates <- total_page_candidates[is.finite(total_page_candidates)]

  if (length(total_page_candidates) == 0) {
    return(1L)
  }

  as.integer(max(total_page_candidates))
}

uc_salary_extract_job_title_summary_note <- function(document) {
  body_text <- rvest::html_text2(rvest::html_element(document, "body"))

  stringr::str_extract(
    body_text,
    "Note:\\s+The averages are designed to capture only those who have worked a full year, and excludes those who worked on a part-time, seasonal, or partial-year basis\\."
  )
}

uc_salary_scrape_search_page <- function(search_term, year, page = 1, pause_seconds = 0.20, verbose = TRUE) {
  url <- uc_salary_build_search_url(search_term = search_term, year = year, page = page)

  if (verbose) {
    message(glue::glue("Scraping `{search_term}` ({year}) page {page}: {url}"))
  }

  Sys.sleep(pause_seconds)

  document <- uc_salary_read_html_with_retry(url)
  table_node <- rvest::html_element(document, "table#main-listing")

  if (inherits(table_node, "xml_missing")) {
    stop("Transparent California search page did not return a salary table for URL: ", url)
  }

  page_table <- rvest::html_table(table_node, convert = FALSE) %>%
    tibble::as_tibble()

  page_metadata <- uc_salary_parse_page_metadata(document = document, fallback_rows = nrow(page_table))

  page_table %>%
    dplyr::mutate(
      source_search_term = search_term,
      source_year = as.integer(year),
      source_page = as.integer(page),
      source_total_pages = page_metadata$total_pages[[1]],
      source_total_records = page_metadata$total_records[[1]],
      source_subtitle_text = page_metadata$subtitle_text[[1]],
      source_url = url,
      scraped_at_utc = format(Sys.time(), tz = "UTC", usetz = TRUE)
    )
}

uc_salary_scrape_query <- function(search_term, year, pause_seconds = 0.20, verbose = TRUE) {
  first_page <- uc_salary_scrape_search_page(search_term = search_term, year = year, page = 1, pause_seconds = pause_seconds, verbose = verbose)
  total_pages <- dplyr::coalesce(first_page$source_total_pages[[1]], 1L)

  if (total_pages <= 1) {
    return(first_page)
  }

  remaining_pages <- purrr::map_dfr(
    seq.int(2, total_pages),
    ~ uc_salary_scrape_search_page(search_term = search_term, year = year, page = .x, pause_seconds = pause_seconds, verbose = verbose)
  )

  dplyr::bind_rows(first_page, remaining_pages)
}

uc_salary_scrape_job_title_summary_page <- function(year, page = 1, agency_slug = "university-of-california", pause_seconds = 0.20, verbose = TRUE) {
  url <- uc_salary_build_job_title_summary_url(year = year, page = page, agency_slug = agency_slug)

  if (verbose) {
    message(glue::glue("Scraping job title summary ({year}) page {page}: {url}"))
  }

  Sys.sleep(pause_seconds)

  document <- uc_salary_read_html_with_retry(url)
  table_node <- rvest::html_element(document, "table")

  if (inherits(table_node, "xml_missing")) {
    stop("Transparent California job title summary page did not return a summary table for URL: ", url)
  }

  page_table <- rvest::html_table(table_node, convert = FALSE) %>%
    tibble::as_tibble() %>%
    janitor::clean_names()

  total_pages <- uc_salary_parse_pagination_total_pages(document)
  summary_note <- uc_salary_extract_job_title_summary_note(document)

  page_table %>%
    dplyr::mutate(
      year = as.integer(year),
      job_title = stringr::str_trim(job_title),
      job_title_clean = uc_salary_normalize_title(job_title),
      count = as.integer(uc_salary_parse_currency(count)),
      avg_regular_pay = uc_salary_parse_currency(avg_regular_pay),
      avg_overtime_pay = uc_salary_parse_currency(avg_overtime_pay),
      avg_other_pay = uc_salary_parse_currency(avg_other_pay),
      avg_total_pay = uc_salary_parse_currency(avg_total_pay),
      avg_benefits = uc_salary_parse_currency(avg_benefits),
      avg_total_pay_benefits = uc_salary_parse_currency(avg_total_pay_benefits),
      estimated_regular_pay = count * avg_regular_pay,
      estimated_overtime_pay = count * avg_overtime_pay,
      estimated_other_pay = count * avg_other_pay,
      estimated_total_pay = count * avg_total_pay,
      estimated_benefits = count * avg_benefits,
      estimated_total_pay_benefits = count * avg_total_pay_benefits,
      source_page = as.integer(page),
      source_total_pages = total_pages,
      source_url = url,
      source_note = summary_note,
      scraped_at_utc = format(Sys.time(), tz = "UTC", usetz = TRUE),
      cache_version = uc_salary_cache_version
    ) %>%
    dplyr::select(
      year,
      job_title,
      job_title_clean,
      count,
      avg_regular_pay,
      avg_overtime_pay,
      avg_other_pay,
      avg_total_pay,
      avg_benefits,
      avg_total_pay_benefits,
      estimated_regular_pay,
      estimated_overtime_pay,
      estimated_other_pay,
      estimated_total_pay,
      estimated_benefits,
      estimated_total_pay_benefits,
      source_page,
      source_total_pages,
      source_url,
      source_note,
      scraped_at_utc
      ,
      cache_version
    )
}

uc_salary_scrape_job_title_summary <- function(year, agency_slug = "university-of-california", pause_seconds = 0.20, verbose = TRUE) {
  first_page <- uc_salary_scrape_job_title_summary_page(
    year = year,
    page = 1,
    agency_slug = agency_slug,
    pause_seconds = pause_seconds,
    verbose = verbose
  )

  total_pages <- dplyr::coalesce(first_page$source_total_pages[[1]], 1L)

  if (total_pages <= 1) {
    return(first_page)
  }

  remaining_pages <- purrr::map_dfr(
    seq.int(2, total_pages),
    ~ uc_salary_scrape_job_title_summary_page(
      year = year,
      page = .x,
      agency_slug = agency_slug,
      pause_seconds = pause_seconds,
      verbose = verbose
    )
  )

  dplyr::bind_rows(first_page, remaining_pages)
}

uc_salary_clean_raw_extract <- function(raw_extract, query_slug) {
  normalized_extract <- raw_extract %>%
    janitor::clean_names()

  for (optional_column in c("notes", "agency", "status")) {
    if (!optional_column %in% names(normalized_extract)) {
      normalized_extract[[optional_column]] <- NA_character_
    }
  }

  normalized_extract %>%
    dplyr::mutate(
      employee_name = name,
      job_title = stringr::str_trim(
        stringr::str_remove(job_title, stringr::regex("University of California,\\s*\\d{4}$", ignore_case = TRUE))
      ),
      year = source_year,
      agency = dplyr::coalesce(as.character(agency), "University of California"),
      notes = as.character(notes),
      status = as.character(status),
      regular_pay = uc_salary_parse_currency(regular_pay),
      overtime_pay = uc_salary_parse_currency(overtime_pay),
      other_pay = uc_salary_parse_currency(other_pay),
      total_pay = uc_salary_parse_currency(total_pay),
      benefits = uc_salary_parse_currency(benefits),
      total_pay_benefits = uc_salary_parse_currency(total_pay_benefits),
      employee_name_clean = uc_salary_normalize_name(employee_name),
      job_title_clean = uc_salary_normalize_title(job_title),
      agency_clean = uc_salary_normalize_title(agency),
      query_slug = query_slug,
      cache_version = uc_salary_cache_version,
      title_contains_hcomp = stringr::str_detect(job_title_clean, "HCOMP"),
      title_contains_clinical = stringr::str_detect(job_title_clean, "CLIN"),
      overtime_share_of_total_pay = dplyr::if_else(total_pay > 0, overtime_pay / total_pay, NA_real_),
      other_pay_share_of_total_pay = dplyr::if_else(total_pay > 0, other_pay / total_pay, NA_real_),
      benefits_share_of_total_comp = dplyr::if_else(total_pay_benefits > 0, benefits / total_pay_benefits, NA_real_)
    ) %>%
    dplyr::select(
      employee_name,
      employee_name_clean,
      job_title,
      job_title_clean,
      year,
      regular_pay,
      overtime_pay,
      other_pay,
      total_pay,
      benefits,
      total_pay_benefits,
      notes,
      agency,
      agency_clean,
      status,
      source_search_term,
      source_year,
      source_page,
      source_total_pages,
      source_total_records,
      source_url,
      scraped_at_utc,
      query_slug,
      cache_version,
      title_contains_hcomp,
      title_contains_clinical,
      overtime_share_of_total_pay,
      other_pay_share_of_total_pay,
      benefits_share_of_total_comp
    )
}

uc_salary_assign_cohorts <- function(clean_data, query_registry) {
  candidate_rows <- purrr::pmap_dfr(
    query_registry,
    function(analysis_year, priority, query_slug, search_term, analysis_cohort, cohort_group, cohort_family, include_regex, exclude_regex, rationale) {
      cohort_rows <- clean_data %>%
        dplyr::filter(
          year == analysis_year,
          source_search_term == search_term,
          stringr::str_detect(job_title_clean, include_regex)
        )

      if (!is.na(exclude_regex) && nzchar(exclude_regex)) {
        cohort_rows <- cohort_rows %>%
          dplyr::filter(!stringr::str_detect(job_title_clean, exclude_regex))
      }

      cohort_rows %>%
        dplyr::mutate(
          priority = priority,
          analysis_cohort = analysis_cohort,
          cohort_group = cohort_group,
          cohort_family = cohort_family,
          cohort_rule_rationale = rationale
        )
    }
  )

  candidate_rows %>%
    dplyr::arrange(priority, employee_name_clean, job_title_clean, year) %>%
    dplyr::group_by(employee_name_clean, job_title_clean, year, agency_clean) %>%
    dplyr::slice(1) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(
      police_role_group = dplyr::case_when(
        cohort_group != "Police" ~ NA_character_,
        stringr::str_detect(job_title_clean, "CHF|CAPTAIN|LIEUTENANT|SERGEANT SUPV|SERGEANT") ~ "Police leadership and supervision",
        TRUE ~ "Police officers and other police titles"
      ),
      faculty_salary_structure = NA_character_
    )
}

uc_salary_join_title_reference <- function(analytic_data, title_reference) {
  analytic_data %>%
    dplyr::left_join(
      title_reference %>%
        dplyr::rename(
          uc_title_job_descr = title_job_descr,
          uc_title_job_code = title_job_code,
          uc_cto_name = cto_name
        ),
      by = c("job_title_clean" = "uc_title_job_descr")
    ) %>%
    dplyr::mutate(title_reference_match = !is.na(uc_title_job_code))
}

uc_salary_theme <- function() {
  ggplot2::theme_minimal(base_size = 14, base_family = "Georgia") +
    ggplot2::theme(
      plot.title = ggplot2::element_text(face = "bold", size = 17.5, colour = "#1F2933", margin = ggplot2::margin(b = 8)),
      plot.subtitle = ggplot2::element_text(size = 11.5, colour = "#52606D", lineheight = 1.15, margin = ggplot2::margin(b = 10)),
      plot.caption = ggplot2::element_text(size = 9.5, colour = "#52606D", hjust = 0, lineheight = 1.1, margin = ggplot2::margin(t = 12)),
      plot.caption.position = "plot",
      plot.title.position = "plot",
      axis.title = ggplot2::element_text(face = "bold", size = 12.2, colour = "#1F2933"),
      axis.text = ggplot2::element_text(size = 10.8, colour = "#243B53"),
      axis.text.x = ggplot2::element_text(margin = ggplot2::margin(t = 6)),
      axis.text.y = ggplot2::element_text(margin = ggplot2::margin(r = 6)),
      legend.title = ggplot2::element_text(face = "bold", colour = "#1F2933"),
      legend.text = ggplot2::element_text(colour = "#243B53"),
      legend.position = "bottom",
      legend.background = ggplot2::element_rect(fill = "transparent", colour = NA),
      legend.box.background = ggplot2::element_rect(fill = "transparent", colour = NA),
      legend.key = ggplot2::element_rect(fill = "transparent", colour = NA),
      legend.spacing.x = grid::unit(8, "pt"),
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.x = ggplot2::element_blank(),
      panel.grid.major.y = ggplot2::element_line(colour = "#D9E2EC", linewidth = 0.35),
      plot.background = ggplot2::element_rect(fill = "transparent", colour = NA),
      panel.background = ggplot2::element_rect(fill = "transparent", colour = NA),
      strip.background = ggplot2::element_rect(fill = "transparent", colour = NA),
      strip.text = ggplot2::element_text(face = "bold", colour = "#1F2933"),
      plot.margin = ggplot2::margin(16, 34, 20, 16)
    )
}

uc_salary_palette <- c(
  "Executive leadership" = "#8B1E3F",
  "Faculty and instruction" = "#0B6E4F",
  "Professor benchmarks" = "#0B6E4F",
  "Ladder-rank professor benchmarks" = "#0B6E4F",
  "Graduate workers" = "#33658A",
  "Postdoctoral scholars" = "#F26419",
  "Police" = "#3A506B",
  "Library workers" = "#6C757D"
)

uc_salary_save_plot <- function(plot_object, filename, width = 11.5, height = 7.5, dpi = 320) {
  output_path <- uc_salary_path("outputs", "figures", filename)
  uc_salary_ensure_directory(dirname(output_path))

  ggplot2::ggsave(
    filename = output_path,
    plot = plot_object,
    width = width,
    height = height,
    dpi = dpi,
    bg = "transparent"
  )

  invisible(output_path)
}
