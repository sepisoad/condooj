import unittest
import ../src/app

abortOnError = true
outputLevel = PRINT_ALL
colorOutput = true

suite "Testing src.app module":
  test "createAppFolder":
    if false:
      require(true == createAppFolder())
    else:
      discard createAppFolder()

  test "existsAppFolder":
    if false:
      require(true == existsAppFolder())
    else:
      discard existsAppFolder()

  test "createConfigFile":
    if false:
      require(true == createConfigFile())
    else:
      discard createConfigFile()

  test "existsConfigFile":
    if true:
      require(true == existsConfigFile())
    else:
      discard existsConfigFile()

  test "parseConfigFile":
    require(not(nil == parseConfigFile()))

discard """ 
  test "Testing getPassPhrase proc":
    require() """