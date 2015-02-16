# EXECUTE_CLI
# EXECUTE_GUI
# EXECUTE_TST

pwd
cd src/
nim c --debuginfo --lineDir:on --nimcache:/tmp/condooj/src -d:EXECUTE_CLI -d:useSysAssert -d:useGcAssert main.nim
pwd

#nim -d:EXECUTE_TST c main.nim