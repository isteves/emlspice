
emlspice
========

Functions for translating EML into [`dataspice`](https://github.com/ropenscilabs/dataspice) tabular formats:

-   **attributes.csv** - explains each of the variables in the dataset
-   **biblio.csv** - for spatial and temporal coverage, dataset name, keywords, etc.
-   **access.csv** - for files and file types
-   **creators.csv** - for data authors

Installation
------------

``` r
devtools::install_github("isteves/dataspice")
```

Example
-------

``` r
library(emlspice)
library(eml2)

eml_path <- system.file("LeConte_meteo_metadata.xml", package = "emlspice")
eml <- read_eml(eml_path)
```

Currently, there are 4 functions in the package, which each take an `emld` object (using `eml2::read_eml` and translates it to the dataspice tables.

Here are the first few lines of each tabular format:

``` r
es_attributes(eml)
```

| fileName             | variableName  | description                                                                                                                                                                                                                               | unitText            |
|:---------------------|:--------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:--------------------|
| campbell\_data60.csv | id            | Row number; missing values: "" = station not operational; NA = something                                                                                                                                                                  | NA                  |
| campbell\_data60.csv | Time          | Time in UTC; Values reported always correspond to the subsequent time interval (e.g. 13:00 corresponds to the time interval 13:00 to 14:00 in the case of the hourly data).; missing values: "" = station not operational; NA = something | YYYY-MM-DD hh:mm:ss |
| campbell\_data60.csv | AirTC\_Avg    | Average air temperature in celsius; missing values: "" = station not operational; NA = something                                                                                                                                          | celsius             |
| campbell\_data60.csv | BP\_mmHg\_Avg | Average barometric pressure in mm Hg; missing values: "" = station not operational; NA = something                                                                                                                                        | millimetersMercury  |
| campbell\_data60.csv | BattV\_Avg    | Average battery voltage, should be &gt;12; missing values: "" = station not operational; NA = something                                                                                                                                   | volt                |
| campbell\_data60.csv | BattV\_Min    | Minimum battery voltage; missing values: "" = station not operational; NA = something                                                                                                                                                     | volt                |

``` r
es_access(eml)
```

| fileName             | name                 | contentUrl                                                                           | fileFormat |
|:---------------------|:---------------------|:-------------------------------------------------------------------------------------|:-----------|
| campbell\_data60.csv | campbell\_data60.csv | <https://cn.dataone.org/cn/v2/resolve/urn:uuid:cd9f09f0-04b6-4acf-aa4a-49ae438b99e5> | text/csv   |
| campbell\_data15.csv | campbell\_data15.csv | <https://cn.dataone.org/cn/v2/resolve/urn:uuid:ee590dc8-0c24-4cb4-85ad-647214f41753> | text/csv   |
| hobo\_climate.csv    | hobo\_climate.csv    | <https://cn.dataone.org/cn/v2/resolve/urn:uuid:087bf762-ea3d-444f-ba59-1c0bc02fd415> | text/csv   |

``` r
es_biblio(eml)
```

| title                                                 | description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | datePublished | citation | keywords | license                                                                                                                                                                     | funder | geographicDescription   | northBoundCoord | eastBoundCoord | southBoundCoord | westBoundCoord | wktString | startDate  | endDate    | identifier            |
|:------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:--------------|:---------|:---------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------|:------------------------|:----------------|:---------------|:----------------|:---------------|:----------|:-----------|:-----------|:----------------------|
| LeConte Glacier meteorological data 2016-2017, Alaska | In 2016-2017 we conducted a field study at LeConte Glacier, Alaska, to study the impacts of subglacial discharge on plume dynamics and submarine melting. As part of that study we operated a Campbell Scientific weather station near the glacier terminus that recorded temperature, rain, wind speed and direction, humidity, incoming shortwave radiation, and barometric pressure. In addition, we also deployed HOBO temperature sensors and tipping bucket rain gauges at two locations: one was across the terminus from the base camp and the other was about 7 km upglacier from the terminus. | 2017-11-14    | NA       | NA       | This work is licensed under the Creative Commons Attribution 4.0 International License.To view a copy of this license, visit <http://creativecommons.org/licenses/by/4.0/>. | NA     | LeConte Glacier, Alaska | 56.8281         | -132.3517      | 56.8281         | -132.3517      | NA        | 2016-03-28 | 2017-09-18 | <doi:10.18739/A2K86G> |

``` r
es_creators(eml)
```

| id                                      | givenName | familyName | affiliation                    | email                   |
|:----------------------------------------|:----------|:-----------|:-------------------------------|:------------------------|
| <https://orcid.org/0000-0002-2801-3124> | Jason     | Amundson   | University of Alaska Southeast | <jmamundson@alaska.edu> |
| <https://orcid.org/0000-0001-7962-4446> | Christian | Kienholz   | University of Alaska Southeast | <ckienholz@alaska.edu>  |
| NA                                      | Roman     | Motyka     | University of Alaska Fairbanks | NA                      |
| NA                                      | David     | Sutherland | University of Oregon           | NA                      |
| NA                                      | Jonathan  | Nash       | Oregon State University        | NA                      |
| NA                                      | Rebecca   | Jackson    | Oregon State University        | NA                      |
