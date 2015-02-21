import os
import streams
import json
import globals

type TConfig* = object
  useDropBoxBackup*: bool
  autoUpdate*: bool
  updateInterval*: int64

## parse config file
proc parse*(configFilePath: string): ref TConfig =
  var errCode: OSErrorCode
  var configObj: ref TConfig # var configObj = new(TConfig)
  new(configObj)

  var configFileStream = streams.newFileStream(configFilePath, system.fmRead)
  if(nil == configFileStream):
    errCode = os.osLastError()
    stderr.writeln("Error: failed to load \"" & configFilePath & "\" file.")
    stderr.writeln(osErrorMsg(errCode))
    return nil

  var configFileData: string = ""
  var configFileLine: string = ""

  try:
    while false != configFileStream.readLine(configFileLine):
      configFileData &= configFileLine
      configFileData &= "\n"
  except Exception:
    var errCode = os.osLastError()
    stderr.writeln("Error: failed to parse \"" & configFilePath & "\" file.")
    stderr.writeln(osErrorMsg(errCode))
    return nil
  finally:
    configFileStream.close()
  
  var parsedConfigFile: JsonNode
  try:
    parsedConfigFile = parseJson(configFileData)
  except Exception:
    errCode = os.osLastError()
    stderr.writeln("Error: failed to parse \"" & configFilePath & "\" file.")
    stderr.writeln(osErrorMsg(errCode))
    return nil
  except ValueError:
    errCode = os.osLastError()
    stderr.writeln("Error: failed to parse \"" & configFilePath & "\" file.")
    stderr.writeln("value error detected in config file")
    return nil
  except JsonParsingError:
    errCode = os.osLastError()
    stderr.writeln("Error: failed to parse \"" & configFilePath & "\" file.")
    stderr.writeln("config file contains error")
    return nil
  finally:
    configFileStream.close()

  var isKeyMissing = false
  if true == hasKey(parsedConfigFile, "use_dropbox_backup"):
    configObj.useDropBoxBackup = parsedConfigFile["use_dropbox_backup"].bval  
  else:
    stderr.writeln("Error: failed to parse \"" & configFilePath & "\" file.")
    stderr.writeln("the config file is broken")
    stderr.writeln("'use_dropbox_backup' field is missing")
    isKeyMissing = true
  
  if true == hasKey(parsedConfigFile, "auto_update"):
    configObj.autoUpdate = parsedConfigFile["auto_update"].bval
  else:
    stderr.writeln("Error: failed to parse \"" & configFilePath & "\" file.")
    stderr.writeln("the config file is broken")
    stderr.writeln("'auto_update' field is missing")
    isKeyMissing = true

  if true == hasKey(parsedConfigFile, "update_interval"):
    configObj.updateInterval = parsedConfigFile["update_interval"].num 
  else:
    stderr.writeln("Error: failed to parse \"" & configFilePath & "\" file.")
    stderr.writeln("the config file is broken")
    stderr.writeln("'update_interval' field is missing")
    isKeyMissing = true

  configFileStream.close()

  if true == isKeyMissing:
    return nil

  return configObj

## writes config object values to config file
## TODO: test
proc writeToFile*(configObj: ref TConfig, configFilePath: string): bool =
  var configFileStream = streams.newFileStream(configFilePath, system.fmWrite)
  if nil == configFileStream:
    var errCode = os.osLastError()
    stderr.writeln("Error: failed to create \"" & configFilePath & "\" file.")
    stderr.writeln(osErrorMsg(errCode))
    return false

  streams.writeln(configFileStream, "{")

  if true == configObj.useDropBoxBackup:
    streams.writeln(configFileStream, "\t\"use_dropbox_backup\": true,")
  else:
    streams.writeln(configFileStream, "\t\"use_dropbox_backup\": false,")

  if true == configObj.autoUpdate:
    streams.writeln(configFileStream, "\t\"auto_update\": true,")
  else:
    streams.writeln(configFileStream, "\t\"auto_update\": false,")

  streams.writeln(configFileStream, "\t\"update_interval\": " & $(configObj.updateInterval))
  streams.writeln(configFileStream, "}")

  streams.close(configFileStream)

## set config file use_dropbox_backup field
## TODO: test
proc setUseDropBox*(configFilePath: string, can: bool): bool = 
  var configObj = parse(configFilePath)
  if nil == configObj:
    return false

  configObj.useDropBoxBackup = can
  if false == writeToFile(configObj, configFilePath):
    return false

  return true

## set config file auto_update field
## TODO: test
proc setAutoUpdate*(configFilePath: string, can: bool): bool = 
  var configObj = parse(configFilePath)
  if nil == configObj:
    return false

  configObj.autoUpdate = can
  if false == writeToFile(configObj, configFilePath):
    return false

  return true

## set config file update_interval field
## TODO: test
proc setUpdateInterval*(configFilePath: string, interval: int64): bool = 
  var configObj = parse(configFilePath)
  if nil == configObj:
    return false

  configObj.updateInterval = interval
  if false == writeToFile(configObj, configFilePath):
    return false

  return true