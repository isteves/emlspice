get_attributes_spice <- function(x) {
    #reformat attributes to tabular format specified in dataspice
    #input a dataTable or otherEntity
    
    objName <- tryCatch(eml2::eml_get(x, "objectName")[[1]],
                        error = function(e){NA})
    
    attrList <- eml2::eml_get(x, "attributeList")

    if(length(attrList) == 0){
        out <- dplyr::tibble(fileName = objName,
                             variableName = NA,
                             description = NA,
                             unitText = NA)
    } else {
        attr <- eml2::get_attributes(attrList)
        
        #set datetime format as unit
        na_units <- is.na(attr$attributes$unit)
        attr$attributes$unit[na_units] <- attr$attributes$formatString[na_units]
        
        #get missing value info in text form:
        missing_val <- dplyr::tibble(missingValueCode = c(attr$attributes$missingValueCode, "NA"),
                                     missingValueCodeExplanation = c(attr$attributes$missingValueCodeExplanation, "something")) %>% 
            dplyr::distinct() %>% 
            stats::na.omit()
        
        missing_val_text <- paste(missing_val$missingValueCode, 
                                  missing_val$missingValueCodeExplanation, 
                                  sep = " = ",
                                  collapse = "; ")
        
        out <- dplyr::tibble(fileName = objName,
                             variableName = attr$attributes$attributeName,
                             description = paste0(attr$attributes$attributeDefinition,
                                                  "; missing values: ", missing_val_text),
                             unitText = attr$attributes$unit)
    }
    
    return(out)
}

#' Get attributes from EML
#' 
#' Return EML attributes in the dataspice attributes.csv format.
#'
#' @param eml (emld) an EML object
#' @param path (character) file path for saving the table to disk
#'
#' @export
#' 
#' @import dplyr
#' @importFrom readr write_csv
#'
#' @examples
#' \dontrun{
#' eml_path <- system.file("LeConte_meteo_metadata.xml", package = "emlspice")
#' eml <- read_eml(eml_path)
#' es_attributes(eml)
#' }

es_attributes <- function(eml, path = NULL) {
    entities <- get_entities(eml)
    attrTables <- lapply(entities, get_attributes_spice)
    
    out <- dplyr::bind_rows(attrTables) %>% 
        filter(!is.na(variableName))
    
    return(out)
    
    if(!is.null(path)){
        readr::write_csv(out, path = path)
    }
}
