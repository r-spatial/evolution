#! /bin/bash
export R_LIBS="/home/rsb/lib/r_libs"
export R_CMD="/home/rsb/topics/R/R432-share/bin/R"
export RUN_IN="/home/rsb/topics/packages/retirement_process/watchlists"
#export GITHUB_PAT=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
export DISPLAY=:1

cd $RUN_IN

$R_CMD --vanilla < watchlist_script.R 2>&1 > latest.log
if test $? -ne 0
    then 
    cat >> latest.log  << _EOCONF
Error: watchlist_script failure
_EOCONF
fi


