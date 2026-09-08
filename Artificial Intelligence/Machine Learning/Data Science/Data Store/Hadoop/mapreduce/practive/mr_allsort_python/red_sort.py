#!/usr/local/bin/python

import sys

base_count = 10000

for line in sys.stdin:
    idx_id, key, val = line.strip().split('\t')

    new_key = int(key) - base_count
    print '\t'.join([str(new_key), val])

