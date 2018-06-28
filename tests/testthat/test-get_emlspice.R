context("get_emlspice")

eml_path <- system.file("LeConte_meteo_metadata.xml", package = "emlspice")
eml <- eml2::read_eml(eml_path)

test_that("Files write to disk", {
    dir_path <- tempdir()
    get_emlspice(eml, dir_path)
    
    files <- list.files(dir_path, 
                        pattern = "access|attributes|biblio|creators", 
                        full.names = TRUE)
    
    expect_true(any(grepl("access.csv", files)))
    expect_true(any(grepl("attributes.csv", files)))
    expect_true(any(grepl("biblio.csv", files)))
    expect_true(any(grepl("creators.csv", files)))
    
    file.remove(files)
})


test_that("get_emlspice returns a list of tibbles", {
    spice_ex <- get_emlspice(eml)
    
    expect_equal(length(spice_ex), 4)
    
    tbl_lgl <- spice_ex %>% purrr::map(class) %>% purrr::map(~"tbl" %in% .)
    expect_true(all(unlist(tbl_lgl)))
})
