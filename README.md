# evolution

## Retiring packages were archived by CRAN 16 October 2023

The legacy R spatial infrastructure packages maptools, rgdal and rgeos were archived by CRAN on Monday, October 16, 2023; rgrass7 has  already been replaced by rgrass and was archived with the retiring packages. 

The choice of date matches the previously announced archiving during October 2023, and the specific date matches the release schedule of Bioconductor 3.18 (some Bioconductor packages depend on retiring packages).

sp_2.1-0 was published October 2, 2023, dropping all dependencies on the retiring packages. sp will continue to be available and maintained, but not developed further. Users of sp classes may continue to make use of them, but will have to use sf or terra to read, write or manipulate objects with coercion (for a guide to coercion, see https://cran.r-project.org/web/packages/rgrass/vignettes/coerce.html).

Information about the evolution project may be found in reports and resources at https://r-spatial.github.io/evolution/; a recent blog by Jakub Nowosad may also be useful as an overview of what has been going on: https://geocompx.org/post/2023/rgdal-retirement/. For more detail, see https://r-spatial.github.io/evolution/ogh23_bivand.html and a video recording of this presentation https://av.tib.eu/media/63141 (August 28).

All directly affected package maintainers have been alerted to the impending changes, some in December 2022, most others in March-April 2023. Many have already updated their packages on CRAN - thank you for your understanding! The remainder received github issue comments and email reminders in the last ten days, and will receive final notices to update by October 9. 

On R-universe, builds of packages archived on CRAN are dropped automatically (https://github.com/r-universe-org/help/issues/286). Read-only github mirrors of archived packages will remain available in principle while github exists (https://github.com/r-hub/rhub/issues/568), for example https://github.com/cran/rgdal. Other binary builds (Debian, Fedora, Ubuntu) have been alerted; support at Anaconda has been alerted.

On CRAN, the retired packages will continue to be available as source packages on https://cran.r-project.org/src/contrib/Archive. maptools, rgdal and rgeos also retain their R-forge repositories, which may be used to retrieve functions for adding to other packages.


## Preparing CRAN for the retirement of rgdal, rgeos and maptools

The functionality of `rgdal`, `rgeos` and `maptools` has been largely superseded by other, more modern packages like `sf`, `stars` and `terra`. Roger Bivand, co-applicant of this proposal, has retired early 2021. Roger currently maintains `rgdal`, `rgeos` and `maptools` but will stop maintaining these packages by October 2023. Simply withdrawing these packages from CRAN will have a strong effect on other CRAN packages, as they have a large number of reverse dependencies. The problem addressed in this ISC proposal is to make it possible for Roger Bivand to retire from maintaining `rgdal`, `rgeos` and `maptools` while minimizing the disruption of CRAN packages and existing R scripts using these packages. This affects a large number of CRAN package maintainers, and a large number of users of all packages depending directly or indirectly on `rgdal`, `rgeos` or `maptools`. It simplifies maintenance of the “R Spatial stack”, and by that makes the CRAN ecosystem more robust.

For more details, please see 

* [How the R-spatial evolution project affects spatial econometrics workflows, 17 November 2023](https://r-spatial.github.io/evolution/bivand_sandiego_2311.pdf)
* [Countdown checklist](https://github.com/r-spatial/evolution/issues/19)
* [Two week warning mailing list posting](https://stat.ethz.ch/pipermail/r-sig-geo/2023-October/029344.html)
* [Watchlist output thrice weekly from June 14, 2023](https://github.com/r-spatial/evolution/tree/main/watchlist_output)
* [the fourth blog post](https://r-spatial.org/r/2023/05/15/evolution4.html).
* [the third blog post](https://r-spatial.org/r/2023/04/10/evolution3.html).
* [the second blog post](https://r-spatial.org/r/2022/12/14/evolution2.html).
* [the first blog post](https://r-spatial.org/r/2022/04/12/evolution.html).
* [Add `rgdal` CRS vignette](https://r-spatial.github.io/evolution/CRS_projections_transformations.html)

## OpenGeoHub Summer School August 2023

- [OpenGeoHub Summer School session, 29 August 2023](https://r-spatial.github.io/evolution/ogh23_bivand.html)

- [Video recording of OpenGeoHub Summer School session: Progress in modernizing and replacing infrastructure packages in R-spatial workflows](https://av.tib.eu/media/63141)


## Center for Spatial Data Science January 2023 workshop and study group materials

Visit: https://spatial.uchicago.edu/directories/full/2022-to-2023

Study group: Modernizing R-spatial: Changes in OSGeo FOSS Libraries and the Evolving R-Spatial Package Ecosystem; https://spatial.uchicago.edu/content/2023 (Tuesday, January 17, 10.00 CT), slides https://rsbivand.github.io/csds_jan23/bivand_csds_ssg_230117.pdf; recording https://www.youtube.com/watch?v=TlpjIqTPMCA&list=PLzREt6r1NenmWEidssmLm-VO_YmAh4pq9&index=1

## Diffs for ASDAR scripts

Diffs between ASDAR 2nd edition code and migrated code not using retired packages added to website; also added diffs for `terra` versions of `cm`, `die` and `cm2`, ch. 2, 4 and 5 (`cm` and `cm2` improved by Robert Hijmans, thanks!). The scripts are in bundles on https://github.com/rsbivand/sf_asdar2ed.

Interim reports published in https://r-spatial.github.io/evolution/.
