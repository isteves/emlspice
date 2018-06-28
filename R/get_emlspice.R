#' Get dataspice tabular formats from EML
#' 
#' Return EML in the dataspice dataframes.
#'
#' @param eml (emld) an EML object
#' @param path (character) folder path for saving the table to disk
#'
#' @export
#'
#' @examples
#' \dontrun{
#' eml_path <- system.file("LeConte_meteo_metadata.xml", package = "emlspice")
#' eml <- read_eml(eml_path)
#' get_emlspice(eml)
#' }

get_emlspice <- function(eml, path = NULL) {
    out <- list(attributes = es_attributes(eml, path),
                access = es_access(eml, path),
                biblio = es_biblio(eml, path),
                creators = es_creators(eml, path))
    
    invisible(out)
}