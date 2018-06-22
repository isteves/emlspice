#' Get creators from EML
#' 
#' Return EML creators in the dataspice creators.csv format.
#'
#' @param eml (emld) an EML object
#' @param path (character) file path for saving the table to disk
#' 
#' @importFrom purrr discard
#' @importFrom purrr discard
#' @importFrom tibble enframe
#'
#' @export
#'
#' @examples
#' \dontrun{
#' eml_path <- system.file("LeConte_meteo_metadata.xml", package = "emlspice")
#' eml <- read_eml(eml_path)
#' es_creators(eml)
#' }

es_creators <- function(eml, path = NULL) {
    people <- get_entities(eml, 
                           entities = c("creator", "contact", "associatedParty", "metadataProvider"),
                           level_id = c("individualName", "organizationName"))
    if(!is.null(names(people))){
        people <- people[names(people) == ""]
    }

    people_parsed <- lapply(people, function(x){x %>% 
            unlist() %>% 
            tibble::enframe() %>% 
            dplyr::mutate(name = dplyr::case_when(
                grepl("userId.userId", name) ~ "id",
                grepl("givenName", name) ~ "givenName",
                grepl("surName", name) ~ "familyName",
                grepl("organizationName", name) ~ "affiliation",
                grepl("electronicMailAddress", name) ~ "email"
            )) %>% 
            stats::na.omit() %>%
            # merge fields together if duplicated (ex: givenName1 & givenName2)
            group_by(name) %>% 
            dplyr::summarize(value = paste(value, collapse = " ")) %>% 
            tidyr::spread(name, value)
    })
    
    out <- dplyr::bind_rows(people_parsed) %>% 
        dplyr::distinct()
    
    fields <- c("id", "givenName", "familyName", "affiliation", "email")
    out <- out[, fields[fields %in% colnames(out)]]
    
    return(out)
    
    if(!is.null(path)){
        readr::write_csv(out, path = path)
    }
}
