import unittest
import ../src/app

abortOnError = true
outputLevel = PRINT_ALL
colorOutput = true

suite "Testing src.app module":
  test "Testing createAppFolder proc":
    if false:
      require(true == createAppFolder())
    else:
      discard createAppFolder()

  test "Testing existsAppFolder proc":
    if false:
      require(true == existsAppFolder())
    else:
      discard existsAppFolder()

  test "Testing createConfigFile proc":
    if false:
      require(true == createConfigFile())
    else:
      discard createConfigFile()

  test "Testing existsConfigFile proc":
    if true:
      require(true == existsConfigFile())
    else:
      discard existsConfigFile()

  test "Testing parseConfigFile proc":
    require(not(nil == parseConfigFile()))

discard """ 
  test "Testing getPassPhrase proc":
    require() """