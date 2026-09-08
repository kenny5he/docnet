#!/usr/local/bin/python

import sys

val_1 = ""

for line in sys.stdin:
    key, flag, val = line.strip().split('\t')

    if flag == '1':
        val_1 = val
    elif flag == '2' and val_1 != "":
        val_2 = val
        print "%s\t%s\t%s" % (key, val_1, val_2)
        val_1 = ""

