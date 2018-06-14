# emlspice
Functions for translating EML into [`dataspice`](https://github.com/ropenscilabs/dataspice) tabular formats

## Installation

```
devtools::install_github("isteves/dataspice")
```

## Example
```
library(emlspice)
library(eml2)

eml_path <- system.file("LeConte_meteo_metadata.xml", package = "emlspice")
eml <- read_eml(eml_path)
es_attributes(eml)
es_access(eml)
es_biblio(eml)
es_creators(eml)
```
