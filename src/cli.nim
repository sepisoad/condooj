import os
import app
import sha1

var passPhraseBuffer*: array[0..511, uint8]
var passPhraseDigest*: array[0..19, uint8]

## this is where our cli app starts
proc run*(): bool =
  if false == app.existsAppFolder():
    if false == app.createAppFolder():
      return false
    if false == app.createConfigFile():
      return false

  var configObj = app.parseConfigFile()
  if nil == configObj:
    return false
    
  echo(configObj.autoUpdate)
  echo(configObj.updateInterval)

  return true