#!/usr/local/bin/python

import sys

#base_value = 10000
base_value = 99999

for line in sys.stdin:
    key, val = line.strip().split('\t')
    #print str(int(key) - base_value) + "\t" + val
    print str(base_value - int(key)) + "\t" + val


