import os
import globals
import config
import dropbox

var isInitDone = false
var appFolderPath = ""
var passdbFolderPath = ""
var configFilePath = ""
var userFilePath = ""

## some initializations
proc init*(): bool =
  var homeFolder = os.getHomeDir()

  appFolderPath = os.joinPath(homeFolder, globals.APP_FOLDER_NAME) 
  passdbFolderPath = os.joinPath(appFolderPath, globals.PASS_DB_FOLDER_NAME)
  configFilePath = os.joinPath(appFolderPath, globals.CONFIG_FILE_NAME)
  userFilePath = os.joinPath(appFolderPath, globals.USER_FILE_NAME)
  
  isInitDone = true

  return true

## check to see if init proc is called
proc isInitialized(): bool = isInitDone

## get appFolderPath value
proc getAppFolderPath*(): string = 
  return appFolderPath

## get passdbFolderPath value
proc getPassdbFolderPath*(): string = 
  return passdbFolderPath

## get configFilePath value
proc getConfigFilePath*(): string = 
  return configFilePath

## get userFilePath value
proc getUserFilePath*(): string = 
  return userFilePath

## check to see if the app folder exists
proc existsAppFolder*(): bool = 
  if false == isInitialized():
    return false
    
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

## check to see if the passdb folder exists
## TODO: test
proc existsPassdbFolder*(): bool = 
  if false == existsAppFolder():
    return false

  if false == existsFile(passdbFolderPath):
    return false

  return true

## check to see if the passdb folder exists
## TODO: test
proc createPassdbFolder*(): bool = 
  if true == existsPassdbFolder():
    stderr.writeln("Error: the path \"" & passdbFolderPath & "\" already exists")
    return false
  
  try:
    os.createDir(passdbFolderPath)
  except OSError:
    var errCode = os.osLastError()
    stderr.writeln("Error: failed to create \"" & passdbFolderPath & "\" dir.")
    stderr.writeln(osErrorMsg(errCode))
    return false
  
  return true

## check to see if the config file exists
proc existsConfigFile*(): bool =     
  if false == existsAppFolder():
    return false

  if false == existsFile(configFilePath):
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

  var configObj: ref TConfig
  new(configObj)

  configObj.useDropBoxBackup = false
  configObj.autoUpdate = false
  configObj.updateInterval = 0

  if false == config.writeToFile(configObj, configFilePath):
    return false

  return true