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
        x %>% 
            unlist() %>% 
            tibble::enframe() %>% 
            dplyr::mutate(name = dplyr::case_when(
                grepl("objectName", name) ~ "fileName",
                grepl("entityName", name) ~ "name",
                grepl("url", name) ~ "contentUrl",
                grepl("formatName", name) ~ "fileFormat"
            )) %>% 
            na.omit() %>% 
            filter(value != "download") %>% #often also included as url
            spread(name, value)
    }

    entities <- c("dataTable", "spatialRaster", "spatialVector", "storedProcedure", "view", "otherEntity")
    entities <- entities[entities %in% names(eml$dataset)]
    
    entity_objs <- purrr::map(entities, ~eml2::eml_get(eml, .x)) %>% 
        # restructure so that all entities are at the same level
        purrr::map_if(~!is.null(.x$entityName), list) %>% 
        unlist(recursive = FALSE) 
    
    access_entities <- lapply(entity_objs, get_access_spice)
    
    out <- dplyr::bind_rows(access_entities)
    
    #reorder
    out <- out[, c("fileName", "name", "contentUrl", "fileFormat")]
    
    return(out)
    
    if(!is.null(path)){
        readr::write_csv(out, path = path)
    }
}
