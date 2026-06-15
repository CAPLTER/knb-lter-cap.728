if (file.exists("annotations.yaml")) {
  file.remove("annotations.yaml")
}

if (file.exists("custom_units.yaml")) {
  file.remove("custom_units.yaml")
}

install.packages("rdflib", repos = "http://cran.r-project.org")
install.packages("EDIutils", repos = "http://cran.r-project.org")

devtools::load_all("/scratch/srearl/capeml/")
devtools::load_all("/scratch/srearl/capemlGIS/")

source("process_rasters.R")

dataset <- readxl::read_excel(
  path  = "metadata_mrt_2023.xlsx",
  sheet = "dataset"
)

coverage <- EML::set_coverage(
  begin                 = "2023-07-19",
  end                   = "2023-07-19",
  geographicDescription = capeml::read_package_configuration()[["geographic_description"]],
  west                  = dataset[dataset$metadata_field == "west",  ]$metadata,
  east                  = dataset[dataset$metadata_field == "east",  ]$metadata,
  north                 = dataset[dataset$metadata_field == "north", ]$metadata,
  south                 = dataset[dataset$metadata_field == "south", ]$metadata
)

dataset <- capeml::create_dataset()
eml     <- capeml::create_eml()

EML::eml_validate(eml)
capeml::write_cap_eml()
