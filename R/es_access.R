get_access_spice <- function(x){
    x %>% 
        unlist() %>% 
        tibble::enframe() %>% 
        dplyr::mutate(name = dplyr::case_when(
            grepl("objectName", name) ~ "fileName",
            grepl("entityName", name) ~ "name",
            grepl("url", name) ~ "contentUrl",
            grepl("formatName", name) ~ "fileFormat"
        )) %>% 
        stats::na.omit() %>% 
        filter(value != "download") %>% #often also included as url
        tidyr::spread(name, value)
}

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
    entities <- get_entities(eml)
    access_entities <- lapply(entities, get_access_spice)
    
    out <- dplyr::bind_rows(access_entities)
    
    #reorder
    fields <- c("fileName", "name", "contentUrl", "fileFormat")
    out <- out[, fields[fields %in% colnames(out)]]
    
    return(out)
    
    if(!is.null(path)){
        readr::write_csv(out, path = path)
    }
}
