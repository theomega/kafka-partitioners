# kafka-partitioners
A repository with an example partitioner in NodeJS, Java, Python and Erlang.

## Synopsis
[Apache Kafka](http://kafka.apache.org) partitions data by keys. This partitioning is done by a function which takes the message key and assigns it with a partition. This assignment needs to be stable, in a sense that always the same key needs to be assigned to the same partition. If you have multiple services generating data, maybe even written in different programming languages, you need to have a partitioning function implemented in all those languages and you need to be sure that it returns the same results in all languages.

The java client of Kafka already contains an implementation, but this implementation is not consistent with the ones in the other clients. Some other clients don't even provide any usable algorithm.

## Algorithm
This repository settles on a simple algorithm.

1. Given a key `K` as a array of bytes and `numberOfPartitions`, a positive, non-zero number
2. Calcuate the [CRC32](https://en.wikipedia.org/wiki/Cyclic_redundancy_check) checksum of `K`. This leads into a signed int32 number.
3. Only use the lowest 28 bits of the int32. This turns the result into a positive number. You can achieve this by doing a bitwise `AND` of the result of the crc32 calcuation with `0xfffffff`.
4. Calcuate the remainder of the division (modulo) of the number from 3. with the number of partitions

This gives you a number from 0 to `numberOfPartitions`

## Implementations
### Python
The [Python Implementation](./python/test.py) uses the [crc32 method](https://docs.python.org/3/library/binascii.html#binascii.crc32) from the `binascii` package which is contained in the default python distribution. Pay attention that the implemention of this library function is not consistent between python2 and python3. The specification of the algorithm above and the implementation in this package are done in a way that the result is stable and the same between python2 and python3.

### NodeJS
The [NodeJS Implementation](./nodejs/test.js) uses the [CRC-32 npm module](https://www.npmjs.com/package/crc-32). This module needs to be installed for the function to work. The actual implementation is staight forward. The CRC-32 implementation defaults to UTF-8 encoding, so no need to convert the string to a byte array first.

### Java
The [Java](./java/Test.java) implementation uses the [java.util.zip.CRC32](https://docs.oracle.com/javase/7/docs/api/java/util/zip/CRC32.html) class which is bundles with the default JRE. The implementation is straight forward. The main issue here are performance concerns, for every CRC32 calculation, a new `CRC32` object is created which can lead into GC problems. A way out of this is to find a simpler CRC32 implementation.

### Erlang
The [Erlang](./erlang/test.erl) implementation uses the [crc32 function](http://erlang.org/doc/man/erlang.html#crc32-1) which is available out of the box. The actual implementation is straight forward.

## Testing
To ensure that all the implementations do the same, there is a testing harness inside this repository. Execute the `./test.sh` script to run all the implementations and compare their results to guarantee that every implementation returns the same. How this is done is that the implementation is executed using a sample set of keys and a sample set of number of partitions.
To execute the testing, you need to have all the programming languages and their tools installed.

## Next Steps
  - [ ] Implement the testing in a docker container to prevent everyone having to install all the programming languages to test
  - [ ] Implement a better version of the Java CRC32
  - [ ] Check all implementations if they also work with non-string byte-arrays
  - [ ] Add Timing tests which test the performance of the implementations.
  - [ ] Check if other algorithms (i.e. murmur2) make more sense.
