#!/bin/bash

#set -x
#set -v

usage ()  {
  echo "Usage:   $0 tag pre_filter_file"
  echo "Example: $0 9.0.0.p26 pre_filter_tags_9.0.0.p26.txt"
}

TAG="$1"
PRE_FILTER_TAGS_FILE="$2"
PIMBRA_ENABLED="$3" # E.g. 'pimbra-enabled'
TAG_FOUND="NO"

if [ "x" == "x${TAG}" ] ; then
  echo "TAG is not defined."
  usage
  exit 1
fi

if [ "x" == "x${PRE_FILTER_TAGS_FILE}" ] ; then
  echo "pre_filter_file is not defined."
  usage
  exit 1
fi

PIMBRA_TMP_CONFIG_BUILD="pimbra-tmp-config_$$.build"

# Check if Pimbra tag is correct
MALDUA_PIMBRA_CONFIG_GITHUB_URL="https://github.com/maldua-pimbra/maldua-pimbra-config"
if [ "pimbra-enabled" == "${PIMBRA_ENABLED}" ] ; then
  wget "${MALDUA_PIMBRA_CONFIG_GITHUB_URL}"'/raw/refs/tags/'"${TAG}"'/config.build' -O "${PIMBRA_TMP_CONFIG_BUILD}"
  if [[ $? -ne 0 ]] ; then
    echo "ERROR: Pimbra config file cannot be downloaded for ${TAG} version !"
    echo "Aborting !!!"
    exit 2
  fi
fi

ntagCounter=0

if [ "pimbra-enabled" == "${PIMBRA_ENABLED}" ] ; then
  echo -e -n "${TAG}"
  let ntagCounter=$ntagCounter+1
  TAG_TO_FIND="${TAG%.[pP]*}"
else
  TAG_TO_FIND="${TAG}"
fi

for ntag in $(cat ${PRE_FILTER_TAGS_FILE}); do

  if [[ "${TAG_TO_FIND}" == "${ntag}" ]] ; then
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

# Remove tmp files
if [ "pimbra-enabled" == "${PIMBRA_ENABLED}" ] ; then
  rm ${PIMBRA_TMP_CONFIG_BUILD}
fi
