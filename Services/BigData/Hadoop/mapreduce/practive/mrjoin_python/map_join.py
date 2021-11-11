#!/usr/local/bin/python

import sys


fd1 = open(file1, 'w')
fd2 = open(file2, 'w')

for line in sys.stdin:
    ss = line.strip().split('\t')
    key1 = ss[0]
    key2 = ss[1]

    print >> fd1, key1
    print >> fd2, key2

