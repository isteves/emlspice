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
    people <- list(creator = eml$dataset$creator,
                   contact = eml$dataset$contact,
                   metadataProvider = eml$dataset$metadataProvider,
                   associatedParty= eml$dataset$associatedParty) %>% 
        purrr::discard(function(x) {"references" %in% names(unlist(x))}) %>% 
        purrr::flatten()
    
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
            tidyr::spread(name, value)
    })
    
    creators_template <- dplyr::tibble(id = "NA", 
                                       givenName = "NA",
                                       familyName  = "NA",
                                       affiliation  = "NA",
                                       email = "NA")
    
    out <- dplyr::bind_rows(creators_template, people_parsed)[-1,]
    
    return(out)
    
    if(!is.null(path)){
        readr::write_csv(out, path = path)
    }
}
