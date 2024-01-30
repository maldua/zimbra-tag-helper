#!/bin/bash

#set -x
#set -v

if (( $# != 1 ))
then
  echo "Usage:   $0 tag"
  echo "Example: $0 9.0.0.p26"
  exit 1
fi

TAG=$1

ZMBUILD_TAGS="zmbuild_tags_$$.txt"
AGGREGATED_REPOS="aggregated_repos_$$.txt"
TAGS_DETAILED_CSV="tags_detailed_csv_$$.txt"
TAGS_AND_NEWEST_DATE="tag_newest_date_$$.csv"
TAGS_ORDERED_ITERATION_1="tags_ordered_1_$$.csv"

TAG_REPO_TMP_DIR="tagrepotmp_$$"

# MAIN_BRANCH="10.0"
MAIN_BRANCH=$(echo "${TAG}" | perl -pe 's|^(.*?)\.(.*?)\.(.*?)$|\1\.\2|')
MAIN_BRANCH_PREFIX="${MAIN_BRANCH}."
MAIN_BRANCH_ZERO_TAG="${MAIN_BRANCH_PREFIX}0"

if [ ! -d "zm-build" ] ; then
  git clone 'https://github.com/Zimbra/zm-build.git'
fi

# 0th step. Get zm-build tags
cd zm-build
git tag | grep -E '^'"${MAIN_BRANCH_PREFIX}" > ../${ZMBUILD_TAGS}
cd ..

# 1st step. Get detailed CSV with all of the repo tags with their dates

# 1.1th step. Get aggregated repos

for nZmbuildTag in $(cat ${ZMBUILD_TAGS}); do
  cd zm-build
  git checkout ${nZmbuildTag}
  cd ..
  perl zm-build-print-repos.pl >> ${AGGREGATED_REPOS}
done

# 1.2th step. Get aggregated repos tags

# for nrepo in 'https://github.com/Zimbra/ant-1.7.0-ziputil-patched.git' 'https://github.com/Zimbra/ant-tar-patched.git' 'https://github.com/Zimbra/zm-mailbox.git' ; do
for nrepo in $(cat ${AGGREGATED_REPOS} | sort | uniq) ; do
  git clone $nrepo ${TAG_REPO_TMP_DIR}
  cd ${TAG_REPO_TMP_DIR}
  git tag --format='%(creatordate:unix)%09%(refname:strip=2)' --sort=-taggerdate | awk '$2 ~ /^'${MAIN_BRANCH_PREFIX}'/ {print $1 " " $2}' | grep -v 'beta' | awk -v nrepo="$nrepo" '{print $1 " " $2 " " nrepo }'
  cd ..
  rm -rf ${TAG_REPO_TMP_DIR}
done  >> ${TAGS_DETAILED_CSV}

# 2nd step. Get newest date for each one of the tags
for nUnsortedTag in $(cat ${TAGS_DETAILED_CSV} | awk '{print $2}' | sort | uniq) ; do
    cat ${TAGS_DETAILED_CSV} | awk '$2 ~ /^'${nUnsortedTag}'$/ {print $1 " " $2}' | sort -r | head -n 1 >> ${TAGS_AND_NEWEST_DATE}
done

# 3rd step. Order by date (and remove main branch zero tag)
# NOTE: We remove the original branch because its date its messed up.

cat ${TAGS_AND_NEWEST_DATE} | sort -k1 -r | awk '{print $2}' | grep -v -e '^'${MAIN_BRANCH_ZERO_TAG}'$' > ${TAGS_ORDERED_ITERATION_1}

cat ${TAGS_ORDERED_ITERATION_1} ; echo ${MAIN_BRANCH_ZERO_TAG}

# Remove tmp files
rm ${ZMBUILD_TAGS}
rm ${AGGREGATED_REPOS}
rm ${TAGS_DETAILED_CSV}
rm ${TAGS_AND_NEWEST_DATE}
rm ${TAGS_ORDERED_ITERATION_1}
