install.packages("rdflib", repos = "http://cran.r-project.org")
install.packages("EDIutils", repos = "http://cran.r-project.org")
install.packages("parallel", repos = "http://cran.r-project.org")

devtools::load_all("/scratch/srearl/capeml/")
source("/home/srearl/aws.s3")

sub_path <- "/scratch/srearl/Maricopa_MRT_2023"

process_raster <- function(filename) {

  # fileBasename <- basename(tools::file_path_sans_ext(filename))
  # hour         <- stringr::str_split(fileBasename, "_")[[1]][[3]]
  # region       <- stringr::str_split(fileBasename, "_")[[1]][[4]]
  # region <- stringr::str_extract(stringr::str_split("mcp_2024-06-06_0700_west.tif", "_")[[1]][[4]], "^[A-z]+")

  # rasterDesc <- glue::glue(
  #   "Hourly Mean Radiant Temperature Distribution on a summer day (2023-07-19), Maricopa County, Arizona (USA): {region} region at {hour}"
  # )

  # eml_raster <- capemlGIS::create_raster(
  #   raster_file              = filename,
  #   description              = rasterDesc,
  #   epsg                     = 3857,
  #   raster_value_description = "Mean Radiant Temperature",
  #   raster_value_units       = "DEG_C",
  #   geographic_description   = "central Arizona, USA",
  #   project_naming           = FALSE
  # )

  # assign(
  #   # x     = paste0(fileBasename, "_SR"),
  #   x     = paste0(region, "_", hour, "_SR"),
  #   value = eml_raster,
  #   envir = .GlobalEnv
  # )

  # EML::write_eml(
  #   eml  = get(paste0(region, "_", hour, "_SR")),
  #   file = paste0("/scratch/srearl/sr_2023/", region, "_", hour, ".xml")
  # )

  capeml::data_to_amz(filename)

}

list_of_rasters <- list.files(
  path       = sub_path,
  pattern    = "\\.tif$",
  full.names = TRUE,
  recursive  = TRUE
)

# purrr::walk(list_of_rasters, process_raster)

# determine the number of cores allocated by SLURM
# default to 1 if the environment variable is not set
num_cores <- as.integer(Sys.getenv("SLURM_CPUS_PER_TASK", 1))
cat(paste("Found", length(list_of_rasters), "files. Using", num_cores, "cores for upload.\n"))

# mclapply is a good choice for single-node parallel tasks on Linux-based HPCs
if (length(list_of_rasters) > 0) {
  parallel::mclapply(
    X        = list_of_rasters,
    FUN      = data_to_amz,
    mc.cores = num_cores
  )
}
