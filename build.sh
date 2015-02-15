# EXECUTE_CLI
# EXECUTE_GUI
# EXECUTE_TST

pwd
cd src/
nim c --debuginfo --lineDir:on --nimcache:/tmp/condooj/src -d:EXECUTE_CLI main.nim
pwd

#nim -d:EXECUTE_TST c main.nim