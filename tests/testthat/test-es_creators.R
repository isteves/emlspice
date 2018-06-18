context("es_creators")

eml_path <- system.file("LeConte_meteo_metadata.xml", package = "emlspice")
eml <- read_eml(eml_path)
eml_creators <- es_creators(eml)

test_that("Fields match", {
    orcids <-  eml_get(eml, "userId") %>% paste(collapse = " ")
    givenNames <- eml_get(eml, "givenName") %>% paste(collapse = " ")
    surNames <- eml_get(eml, "surName") %>% paste(collapse = " ")
    affiliations <- eml_get(eml, "organizationName") %>% paste(collapse = " ")
    emails <- eml_get(eml, "electronicMailAddress") %>% paste(collapse = " ")
    
    
    expect_true(all(stringr::str_detect(orcids, 
                                        eml_creators$id), 
                    na.rm = TRUE))
    
    expect_true(all(stringr::str_detect(givenNames, 
                                        eml_creators$givenName), 
                    na.rm = TRUE))
    
    expect_true(all(stringr::str_detect(surNames, 
                                        eml_creators$familyName), 
                    na.rm = TRUE))
    
    expect_true(all(stringr::str_detect(affiliations, 
                                        eml_creators$affiliation), 
                    na.rm = TRUE))
    
    expect_true(all(stringr::str_detect(emails, 
                                        eml_creators$email), 
                    na.rm = TRUE))
})
