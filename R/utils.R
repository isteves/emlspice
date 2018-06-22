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