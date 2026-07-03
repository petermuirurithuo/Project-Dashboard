# FemDigiNomics — Executive Insights Dashboard

An interactive R Shiny dashboard summarizing survey data on women's savings, income, and financial stress across Kenyan counties. Built with `bs4Dash` and a custom navy and gold executive theme, following inverted-pyramid layout principles (KPIs first, trend charts second, no raw data dump).

## Overview

The dashboard answers six core questions at a glance:

- How many respondents are in the current filtered view
- Median monthly income by income source
- Percentage of respondents in a savings group
- Percentage with mobile money access
- Percentage reporting high financial stress (score 4 or 5 of 5)
- Mean unpaid care hours per day

Four supporting charts break these down by income source and stress level: income distribution, enterprise barriers, unpaid care burden, and financial stress distribution.

Filters for county and primary income source update every KPI and chart live.

## Data

`data/womens_survey_raw.csv` is a synthetic dataset of 312 respondents used for demonstration purposes. It is not real survey data.

Columns include county, primary income source, monthly income (KES), weekly savings (KES), care hours per day, health expense (KES), household size, financial stress score (1 to 5), savings group membership, mobile money access, smartphone access, and enterprise barrier reported.

## Requirements

- R 4.0 or later
- Packages: `shiny`, `bs4Dash`, `ggplot2`, `dplyr`, `scales`

The app installs any missing packages automatically on first run.

## Running the dashboard

### Option 1: Posit Cloud (recommended, no local setup)

1. Create a free account at [posit.cloud](https://posit.cloud)
2. Start a new RStudio project
3. Upload `app.R` and the `data/` folder, preserving the folder structure
4. Open `app.R` and click **Run App**

### Option 2: Local RStudio

1. Clone this repository
2. Open the project folder in RStudio
3. Run:

```r
shiny::runApp()
```

## Project structure

```
femdiginomics-dashboard/
├── app.R                          # Shiny dashboard application
├── data/
│   └── womens_survey_raw.csv      # Synthetic survey data (n = 312)
└── README.md
```

## Author

Peter Thuo Muiruri
Freelance Statistician and Data Analyst, Embu, Kenya
