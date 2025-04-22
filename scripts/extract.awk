BEGIN{error=0; warning=0; note=0;}{
  if (index($0, " this is package ")) {
    version = $NF;
    split(substr($0, 20), PKG, "'");
    pkg = PKG[1];
  }
  if (index($0, "Status:")) status = substr($0, 9);
  split(status, STATUS, " ");
  sl = 0;
  for (i in STATUS) sl++;
  if (sl > 1) {
    if ((sl % 2) != 0) {print "very odd"}
    else {
      if (sl == 6) {
        error = STATUS[1]; warning = STATUS[3]; note = STATUS[5]
      } else if (sl == 4) {
        if (index(STATUS[2], "ERROR") > 0) {
          error = STATUS[1];
          if (index(STATUS[4], "WARNING") > 0) {
            warning = STATUS[3];
          } else {
            note = STATUS[3];
          }
        } else {
          warning = STATUS[1];
          note = STATUS[3];
        }
      } else if (sl == 2) {
        if (index(STATUS[2], "ERROR") > 0) error = STATUS[1];
        else if (index(STATUS[2], "WARNING") > 0) warning = STATUS[1];
        else note = STATUS[1];
      }
    }
  }
}END{
print pkg, substr(version, 2, length(version)-2), error, warning, note
}
