import globals
import os
import streams
import json

type TConfig* = object
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

## create default config file
proc createConfigFile*(): bool =
  if false == existsAppFolder():
    stderr.writeln("Error: the path \"" & appFolderPath & "\" does not exist")
    return false

  if true == existsConfigFile():
    stderr.writeln("Error: the file \"" & configFilePath & "\" already exists")
    return false

  var configFileStream = streams.newFileStream(configFilePath, system.fmWrite)
  if(nil == configFileStream):
    var errCode = os.osLastError()
    stderr.writeln("Error: failed to create \"" & configFilePath & "\" file.")
    stderr.writeln(osErrorMsg(errCode))
    return false

  streams.writeln(configFileStream, "{")
  streams.writeln(configFileStream, "\t\"auto_update\": false,")
  streams.writeln(configFileStream, "\t\"update_interval\": 30")
  streams.writeln(configFileStream, "}")

  streams.close(configFileStream)

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

  configObj.autoUpdate = parsedConfigFile["auto_update"].bval
  configObj.updateInterval = parsedConfigFile["update_interval"].num

  return configObj

##
##
## get passphrase from user 
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