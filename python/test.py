#!/usr/bin/env python
# -*- encoding: utf-8 -*-

import binascii
import sys

def calculatePartition(key, numberOfPartitions):
  return (binascii.crc32(key.encode("utf-8")) & 0xfffffff) % numberOfPartitions

testData = ['', ' ', 'abc', '98955f31-2a1f-4c31-b34b-cfd7d8ee2e1e', '7eaf3944-9c1f-42a7-8419-7926a4911ee9', 'device1', 'de', 'device ', u'¥']
partitionNumbers = [1, 2, 16, 32, 128, 256]

for numberOfPartitions in partitionNumbers:
  print('Test with ' + str(numberOfPartitions) +' partitions')
  for d in testData:
    s = u'%s => %d' % (d, calculatePartition(d, numberOfPartitions))

    # print behaves different on python2 and python3, this has no influence on the algo
    if sys.version_info >= (3, 0):
      print(s)
    else:
      print(s.encode('utf-8'))
  print('')
