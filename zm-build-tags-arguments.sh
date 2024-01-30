#!/bin/bash

#set -x
#set -v

if (( $# != 1 ))
then
  echo "Usage:   $0 tag"
  echo "Example: $0 9.0.0.p26"
  exit 1
fi

TAG="$1"
PRE_FILTER_TAGS_FILE="$$-pre-filter-tags-file.txt"
TAG_FOUND="NO"

./zm-build-filter-tags.sh ${TAG} > ${PRE_FILTER_TAGS_FILE}
./zm-build-tags-arguments-from-file.sh ${TAG} ${PRE_FILTER_TAGS_FILE}

rm ${PRE_FILTER_TAGS_FILE}
