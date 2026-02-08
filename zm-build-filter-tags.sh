#!/bin/bash

#set -x
#set -v

function usage {
cat << EOF
Usage: $0 --tag <tag> [--pimbra-enabled] [--verbose] [--help|-h]

Options:
  --tag              Zimbra build tag to filter (required)
  --pimbra-enabled   Use the PIMBRA fork of zm-build (optional)
  --verbose          Show more information (git clone / checkout not quiet)
  -h, --help         Show this help message

Examples:
  $0 --tag 9.0.0.p26
  $0 --tag 9.0.0.p26 --pimbra-enabled
  $0 --tag 9.0.0.p26 --verbose
EOF
}

# Default values
PIMBRA_ENABLED=false
VERBOSE=false
TAG=""

# Git verbosity control
GIT_QUIET_FLAGS="--quiet"

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --tag)
      TAG="$2"
      shift 2
      ;;
    --pimbra-enabled)
      PIMBRA_ENABLED=true
      shift
      ;;
    --verbose)
      VERBOSE=true
      GIT_QUIET_FLAGS=""
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

# Validate required arguments
if [ -z "${TAG}" ]; then
  echo "Error: --tag is required."
  usage
  exit 1
fi

ZMBUILD_TAGS="zmbuild_tags_$$.txt"
AGGREGATED_REPOS="aggregated_repos_$$.txt"
TAGS_DETAILED_CSV="tags_detailed_csv_$$.txt"
TAGS_AND_NEWEST_DATE="tag_newest_date_$$.csv"
TAGS_ORDERED_ITERATION_1="tags_ordered_1_$$.csv"

TAG_REPO_TMP_DIR="tagrepotmp_$$"

# MAIN_BRANCH="10.0"
MAIN_BRANCH=$(echo "${TAG}" | perl -pe 's|^(.*?)\.(.*?)\.(.*?)$|\1\.\2|')
MAIN_BRANCH_PREFIX="${MAIN_BRANCH}."

ZMBUILD_REPO_URL="https://github.com/Zimbra/zm-build.git"
if [ "${PIMBRA_ENABLED}" = true ]; then
  ZMBUILD_REPO_URL="https://github.com/maldua-pimbra/zm-build.git"
fi

if [ ! -d "zm-build" ] ; then
  echo "Cloning zm-build from ${ZMBUILD_REPO_URL}..."
  git clone ${GIT_QUIET_FLAGS} "${ZMBUILD_REPO_URL}"
fi

# 0th step. Get zm-build tags
cd zm-build
git tag | grep -E '^'"${MAIN_BRANCH_PREFIX}" > ../${ZMBUILD_TAGS}
cd ..

# 1st step. Get detailed CSV with all of the repo tags with their dates

# 1.1th step. Get aggregated repos
for nZmbuildTag in $(cat ${ZMBUILD_TAGS}); do
  cd zm-build
  git checkout ${GIT_QUIET_FLAGS} ${nZmbuildTag}
  cd ..
  perl zm-build-print-repos.pl >> ${AGGREGATED_REPOS}
done

# Also local zm-build repo
echo "$(pwd)/zm-build" >> ${AGGREGATED_REPOS}

# 1.2th step. Get aggregated repos tags

# for nrepo in 'https://github.com/Zimbra/ant-1.7.0-ziputil-patched.git' 'https://github.com/Zimbra/ant-tar-patched.git' 'https://github.com/Zimbra/zm-mailbox.git' ; do
for nrepo in $(cat ${AGGREGATED_REPOS} | sort | uniq) ; do
  git clone $nrepo ${TAG_REPO_TMP_DIR}
  cd ${TAG_REPO_TMP_DIR}
  git tag --format='%(creatordate:unix)%09%(refname:strip=2)' --sort=-taggerdate | awk '$2 ~ /^'${MAIN_BRANCH_PREFIX}'/ {print $1 " " $2}' | awk -v nrepo="$nrepo" '{print $1 " " $2 " " nrepo }'
  cd ..
  rm -rf ${TAG_REPO_TMP_DIR}
done  >> ${TAGS_DETAILED_CSV}

# 2nd step. Get newest date for each one of the tags
for nUnsortedTag in $(cat ${TAGS_DETAILED_CSV} | awk '{print $2}' | sort | uniq) ; do
    cat ${TAGS_DETAILED_CSV} | awk '$2 ~ /^'${nUnsortedTag}'$/ {print $1 " " $2}' | sort -r | head -n 1 >> ${TAGS_AND_NEWEST_DATE}
done

# 3rd step. Order by date

cat ${TAGS_AND_NEWEST_DATE} | sort -k1 -r | awk '{print $2}' > ${TAGS_ORDERED_ITERATION_1}
cat ${TAGS_ORDERED_ITERATION_1}

# Remove tmp files
rm ${ZMBUILD_TAGS}
rm ${AGGREGATED_REPOS}
rm ${TAGS_DETAILED_CSV}
rm ${TAGS_AND_NEWEST_DATE}
rm ${TAGS_ORDERED_ITERATION_1}
