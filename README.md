# Zimbra Tag Helper

## Introduction

This is a proof-of-concept for getting latest tags associated to Zimbra 9 and Zimbra 10 builds.

## Usage example for Zimbra 9 builds

```
mkdir /tmp/zimbra-tag-test
cd /tmp/zimbra-tag-test

git clone https://github.com/maldua/zimbra-tag-helper
cd zimbra-tag-helper
./zm-build-filter-tags-9.sh > tags_for_9.txt
```

`tags_for_9.txt` contents:

```
9.0.0.p38,9.0.0.p37,9.0.0.p36,9.0.0.p34,9.0.0.p33,9.0.0.P33,9.0.0.p32.1,9.0.0.p32,9.0.0.p30,9.0.0.p29,9.0.0.p28,9.0.0.p27,9.0.0.p26,9.0.0.p25,9.0.0.p24.1,9.0.0.p24,9.0.0.p23,9.0.0.p22,9.0.0.p21,9.0.0.p20,9.0.0.p19,9.0.0.p18,9.0.0.p17,9.0.0.p16,9.0.0.p15,9.0.0.p14,9.0.0.p13,9.0.0.p12,9.0.0.p11,9.0.0.p10,9.0.0.p9,9.0.0.p8,9.0.0.p7,9.0.0.p6,9.0.0.p5,9.0.0.p4,9.0.0.p3,9.0.0.p2,9.0.0.p1,9.0.0
```

## Usage example for Zimbra 10 builds

```
mkdir /tmp/zimbra-tag-test
cd /tmp/zimbra-tag-test

git clone https://github.com/maldua/zimbra-tag-helper
cd zimbra-tag-helper
./zm-build-filter-tags-10.sh > tags_for_10.txt
```

`tags_for_10.txt` contents:

```
10.0.6,10.0.5,10.0.4,10.0.2,10.0.1,10.0.0-GA,10.0.0
```

## Generic Zimbra build tags (one per line)

This might be helpful for automating scripts.
Please notice that you will always have more tags than requested.
You need to filter later based on your tag.

```
mkdir /tmp/zimbra-tag-test
cd /tmp/zimbra-tag-test

git clone https://github.com/maldua/zimbra-tag-helper
cd zimbra-tag-helper
```

```
./zm-build-filter-tags.sh 10.0.0 > tags_for_10.txt
```

`tags_for_10.txt` contents:

```
10.0.6
10.0.5
10.0.4
10.0.2
10.0.1
10.0.0-GA
10.0.0
```

```
./zm-build-filter-tags.sh 9.0.0 > tags_for_9.txt
```

`tags_for_9.txt` contents:

```
9.0.0.p38
9.0.0.p37
9.0.0.p36
9.0.0.p34
9.0.0.p33
9.0.0.P33
9.0.0.p32.1
9.0.0.p32
9.0.0.p30
9.0.0.p29
9.0.0.p28
9.0.0.p27
9.0.0.p26
9.0.0.p25
9.0.0.p24.1
9.0.0.p24
9.0.0.p23
9.0.0.p22
9.0.0.p21
9.0.0.p20
9.0.0.p19
9.0.0.p18
9.0.0.p17
9.0.0.p16
9.0.0.p15
9.0.0.p14
9.0.0.p13
9.0.0.p12
9.0.0.p11
9.0.0.p10
9.0.0.p9
9.0.0.p8
9.0.0.p7
9.0.0.p6
9.0.0.p5
9.0.0.p4
9.0.0.p3
9.0.0.p2
9.0.0.p1
9.0.0
```

## Find an specific tag arguments

`zm-build-tags-arguments.sh` uses `zm-build-filter-tags.sh` under the hood to find your tag build arguments separated by commas.

```
mkdir /tmp/zimbra-tag-test
cd /tmp/zimbra-tag-test

git clone https://github.com/maldua/zimbra-tag-helper
cd zimbra-tag-helper
./zm-build-tags-arguments.sh 9.0.0.p26 > tags_for_9.0.0.p26.txt
```

`tags_for_9.0.0.p26.txt` contents:

```
9.0.0.p26,9.0.0.p25,9.0.0.p24.1,9.0.0.p24,9.0.0.p23,9.0.0.p22,9.0.0.p21,9.0.0.p20,9.0.0.p19,9.0.0.p18,9.0.0.p17,9.0.0.p16,9.0.0.p15,9.0.0.p14,9.0.0.p13,9.0.0.p12,9.0.0.p11,9.0.0.p10,9.0.0.p9,9.0.0.p8,9.0.0.p7,9.0.0.p6,9.0.0.p5,9.0.0.p4,9.0.0.p3,9.0.0.p2,9.0.0.p1,9.0.0
```
