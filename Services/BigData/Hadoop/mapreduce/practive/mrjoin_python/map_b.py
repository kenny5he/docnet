#!/usr/local/bin/python

import sys

for line in sys.stdin:
    ss = line.strip().split('	')

    key = ss[0]
    val = ss[1]

    print "%s\t2\t%s" % (key, val)