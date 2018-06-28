get_entities <- function(eml, 
                         entities = c("dataTable", "spatialRaster", "spatialVector", "storedProcedure", "view", "otherEntity"),
                         level_id = "entityName"){
    entities <- entities[entities %in% names(eml$dataset)]
    
    #look for specific fields to determine if the entity needs to be listed ("boxed") or not
    level_cond <- paste0("~", paste(sprintf("!is.null(.x$%s)", level_id), collapse = " | "))
    purrr::map(entities, ~eml2::eml_get(eml, .x)) %>% 
        # restructure so that all entities are at the same level
        # use level id to determine if .x should be listed or not
        purrr::map_if(eval(parse(text = level_cond)), list) %>% 
        unlist(recursive = FALSE) 
}

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
#' @param path (character) folder path for saving the table to disk
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
    
    if(!is.null(path)){
        if(!dir.exists(path)){
            dir.create(path)
        }
        readr::write_csv(out, file.path(path, "access.csv"))
    }
    
    return(out)
}
