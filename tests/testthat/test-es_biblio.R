context("es_biblio")

eml_path <- system.file("LeConte_meteo_metadata.xml", package = "emlspice")
eml <- read_eml(eml_path)
eml_biblio <- es_biblio(eml)

test_that("Check that fields match up", {
    #title
    expect_equal(eml$dataset$title,
                 eml_biblio$title)
    
    #date published
    expect_equal(eml$dataset$pubDate,
                 eml_biblio$datePublished)
    
    #license/intellectual rights
    expect_equal(eml$dataset$intellectualRights[[1]],
                 eml_biblio$license)
    
    #funding/funder
    expect_equal(lapply(eml$dataset$project$funding[[1]], 
                        grepl, x = eml_biblio$funder) %>% unlist() %>% sum(),
                 eml$dataset$project$funding[[1]] %>% length())
    
    #geographic coverage
    expect_equal(eml$dataset$coverage$geographicCoverage$geographicDescription,
                 eml_biblio$geographicDescription)
    
    #check coordinates via sum instead of one-by-one
    expect_equal(eml$dataset$coverage$geographicCoverage$boundingCoordinates %>% 
                     unlist() %>% 
                     as.numeric() %>% 
                     sum(),
                 eml_biblio %>% 
                     select(contains("Coord")) %>% 
                     as.numeric() %>% 
                     sum())
    
    #temporal coverage
    expect_equal(eml$dataset$coverage$temporalCoverage$rangeOfDates$beginDate$calendarDate,
                 eml_biblio$startDate)
    expect_equal(eml$dataset$coverage$temporalCoverage$rangeOfDates$endDate$calendarDate,
                 eml_biblio$endDate)
})



