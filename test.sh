#!/bin/bash -e

set -euo pipefail

if [ -z ${DIR+x} ]; then
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
fi
if [ -z ${RESULTS+x} ]; then
  RESULTS="$DIR/results"
  if [ -d $RESULTS ]; then
    rm -rf $RESULTS
  fi
  mkdir -p $RESULTS
fi

echo "Scripts loading from $DIR"
echo "Saving results to $RESULTS"

# Python2, Python3
cd $DIR/python
python test.py | tee $RESULTS/python2.txt
python3 test.py | tee $RESULTS/python3.txt

# NodeJS
cd $DIR/nodejs
npm install
node test.js | tee $RESULTS/nodejs.txt

# Java
cd $DIR/java
javac Test.java
java Test | tee $RESULTS/java.txt

# Erlang
cd $DIR/erlang
erlc test.erl
erl -noshell -s test test -s init stop| tee $RESULTS/erlang.txt

# Verify
for a in python2 python3 nodejs java erlang; do
  for b in python2 python3 nodejs java erlang; do
    echo
    echo
    echo
    echo "Comparing $a <-> $b"
    diff $RESULTS/$a.txt $RESULTS/$b.txt || exit 1
  done
done

