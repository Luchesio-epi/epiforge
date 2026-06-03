# epiforge <img src="man/figures/logo.png" align="right" height="139" alt="" />

<!-- badges: start -->
![Version](https://img.shields.io/badge/version-0.1.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![R](https://img.shields.io/badge/R-%3E%3D4.0-informational)
<!-- badges: end -->

> **Automatic epidemiological surveillance report generator**

`epiforge` turns routine health surveillance data into professional Word or PDF bulletins in a single R command. Designed for public health practitioners in low- and middle-income countries, with full compatibility with DHIS2 data exports.

---

## Installation

```r
# Install from GitHub
remotes::install_github("Luchesio-epi/epiforge")
```

---

## Quick Start

```r
library(epiforge)

# 1. Import data (CSV or Excel / DHIS2 export)
raw <- epi_import("surveillance_data.csv")

# 2. Standardize columns
data <- epi_clean(raw,
                  date_col    = "date",
                  cases_col   = "cases",
                  disease_col = "disease",
                  geo_col     = "location")

# 3. Compute indicators (incidence, CFR...)
indicators <- epi_indicators(data,
                              population = 150000,
                              deaths_col = "deaths",
                              period     = "weekly")

# 4. Generate the bulletin (Word or PDF)
epi_report(data,
           indicators,
           period        = "weekly",
           output_format = "docx",
           output_file   = "weekly_bulletin.docx",
           title         = "Weekly Surveillance Bulletin",
           location_name = "District X")
```

---

## What the bulletin contains

Each generated report includes:

- **Executive summary** — key figures at a glance
- **Case summary by disease** — total cases, deaths, CFR
- **Epidemic curves** — ggplot2 charts by disease and period
- **Weekly/monthly indicators** — incidence per 100,000, CFR
- **Automatic alerts** — flags diseases with CFR above threshold
- **Recommendations** — standard public health actions

---

## Core functions

| Function | Description |
|---|---|
| `epi_import()` | Read CSV or Excel files (DHIS2-compatible) |
| `epi_clean()` | Standardize column names and date formats |
| `epi_indicators()` | Compute cases, incidence, deaths, CFR |
| `epi_curve()` | Plot epidemic curves (ggplot2) |
| `epi_report()` | Generate Word (.docx) or PDF bulletin |

---

## Example dataset

```r
data(epiforge_example)
head(epiforge_example)
#>         date  disease   location cases deaths
#> 1 2024-01-01  Cholera District A    45      1
#> 2 2024-01-01  Cholera District B   112      2
#> 3 2024-01-01  Cholera District C    78      0
```

The built-in dataset simulates weekly surveillance data for 3 diseases across 4 districts over 12 weeks.

---

## Supported input formats

- **CSV** — standard export from DHIS2, Excel, REDCap
- **Excel** (.xlsx, .xls) — DHIS2 exports, national registers

## Supported output formats

- **Word** (.docx) — for sharing via email or WhatsApp
- **PDF** — for archiving and official submission

---

## Geographic levels

`epiforge` supports any geographic level via the `geo_level` parameter:

```r
epi_indicators(data, geo_level = "district")   # default
epi_indicators(data, geo_level = "region")
epi_indicators(data, geo_level = "national")
```

---

## Report periods

```r
epi_report(data, ind, period = "weekly")   # epidemiological weeks
epi_report(data, ind, period = "monthly")  # calendar months
```

---

## Requirements

- R >= 4.0
- Packages: `readr`, `readxl`, `dplyr`, `tidyr`, `ggplot2`, `officer`, `flextable`, `rmarkdown`, `lubridate`, `glue`, `cli`

All dependencies are installed automatically with `remotes::install_github()`.

---

## Roadmap

- [x] v0.1.0 — Core pipeline, weekly bulletin, Word/PDF output
- [ ] v0.2.0 — Monthly bulletin template, threshold-based alerts
- [ ] v0.3.0 — DHIS2 direct API connection (`dhis2R`)
- [ ] v1.0.0 — CRAN submission

---

## License

MIT © 2024 Luchesio-epi

---

## Citation

```r
citation("epiforge")
```

> Luchesio-epi (2024). *epiforge: Automatic Epidemiological Report Generator*. R package version 0.1.0. https://github.com/Luchesio-epi/epiforge
