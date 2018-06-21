context("es_attributes")

eml_path <- system.file("LeConte_meteo_metadata.xml", package = "emlspice")
eml <- read_eml(eml_path)
eml_attributes <- es_attributes(eml)

test_that("Tabular format matches EML", {
    objectNames <- eml_get(eml, "objectName") %>% paste(collapse = " ")
    attributeNames <- eml_get(eml, "attributeName") %>% paste(collapse = " ")
    
    expect_true(all(stringr::str_detect(objectNames, eml_attributes$fileName), 
                    na.rm = TRUE))
    expect_true(all(stringr::str_detect(attributeNames, eml_attributes$variableName), 
                    na.rm = TRUE))
    
    standardUnits <- eml_get(eml, "standardUnit")
    customUnits <- eml_get(eml, "customUnit")
    formatStrings <- eml_get(eml, "formatString")
    unitText <- paste(standardUnits, customUnits, formatStrings, collapse = " ")
    
    expect_true(all(stringr::str_detect(unitText, eml_attributes$unitText), 
                    na.rm = TRUE))
    
    #description = description + missing vals
})

#additional tests:
#units match defintions/etc
#entity names match attributes