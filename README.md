# evolution

## Preparing CRAN for the retirement of rgdal, rgeos and maptools

The functionality of `rgdal`, `rgeos` and `maptools` has been largely superseded by other, more modern packages like `sf`, `stars` and `terra`. Roger Bivand, co-applicant of this proposal, has retired early 2021. Roger currently maintains `rgdal`, `rgdal` and `maptools` but will stop maintaining these packages by the end of 2023. Simply withdrawing these packages from CRAN will have a strong effect on other CRAN packages, as they have a large number of reverse dependencies. The problem addressed in this ISC proposal is to make it possible for Roger Bivand to retire from maintaining `rgdal`, `rgeos` and `maptools` while minimizing the disruption of CRAN packages and existing R scripts using these packages. This affects a large number of CRAN package maintainers, and a large number of users of all packages depending directly or indirectly on `rgdal`, `rgeos` or `maptools`. It simplifies maintenance of the “R Spatial stack”, and by that makes the CRAN ecosystem more robust.

For more details, please see 

* [the first blog post](https://r-spatial.org/r/2022/04/12/evolution.html).
* [the second blog post](https://r-spatial.org/r/2022/12/14/evolution2.html).

## Center for Spatial Data Science 2023 workshop and study group materials

Visit: https://spatial.uchicago.edu/directories/full/2022-to-2023

Study group: Modernizing R-spatial: Changes in OSGeo FOSS Libraries and the Evolving R-Spatial Package Ecosystem; https://spatial.uchicago.edu/content/2023 (Tuesday, January 17, 10.00 CT), slides https://rsbivand.github.io/csds_jan23/bivand_csds_ssg_230117.pdf; recording https://www.youtube.com/watch?v=TlpjIqTPMCA&list=PLzREt6r1NenmWEidssmLm-VO_YmAh4pq9&index=1


Diffs between ASDAR 2nd edition code and migrated code not using retired packages added to website; also added diffs for `terra` versions of `cm`, `die` and `cm2`, ch. 2, 4 and 5.

Interim reports published in https://r-spatial.github.io/evolution/.
