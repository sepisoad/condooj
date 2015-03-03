import os
import globals
import config
import logininfo
import dropbox

var isInitDone = false
var appFolderPath = ""
var passdbFolderPath = ""
var configFilePath = ""
var userProfilePath = ""
var recordsListFilePath = ""

## some initializations
proc init*(): bool =
  var homeFolder = os.getHomeDir()

  appFolderPath = os.joinPath(homeFolder, globals.APP_FOLDER_NAME) 
  configFilePath = os.joinPath(appFolderPath, globals.CONFIG_FILE_NAME)
  passdbFolderPath = os.joinPath(appFolderPath, globals.PASS_DB_FOLDER_NAME)
  recordsListFilePath = os.joinPath(passdbFolderPath, globals.RECORDS_LIST_FILE_NAME)
  userProfilePath = os.joinPath(appFolderPath, globals.USER_FILE_NAME)
  
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

## get userProfilePathPath value
proc getUserProfilePath*(): string = 
  return userProfilePath

## get recordsListFilePath value
proc getRecordsListFilePath*(): string = 
  return recordsListFilePath

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
    stderr.writeln("Error: the path \"" & appFolderPath & "\" does not exist")
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
    stderr.writeln("Error: the path \"" & appFolderPath & "\" does not exist")
    return false

  if false == existsFile(configFilePath):
    return false

  return true

## create config file
proc createConfigFile*(): bool =
  if false == existsAppFolder():
    stderr.writeln("Error: the path \"" & appFolderPath & "\" does not exist")
    return false

  if true == existsConfigFile():
    stderr.writeln("Error: the file \"" & configFilePath & "\" already exists")
    return false

  if false == config.createDefaultConfigFile(configFilePath):
    return false

  return true

## check to see if records list file exists
## TODO: test, implement
proc existsRecordsListFile*(): bool = 
  if false == existsAppFolder():
    stderr.writeln("Error: the path \"" & appFolderPath & "\" does not exist")
    return false

  if false == existsFile(recordsListFilePath):
    return false

  return true

## create records list file user profile
## TODO: test, implement
proc createRecordsListFile*(): bool =
  if true == existsRecordsListFile():
    stderr.writeln("Error: the file \"" & recordsListFilePath & "\" already exists")
    return false

  if false == logininfo.createRecordList(recordsListFilePath):
    return false

  return true

## check to see if user profile exist
## TODO: test, implement
proc existsUserProfile*(): bool = true

## create default user profile
## TODO: test, implement
proc createDefaultUserProfile*(): bool = true