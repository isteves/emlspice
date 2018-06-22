context("es_access")

eml_path <- system.file("LeConte_meteo_metadata.xml", package = "emlspice")
eml <- eml2::read_eml(eml_path)
eml_access <- es_access(eml)

test_that("Tabular format matches EML", {
    objectNames <- eml_get(eml, "objectName") %>% paste(collapse = " ")
    urls <- eml_get(eml, "url") %>% paste(collapse = " ")
    formatNames <- eml_get(eml, "formatName") %>% paste(collapse = " ")
    
    expect_true(all(stringr::str_detect(objectNames, eml_access$fileName), 
                    na.rm = TRUE))
    expect_true(all(stringr::str_detect(urls, eml_access$contentUrl), 
                    na.rm = TRUE))
    expect_true(all(stringr::str_detect(formatNames, eml_access$fileFormat), 
                    na.rm = TRUE))
})
