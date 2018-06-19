set_attributes
set_coverage
set_methods
set_physical
set_responsibleParty

eml_attributes
x <- eml_attributes %>% filter(fileName == "campbell_data60.csv")
lapply(x$unitText, get_unit_id)
units #match to dictionary
formatString <- str_extract(x$unitText, "[MDYhms:-]{3,}")

tibble(attributeName = x$variableName,
       attributeDefinition = x$description,
       formatString = ,
       definition = ,
       unit = ,
       numberType = "real")


eml_validate