#!/bin/sh

cd test
nim c --debuginfo --lineDir:on --nimcache:/tmp/condooj/tests tests.nim
cd ..