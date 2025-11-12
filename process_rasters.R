
devtools::load_all("/scratch/srearl/capeml/")
devtools::load_all("/scratch/srearl/capemlGIS/")
source("/home/srearl/aws.s3")

sub_path <- "/scratch/srearl/Maricopa_MRT_2023"

process_raster <- function(filename) {

  fileBasename <- basename(tools::file_path_sans_ext(filename))
  hour         <- stringr::str_split(fileBasename, "_")[[1]][[3]]
  region       <- stringr::str_split(fileBasename, "_")[[1]][[4]]
  # region <- stringr::str_extract(stringr::str_split("mcp_2024-06-06_0700_west.tif", "_")[[1]][[4]], "^[A-z]+")

  rasterDesc <- glue::glue(
    "Hourly Mean Radiant Temperature Distribution on a summer day (2023-07-19), Maricopa County, Arizona (USA): {region} region at {hour}"
  )

  eml_raster <- capemlGIS::create_raster(
    raster_file              = filename,
    description              = rasterDesc,
    epsg                     = 3857,
    raster_value_description = "Mean Radiant Temperature",
    raster_value_units       = "DEG_C",
    geographic_description   = "central Arizona, USA",
    project_naming           = FALSE
  )

  assign(
    # x     = paste0(fileBasename, "_SR"),
    x     = paste0(region, "_", hour, "_SR"),
    value = eml_raster,
    envir = .GlobalEnv
  )

  EML::write_eml(
    eml  = get(paste0(region, "_", hour, "_SR")),
    file = paste0("/scratch/srearl/sr_2023", region, "_", hour, ".xml")
  )

  capeml::data_to_amz(filename)

}

list_of_rasters <- list.files(
  path       = sub_path,
  pattern    = "\\.tif$",
  full.names = TRUE,
  recursive  = TRUE
)

purrr::walk(list_of_rasters, process_raster)
