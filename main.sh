#!/bin/bash
set -eux

if [ -z "$1" ]; then
  echo "usage: $0 192.168.y [{1..254}]"
  exit 1
fi

cd $(dirname $0)
. ./config.sh

IP_PREFIX="$1"
IP_RANGE="$2"
DATA_DIR="$DATA_TOP_DIR/$IP_PREFIX"
IMG_DIR="$IMG_TOP_DIR/$IP_PREFIX"
ALL_HTML="$IMG_DIR/all.html"
IMG_THRESHOLD=$(date -d '2 days ago' '+%Y%m%d')

mkdir -p "$IMG_DIR"
./collect.sh "$IP_PREFIX" "$IP_RANGE"

cat >"$ALL_HTML" <<HTML
<!DOCTYPE html>
<html>
<head>
<meta charset=utf-8>
<title>fping results: $IP_PREFIX</title>
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
<table>
HTML

TODAY=$(date '+%Y%m%d')
PREV="$TODAY"
LAST="$TODAY"
unset TODAY
for dir in "$DATA_DIR"/*; do
  day=$(basename "$dir")
  if [[ "$IMG_THRESHOLD" -lt "$day" ]]; then
    ./to-xpm.sh "$dir" > _tmp.xpm
    convert _tmp.xpm "$IMG_DIR/$day.png"
  fi
  echo "<tr><th>$day</th><td><img src=\"$day.png\" alt=\"$day\" title=\"$day\"></td></tr>" >>"$ALL_HTML"
  PRE2=$PREV
  PREV=$LAST
  LAST=$day
done

cat >>"$ALL_HTML" <<HTML
</table>
</body>
</html>
HTML

ln -snf "$PRE2.png" "$IMG_DIR/2daysago.png"
ln -snf "$PREV.png" "$IMG_DIR/yesterday.png"
ln -snf "$LAST.png" "$IMG_DIR/latest.png"
