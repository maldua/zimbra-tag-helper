# Zimbra Tag Helper

## Introduction

This is a proof-of-concept for getting latest tags associated to Zimbra 9 and Zimbra 10 builds.

## Usage example for Zimbra 9 builds

```
mkdir /tmp/zimbra-tag-test
cd /tmp/zimbra-tag-test

git clone https://github.com/maldua/zimbra-tag-helper
cd zimbra-tag-helper
git clone https://github.com/Zimbra/zm-build.git
./zm-build-filter-tags-9.sh > tags_for_9.txt
```

`tags_for_9.txt` contents:

```
```

## Usage example for Zimbra 10 builds

```
mkdir /tmp/zimbra-tag-test
cd /tmp/zimbra-tag-test

git clone https://github.com/maldua/zimbra-tag-helper
cd zimbra-tag-helper
git clone https://github.com/Zimbra/zm-build.git
./zm-build-filter-tags-10.sh > tags_for_10.txt
```

`tags_for_10.txt` contents:

```
```
