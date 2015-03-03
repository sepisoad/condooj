import nake
import os

const EXE_NAME = "  --out:./condooj ./src/condooj.nim "
const COMMON_FLAGS = " -d:RUN_AS_APP "
const DEBUG_FLAGS = " c --debuginfo --lineDir:on -d:useSysAssert -d:useGcAssert --nimcache:./BUILD/DEBUG/"
const RELEASE_FLAG = " -d:release "

task "debug", "this option will compile source codes under debug mode":
  echo(nimExe & DEBUG_FLAGS & COMMON_FLAGS & EXE_NAME)
  if not shell(nimExe & DEBUG_FLAGS & COMMON_FLAGS & EXE_NAME):
    echo("Error")
  else:
    try:
      moveFile("./src/condooj", "condooj")
    except OSError:
      echo("Cannot find generated executable file")
    echo("Yay")