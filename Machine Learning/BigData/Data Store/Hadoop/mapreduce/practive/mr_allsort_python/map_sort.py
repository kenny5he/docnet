#!/usr/local/bin/python

import sys

base_count = 10000

for line in sys.stdin:
    ss = line.strip().split('\t')
    key = ss[0]
    val = ss[1]

    new_key = base_count + int(key)

    red_idx = 1
    if new_key < (10100 + 10000) / 2:
        red_idx = 0

    print "%s\t%s\t%s" % (red_idx, new_key, val)

