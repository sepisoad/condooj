# -d:RUN_AS_APP
# -d:RUN_AS_SERVICE

pwd
cd src/
nim c --debuginfo --lineDir:on --nimcache:/tmp/condooj/src -d:RUN_AS_APP -d:useSysAssert -d:useGcAssert condooj.nim
pwd