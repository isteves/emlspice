get_entities <- function(eml){
    entities <- c("dataTable", "spatialRaster", "spatialVector", "storedProcedure", "view", "otherEntity")
    entities <- entities[entities %in% names(eml$dataset)]
    
    purrr::map(entities, ~eml2::eml_get(eml, .x)) %>% 
        # restructure so that all entities are at the same level
        purrr::map_if(~!is.null(.x$entityName), list) %>% 
        unlist(recursive = FALSE) 
}
