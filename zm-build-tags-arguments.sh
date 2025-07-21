#!/bin/bash

#set -x
#set -v

usage () {
  echo "Usage:   $0 tag"
  echo "Example: $0 9.0.0.p26"

  echo "Usage:   $0 tag pimbra-enabled"
  echo "Example: $0 9.0.0.p26 pimbra-enabled"
}

TAG="$1" # E.g. 10.0.7p0
PIMBRA_ENABLED="$2" # E.g. 'pimbra-enabled'

if [ "x" == "x${TAG}" ] ; then
  echo "TAG is not defined."
  usage
  exit 1
fi

PRE_FILTER_TAGS_FILE="$$-pre-filter-tags-file.txt"
TAG_FOUND="NO"

./zm-build-filter-tags.sh ${TAG} > ${PRE_FILTER_TAGS_FILE}
./zm-build-tags-arguments-from-file.sh ${TAG} ${PRE_FILTER_TAGS_FILE} ${PIMBRA_ENABLED}

rm ${PRE_FILTER_TAGS_FILE}
