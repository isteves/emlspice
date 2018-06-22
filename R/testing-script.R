library(emlspice)

cn <- dataone::CNode('PROD')
mn <- dataone::getMNode(cn,'urn:node:ARCTIC')

#try different metadata pids here
pid <- "doi:10.5063/F13B5XBC"

eml <- EML::read_eml(dataone::getObject(cn, pid))
EML::write_eml(eml, "metadata.xml")
eml <- eml2::read_eml("metadata.xml")

es_access(eml)
es_biblio(eml)
es_attributes(eml)
es_creators(eml)
