#!/bin/bash

for fname in $(find . -iname '*.jpg'); do
  echo -ne "\r$fname\r"
  NAME_HASH=$(echo $fname | cut -d '_' -f3 | cut -d '.' -f1)
  HASH=$(md5sum "$fname" | cut -d ' ' -f1)
  if [ "$NAME_HASH" != "$HASH" ]; then
    echo -ne "\r$fname hash does NOT match\n"
  fi
done
