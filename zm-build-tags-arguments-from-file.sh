#!/bin/bash

#set -x
#set -v

if (( $# != 2 ))
then
  echo "Usage:   $0 tag pre_filter_file"
  echo "Example: $0 9.0.0.p26 pre_filter_tags_9.0.0.p26.txt"
  exit 1
fi

TAG="$1"
PRE_FILTER_TAGS_FILE="$2"
TAG_FOUND="NO"

ntagCounter=0
for ntag in $(cat ${PRE_FILTER_TAGS_FILE}); do

  if [[ "${TAG}" == "${ntag}" ]] ; then
    TAG_FOUND="YES"
  fi

  if [[ "${TAG_FOUND}" == "YES" ]] ; then
    if [ "${ntagCounter}" -ne "0" ] ; then
      echo -e -n ","
    fi
    echo -e -n "$ntag"
    let ntagCounter=$ntagCounter+1
  fi

done
