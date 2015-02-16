import globals
import os
import streams
import json

type TConfig* = object
  useDropBoxBackup*: bool
  autoUpdate*: bool
  updateInterval*: int64

var appFolderPath = ""
var configFilePath = ""
var userFilePath = ""

## get appFolderPath value
proc getAppFolderPath*(): string = 
  return appFolderPath

## get configFilePath value
proc getConfigFilePath*(): string = 
  return configFilePath

## get userFilePath value
proc getUserFilePath*(): string = 
  return userFilePath

## check to see if the app folder exists
proc existsAppFolder*(): bool = 
  var homeFolder = os.getHomeDir()
  appFolderPath = os.joinPath(homeFolder, globals.APP_FOLDER_NAME) 
    
  if false == existsDir(appFolderPath):
    return false

  return true

## create app folder
proc createAppFolder*(): bool = 
  if true == existsAppFolder():
    stderr.writeln("Error: the path \"" & appFolderPath & "\" already exists")
    return false
  
  try:
    os.createDir(appFolderPath)
  except OSError:
    var errCode = os.osLastError()
    stderr.writeln("Error: failed to create \"" & appFolderPath & "\" dir.")
    stderr.writeln(osErrorMsg(errCode))
    return false
  
  return true

## check to see if the config file exists
proc existsConfigFile*(): bool =     
  if false == existsAppFolder():
    return false

  configFilePath = os.joinPath(appFolderPath, globals.CONFIG_FILE_NAME)

  if(false == existsFile(configFilePath)):
    return false

  return true

## writes config object values to config file
## TODO: test
proc writeConfigObjToFile(configObj: ref TConfig): bool =
  if false == existsAppFolder():
    stderr.writeln("Error: the path \"" & appFolderPath & "\" does not exist")
    return false

  var configFileStream = streams.newFileStream(configFilePath, system.fmWrite)
  if(nil == configFileStream):
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

## create default config file
proc createConfigFile*(): bool =
  var configObj: ref TConfig
  new(configObj)

  if false == existsAppFolder():
    stderr.writeln("Error: the path \"" & appFolderPath & "\" does not exist")
    return false

  if true == existsConfigFile():
    stderr.writeln("Error: the file \"" & configFilePath & "\" already exists")
    return false

  configObj.useDropBoxBackup = false
  configObj.autoUpdate = false
  configObj.updateInterval = 0

  if false == writeConfigObjToFile(configObj):
    return false

  return true;

## parse config file
proc parseConfigFile*(): ref TConfig =
  var errCode: OSErrorCode
  var configObj: ref TConfig # var configObj = new(TConfig)
  new(configObj)
  
  if(false == existsConfigFile()):
    return nil

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

## set config file use_dropbox_backup field
## TODO: test
proc setConfigUseDropBox*(can: bool): bool = 
  var configObj = app.parseConfigFile()
  if nil == configObj:
    return false

  configObj.useDropBoxBackup = can
  if false == writeConfigObjToFile(configObj):
    return false

  return true

## set config file auto_update field
## TODO: test
proc setConfigAutoUpdate*(can: bool): bool = 
  var configObj = app.parseConfigFile()
  if nil == configObj:
    return false

  configObj.autoUpdate = can
  if false == writeConfigObjToFile(configObj):
    return false

  return true

## set config file update_interval field
## TODO: test
proc setConfigUpdateInterval*(interval: int64): bool = 
  var configObj = app.parseConfigFile()
  if nil == configObj:
    return false

  configObj.updateInterval = interval
  if false == writeConfigObjToFile(configObj):
    return false

  return true

## get passphrase from user 
## TODO: test
proc getPassPhrase*() =
  stdout.write("please enter your passphrase <less than 512 characters>: ")
  
  try:
    var passPhraseString = stdin.readline()
    while passPhraseString.len() > 512:
      stdout.writeln("Invalid input: the length of passphrase you entered is bigger than 512")
      stdout.write("please enter your passphrase again: ")
      passPhraseString = stdin.readline()
  except:
    var errCode = os.osLastError()
    stderr.writeln("Error: failed to read passcode.")
    stderr.writeln(osErrorMsg(errCode))