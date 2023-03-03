# evolution

## Preparing CRAN for the retirement of rgdal, rgeos and maptools

The functionality of `rgdal`, `rgeos` and `maptools` has been largely superseded by other, more modern packages like `sf`, `stars` and `terra`. Roger Bivand, co-applicant of this proposal, has retired early 2021. Roger currently maintains `rgdal`, `rgdal` and `maptools` but will stop maintaining these packages by the end of 2023. Simply withdrawing these packages from CRAN will have a strong effect on other CRAN packages, as they have a large number of reverse dependencies. The problem addressed in this ISC proposal is to make it possible for Roger Bivand to retire from maintaining `rgdal`, `rgeos` and `maptools` while minimizing the disruption of CRAN packages and existing R scripts using these packages. This affects a large number of CRAN package maintainers, and a large number of users of all packages depending directly or indirectly on `rgdal`, `rgeos` or `maptools`. It simplifies maintenance of the “R Spatial stack”, and by that makes the CRAN ecosystem more robust.

For more details, please see 

* [the first blog post](https://r-spatial.org/r/2022/04/12/evolution.html).
* [the second blog post](https://r-spatial.org/r/2022/12/14/evolution2.html).


Diffs between ASDAR 2nd edition code and migrated code not using retired packages added to website.

Interim reports published in https://r-spatial.github.io/evolution/.
