#!/bin/bash
set -eu

cd $(dirname $0)
. ./config.sh

SUMMARY_HTML="$IMG_TOP_DIR/summary.html"

exec >"$SUMMARY_HTML"
cat <<HTML
<!DOCTYPE html>
<html>
<head>
<meta charset=utf-8>
<title>ping results</title>
<style type="text/css">
td, img {
  border: 0;
  margin: 0;
  padding: 0;
  vertical-align: bottom;
}
</style>
</head>
<body>
<h1>ping results</h1>
<p>green: alive, red: unreachable</p>
<p>X: IP address, Y: time</p>
HTML


gen_table () {
  LABEL="$1"
  shift
  cat <<HTML
<h2>$3</h2>
<table>
<tr>
<th></th>
HTML
  for IP_PREFIX; do
    cat <<HTML
<td><a href="$IP_PREFIX/all.html">$IP_PREFIX</a></td>
HTML
  done
  echo '</tr>'
  declare -A day_label
  day_label=(
   ["2daysago"]="2 days ago"
   ["yesterday"]="yesterday"
   ["latest"]="today"
  )
  for day in "2daysago" "yesterday" "latest"; do
    echo "<tr>"
    echo "<th>${day_label[$day]}</th>"
    for IP_PREFIX; do
      alt="$IP_PREFIX ${day_label[$day]}"
      cat <<HTML
<td><img src="$IP_PREFIX/$day.png" alt="$alt" title="$alt"></td>
HTML
    done
    echo "</tr>"
  done
}

# edit here
gen_table "172 network" 172.{16,17,18}
gen_table "192.168 network" 192.168.{0,1,2}

cat <<HTML
</body>
</html>
HTML
