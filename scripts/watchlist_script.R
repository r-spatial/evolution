# load last run exit watchlist status
options(repos=c("https://cloud.r-project.org/"="https://cloud.r-project.org/", "BioCsoft"="https://bioconductor.org/packages/3.18/bioc", "BioCann"="https://bioconductor.org/packages/3.18/data/annotation", "BioCexp"="https://bioconductor.org/packages/3.18/data/experiment"))
options(useFancyQuotes=FALSE)
setwd("/home/rsb/topics/packages/retirement_process/watchlists")
load("status/status.rda")
down0 <- read.csv(status[1])
# check for new revdeps from last run
library(tools)
ow <- options("warn"=2)
pdb <- available.packages()
options("warn"=ow$warn)
deps <- package_dependencies(packages = c("sp", "maptools", "rgdal", "rgeos"), pdb, which = "most", recursive = FALSE, reverse = TRUE)
down1 <- sort(unique(unlist(deps)))
new_pkgs <- down1[which(!(down1 %in% down0$pkg))]
npi <- NULL
if (length(new_pkgs) > 0L) {
  .libPaths(c("/home/rsb/lib/r_libs", "/home/rsb/lib/r_libs_retiring"))
  ow <- options("warn"=2)
  npi <- try(install.packages(new_pkgs, dependencies=TRUE), silent=TRUE)
  options("warn"=ow$warn)
  .libPaths(c("/home/rsb/lib/r_libs"))
}
# check for version updates
wl <- read.csv(status[2])
current0 <- pdb[which(pdb[,"Package"] %in% wl$package), 1:2, drop=FALSE]
current <- current0[order(current0[, 1]),, drop=FALSE]
# check for wl packages currently not available
na <- sort(wl[which(!(wl$package %in% pdb[,"Package"])), 1])
if (length(na) > 0L) {
  wlx <- wl[!(wl$package %in% na),]
  na_df <- wl[wl$package %in% na,]
} else {
  wlx <- wl
}
# check for version updates on wl minus currently not available
newer <- which(package_version(wlx$version) < package_version(current[,"Version"]))
new_ver0 <- wlx[newer, "package"]
# see if any rev-deps of new_ver0 are in wlx
deps_nv <- package_dependencies(packages = new_ver0, pdb, which = "most", recursive = FALSE, reverse = TRUE)
down_nv <- sort(unique(unlist(deps_nv)))
new_ver_1ord <- which(down_nv %in% wlx$package)
new_ver_1ordt <- down_nv[new_ver_1ord]
new_ver <- sort(unique(c(new_ver0, new_ver_1ordt)))
order_first <- NULL
if (length(new_ver) > length(new_ver0)) order_first <- setdiff(new_ver_1ordt, new_ver0)
npx <- NULL
.libPaths(c("/home/rsb/lib/r_libs", "/home/rsb/lib/r_libs_retiring"))
ow <- options("warn"=2)
npx <- try(install.packages(new_ver0, dependencies=TRUE), silent=TRUE)
options("warn"=ow$warn)
.libPaths(c("/home/rsb/lib/r_libs"))
# create list for checks (new and updated)
need_check <- sort(c(new_pkgs, new_ver))
owd <- getwd()
dstamp <- as.character(as.Date(Sys.time()))
if (length(need_check) > 0L) {
  # create temp directory for checks
  dir.create(dldir <- tempfile())
  setwd(dldir)
  # download source packages
  dls <- download.packages(need_check, destdir=".")
  # run rev-dep checks sp status 2, no retiring packages on path
  res <- vector(mode="list", length=nrow(dls))
for (i in seq(along=res)) res[[i]] <- system(paste("_SP_EVOLUTION_STATUS_=2 R_LIBS=/home/rsb/lib/r_libs _R_CHECK_SUGGESTS_ONLY_=true _R_CHECK_FORCE_SUGGESTS_=FALSE ~/bin/R CMD check", dls[i,2]))
  # extract check status values
  pkgs <- sort(dls[,1])
  logs <- character(nrow(dls))
  for (pkg in seq(along=pkgs)) {
    cmd <- paste0("awk -f ", file.path(owd, "extract.awk"), " ", pkgs[pkg], ".Rcheck/00check.log")
    logs[pkg] <- system(cmd, intern=TRUE)
  }
  # retrieve check logs
  con <- textConnection(logs)
  logs_df <- read.table(con)
  close(con)
  if (length(logs_df) == 7) logs_df <- logs_df[, c(1, 4:7)]
  logs_df[,1] <- sub("’", "", logs_df[,1])
  names(logs_df) <- c("package", "version", "error", "warning", "note")
  save(logs_df, logs, pkgs, dls, file=paste0(owd, "/check_point_", dstamp, ".rda"))
  get <- logs_df$error + logs_df$warning + logs_df$note
  # copy check logs for any other than OK
  gget <- which(get > 0)
  dir.create(paste0("logs_", dstamp))
  for (pkg in pkgs[gget]) {
    file.append(paste0(pkg, ".Rcheck/00check.log"), paste0(pkg, ".Rcheck/00install.out"))
    file.copy(paste0(pkg, ".Rcheck/00check.log"), paste0("logs_", dstamp, "/", pkg, "_00check.log"))
  }
  # create zip archive
  zip(paste0(owd, "/check_logs/logs_", dstamp, ".zip"), paste0("logs_", dstamp))
  # create csv output
  write.csv(logs_df, file=paste0(owd, "/check_csvs/logs_", dstamp, ".csv"), row.names=FALSE)
  # return to regular directory
  setwd(owd)
  # create new status lists
  down2 <- data.frame(pkg=sort(unique(c(new_pkgs, down0$pkg))))
  wl1 <- wlx[-sort(unique(c(newer, new_ver_1ord))),]
  keep <- try((logs_df$error + logs_df$warning) > 0)
  if (inherits(keep, "try-error")) keep <- 1:length(pkgs)
  to_wl1 <- logs_df[keep, 1:2]
  wl1a <- rbind(wl1, to_wl1)
  if (length(na) > 0L) wl1a <- rbind(wl1a, na_df)
  wl2 <- wl1a[order(wl1a$package), ]
  dups <- duplicated(wl2)
  wl2 <- wl2[!dups,]
} else {
  wl2 <- wl
  down2 <- down0
}
# create summary report
fl <- file(paste0("watchlist_summaries/summary_", dstamp, ".txt"), open="w")
cat("Run date:", dstamp, "\n", file=fl, append=TRUE)
cat("Input watchlist length:", nrow(wl), "\n", file=fl, append=TRUE)
cat("Input watchlist name:", status[2], "\n", file=fl, append=TRUE)
if (length(na) > 0L) cat("Watchlist packages not available now (", length(na),"): ", paste(na, collapse=", "), "\n", sep="", file=fl, append=TRUE)
if (length(need_check) > 0L) {
  if (length(new_pkgs) > 0L) cat("Previously untracked most reverse dependencies:", paste(new_pkgs, collapse=", "), "\n", file=fl, append=TRUE)
  if (length(new_ver0) > 0L) cat("New versions:", paste(new_ver0, collapse=", "), "\n", file=fl, append=TRUE)
  if (inherits(npi, "try-error")) cat("Error installing new version\n")
  if (length(order_first) > 0) cat("First order reverse dependencies of new versions:", paste(order_first, collapse=", "), "\n", file=fl, append=TRUE)
  if (inherits(npx, "try-error")) cat("Error installing reverse dependency\n")
  if (length(gget) == 0L) cat("Check results OK:", paste(logs_df[,1], collapse=", "), "\n", file=fl, append=TRUE)
  else {
    if (nrow(logs_df[-gget,]) > 0L) cat("Check results OK:", paste(logs_df[-gget,1], collapse=", "), "\n", file=fl, append=TRUE)
    if (nrow(logs_df[gget,]) > 0L) {
      cat("Check results (any not OK):\n", file=fl, append=TRUE)
      cat(capture.output(print(logs_df[gget,])), sep="\n", file=fl, append=TRUE)
    }
  }
  cat("Output watchlist length:", nrow(wl2), "\n", file=fl, append=TRUE)
  cat("Watchlist length change:", nrow(wl2)-nrow(wl), "\n", file=fl, append=FALSE)
} else {
  cat("No change.\n", file=fl, append=FALSE)
}
close(fl)
# save new status
fl <- paste0("most_sp_maptools_rgdal_rgeos/down_", dstamp, ".csv")
write.csv(down2, file=fl, row.names=FALSE)
status[1] <- fl
fl <- paste0("watchlists/watchlist_", dstamp, ".csv")
write.csv(wl2, file=fl, row.names=FALSE)
status[2] <- fl
file.copy("status/status.rda", paste0("status/status_", dstamp, ".rda"))
save(status, file="status/status.rda")
cs <- read.csv("count_series.csv")
cs <- rbind(cs, data.frame(date=dstamp, watchlist_length=nrow(wl2), unavailable=length(na)))
write.csv(cs, file="count_series.csv", row.names=FALSE)
# copy to local git repo
evo <- "/home/rsb/topics/packages/retirement_process/evolution"
file.copy(paste0("watchlist_summaries/summary_", dstamp, ".txt"), file.path(evo, paste0("watchlist_output/summary_", dstamp, ".txt")), overwrite = TRUE)
file.copy(paste0("count_series.csv"), file.path(evo, paste0("watchlist_output/count_series.csv")), overwrite = TRUE)
file.copy(paste0("check_logs/logs_", dstamp, ".zip"), file.path(evo, paste0("watchlist_output/check_logs/logs_", dstamp, ".zip")), overwrite = TRUE)
# push to github
setwd(evo)
#Sys.setenv(""="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
system(paste0("git add ", file.path(evo, paste0("watchlist_output/summary_", dstamp, ".txt"))))
system(paste0("git add ", file.path(evo, paste0("watchlist_output/check_logs/logs_", dstamp, ".zip"))))
system(paste0("git commit -a -m ", paste0("\"add summary ", dstamp, "\"")))
system("git push")
setwd(owd)
