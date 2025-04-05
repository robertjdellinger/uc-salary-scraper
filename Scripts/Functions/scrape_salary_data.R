# scrape_salary_data.R
scrape_salary_data <- function(url) {
  b <<- ChromoteSession$new()
  b$Page$navigate(url)
  b$Page$loadEventFired()
  
  # Wait for the salary table to load
  start_time <- Sys.time()
  repeat {
    ready <- tryCatch({
      b$Runtime$evaluate("document.querySelector('table#main-listing') !== null")$result$value
    }, error = function(e) FALSE)
    
    if (isTRUE(ready)) break
    if (Sys.time() - start_time > 5) {
      warning("Timeout waiting for table to load")
      break
    }
    Sys.sleep(0.2)
  }
  
  get_salary_table <- function() {
    result <- tryCatch({
      b$Runtime$evaluate("document.querySelector('table#main-listing')?.outerHTML")$result$value
    }, error = function(e) NULL)
    
    if (is.null(result)) return(NULL)
    page <- read_html(result)
    html_table(page, fill = TRUE)
  }
  
  all_pages <- list()
  page_number <- 1
  
  repeat {
    cat("Scraping page:", page_number, "\n")
    
    # Wait again in case of navigation delay
    start_time <- Sys.time()
    repeat {
      ready <- tryCatch({
        b$Runtime$evaluate("document.querySelector('table#main-listing') !== null")$result$value
      }, error = function(e) FALSE)
      
      if (isTRUE(ready)) break
      if (Sys.time() - start_time > 5) {
        warning("Timeout waiting for table to load")
        break
      }
      Sys.sleep(0.2)
    }
    
    all_pages[[page_number]] <- get_salary_table()
    
    # Check if "Next" button exists
    next_exists <- b$Runtime$evaluate(
      "document.querySelector('.pagination .next a') !== null"
    )$result$value
    
    if (!isTRUE(next_exists)) {
      cat("No next button found — ending scrape.\n")
      break
    }
    
    # Click Next
    b$Runtime$evaluate("document.querySelector('.pagination .next a')?.click()")
    page_number <- page_number + 1
  }
  
  bind_rows(Filter(Negate(is.null), all_pages))
}