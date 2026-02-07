#!/bin/bash

#set -x
#set -v

usage () {
  echo "Usage:"
  echo "  $0 --tag <tag> [--pimbra-enabled]"
  echo
  echo "Options:"
  echo "  --tag <tag>            Zimbra tag to process (required)"
  echo "  --pimbra-enabled       Enable Pimbra-specific behavior (optional)"
  echo "  -h, --help             Show this help"
  echo
  echo "Examples:"
  echo "  $0 --tag 9.0.0.p26"
  echo "  $0 --tag 10.0.7p0 --pimbra-enabled"
}

# Defaults
TAG=""
PIMBRA_ENABLED=false

# Argument parsing
while [ $# -gt 0 ]; do
  case "$1" in
    --tag)
      TAG="$2"
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

if [ -z "${TAG}" ]; then
  echo "Error: --tag is required."
  usage
  exit 1
fi

PRE_FILTER_TAGS_FILE="$$-pre-filter-tags-file.txt"

PIMBRA_ARG=""
if ${PIMBRA_ENABLED}; then
  PIMBRA_ARG="--pimbra-enabled"
fi

./zm-build-filter-tags.sh --tag "${TAG}" ${PIMBRA_ARG} > "${PRE_FILTER_TAGS_FILE}"
./zm-build-tags-arguments-from-file.sh --tag "${TAG}" --pre-filter-tags-file "${PRE_FILTER_TAGS_FILE}" ${PIMBRA_ARG}

rm "${PRE_FILTER_TAGS_FILE}"
