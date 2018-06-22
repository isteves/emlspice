#' Get biblio from EML
#' 
#' Return EML biblio in the dataspice biblio.csv format.
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
#' es_biblio(eml)
#' }

es_biblio <- function(eml, path = NULL) {
    biblio_eml <- eml %>% 
        unlist() %>% 
        tibble::enframe() %>% 
        dplyr::mutate(name = dplyr::case_when(
            grepl("dataset.title", name) ~ "title",
            grepl("abstract", name) ~ "description",
            grepl("pubDate", name) ~ "datePublished",
            grepl("packageId", name) ~ "identifier",
            grepl("keyword", name) ~ "keywords",
            grepl("intellectual", name) ~ "license",
            grepl("fund", name) ~ "funder",
            grepl("geographicDescription", name) ~ "geographicDescription",
            grepl("northBoundingCoordinate", name) ~ "northBoundCoord",
            grepl("eastBoundingCoordinate", name) ~ "eastBoundCoord",
            grepl("southBoundingCoordinate", name) ~ "southBoundCoord",
            grepl("westBoundingCoordinate", name) ~ "westBoundCoord",
            #wktString?
            grepl("beginDate|singleDateTime", name) ~ "startDate",
            grepl("endDate", name) ~ "endDate"
        )) %>% 
        stats::na.omit() %>% 
        dplyr::group_by(name) %>% 
        dplyr::summarize(value = paste(value, collapse = "; ")) %>% 
        tidyr::spread(name, value)

    #reorder 
    fields <- c("title", "description", "datePublished", "citation", "keywords", "license", "funder", "geographicDescription", "northBoundCoord", "eastBoundCoord", "southBoundCoord", "westBoundCoord", "wktString", "startDate", "endDate")
    
    
    out <- biblio_eml[, fields[fields %in% colnames(biblio_eml)]]
    
    return(out)
    
    if(!is.null(path)){
        readr::write_csv(out, path = path)
    }
}
