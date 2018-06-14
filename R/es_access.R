#' Get access from EML
#' 
#' Return EML access in the dataspice access.csv format.
#'
#' @param eml (emld) an EML object
#' @param path (character) file path for saving the table to disk
#'
#' @export
#'
#' @examples
#' \dontrun{
#' eml_path <- system.file("LeConte_meteo_metadata.xml", package = "emlspice")
#' eml <- read_eml(eml_path)
#' es_access(eml)
#' }

es_access <- function(eml, path = NULL) {
    get_access_spice <- function(x){
        dplyr::tibble(fileName = x$physical$objectName,
               name = x$entityName,
               contentUrl = x$physical$distribution$online$url$url,
               fileFormat = x$physical$dataFormat$externallyDefinedFormat$formatName)
    }
    
    access_dt <- lapply(eml$dataset$dataTable, get_access_spice)
    access_oe <- lapply(eml$dataset$otherEntity, get_access_spice)
    
    out <- dplyr::bind_rows(access_dt, access_oe)
    
    return(out)
    
    if(!is.null(path)){
        readr::write_csv(out, path)
    }
}