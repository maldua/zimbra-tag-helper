#!/bin/bash

#set -x
#set -v

usage() {
  cat << EOF
Usage: $0 --tag <tag> --pre-filter-tags-file <file> [--pimbra-enabled] [--help|-h]

Options:
  --tag                     Zimbra tag to find (required)
  --pre-filter-tags-file     File containing pre-filtered tags (required)
  --pimbra-enabled           Optional flag to enable Pimbra handling
  --help, -h                 Show this help message

Example:
  $0 --tag 9.0.0.p26 --pre-filter-tags-file pre_filter_tags_9.0.0.p26.txt
  $0 --tag 10.0.7 --pre-filter-tags-file pre_filter_tags_10.0.7.txt --pimbra-enabled
EOF
}

# Default
PIMBRA_ENABLED=false

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --tag)
      TAG="$2"
      shift 2
      ;;
    --pre-filter-tags-file)
      PRE_FILTER_TAGS_FILE="$2"
      shift 2
      ;;
    --pimbra-enabled)
      PIMBRA_ENABLED=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1"
      usage
      exit 1
      ;;
  esac
done

# Check required arguments
if [ -z "$TAG" ]; then
  echo "Error: --tag is required."
  usage
  exit 1
fi

if [ -z "$PRE_FILTER_TAGS_FILE" ]; then
  echo "Error: --pre-filter-tags-file is required."
  usage
  exit 1
fi

PIMBRA_TMP_CONFIG_BUILD="pimbra-tmp-config_$$.build"

# Check if Pimbra tag is correct
MALDUA_PIMBRA_CONFIG_GITHUB_URL="https://github.com/maldua-pimbra/maldua-pimbra-config"
if $PIMBRA_ENABLED; then
  wget "${MALDUA_PIMBRA_CONFIG_GITHUB_URL}"'/raw/refs/tags/'"${TAG}"'/config.build' -O "${PIMBRA_TMP_CONFIG_BUILD}"
  if [[ $? -ne 0 ]] ; then
    echo "ERROR: Pimbra config file cannot be downloaded for ${TAG} version !"
    echo "Aborting !!!"
    exit 2
  fi
fi

ntagCounter=0

if $PIMBRA_ENABLED; then
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
if $PIMBRA_ENABLED; then
  rm ${PIMBRA_TMP_CONFIG_BUILD}
fi
