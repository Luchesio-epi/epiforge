library(devtools)
load_all("C:/Users/CyrDa/Downloads/epiforge_v0.1.0_structure/epiforge")

epi_report(
  data          = df_clean,
  indicators    = df_ind,
  period        = "weekly",
  output_format = "docx",
  output_file   = "C:/Users/CyrDa/Desktop/bulletin_test.docx",
  title         = "Weekly Surveillance Bulletin",
  location_name = "District A"
)