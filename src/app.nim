import os
import streams
import json
import oids
import globals
import dropbox

type TConfig* = object
  useDropBoxBackup*: bool
  autoUpdate*: bool
  updateInterval*: int64

type TPassRecord* = object
  title*: string
  username*: string
  password*: string
  email*: string
  date*: string
  description*: string

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

## writes config object values to config file
## TODO: test
proc writeConfigObjToFile(configObj: ref TConfig): bool =
  if false == existsAppFolder():
    stderr.writeln("Error: the path \"" & appFolderPath & "\" does not exist")
    return false

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

  if false == writeConfigObjToFile(configObj):
    return false

  return true;

## parse config file
proc parseConfigFile*(): ref TConfig =
  if(false == existsConfigFile()):
    return nil

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

## create default dropbox user profile
## TODO: test
proc createDropboxUserProfile*(user: ref TDropboxUserInfo; canOverwrite: bool): bool =
  if false == existsAppFolder():
    stderr.writeln("Error: the path \"" & appFolderPath & "\" already exists")
    return false

  if true == existsFile(userFilePath):
    if false == canOverwrite:
      stderr.writeln("Error: a user profile already exists")
      return false

  if "" == dropbox.authenticateUser():
    ##TODO: complete this operation
    stderr.writeln("Error: failed to authenticate dropbox user")
    return false

  var user = dropbox.getUserInfo()
  if nil == user:
    ##TODO: complete this operation
    stderr.writeln("Error: failed to retreive dropbox user info")
    return false

  var userFileStream = streams.newFileStream(userFilePath, system.fmWrite)
  if(nil == userFileStream):
    var errCode = os.osLastError()
    stderr.writeln("Error: failed to create \"" & userFilePath & "\" file.")
    stderr.writeln(osErrorMsg(errCode))
    return false

  streams.writeln(userFileStream, "{")
  streams.writeln(userFileStream, "\t\"dropbox_user_name\": " & user.userName & ",")
  streams.writeln(userFileStream, "\t\"dropbox_user_id\": " & user.userID & ",")
  streams.writeln(userFileStream, "\t\"dropbox_user_display_name\": " & user.userDisplayName & ",")
  streams.writeln(userFileStream, "}")

  streams.close(userFileStream)

  return true

## create and add a new pass record
## TODO: test, implement
proc addPassRecord*( title: string;
                    username: string;
                    password: string;
                    email: string;
                    description: string;
                    date: string ): bool =
  # var passRecord: new(TPassRecord)
  # passRecord.title = title
  # passRecord.username = username
  # passRecord.password = password
  # passRecord.email = email
  # passRecord.description = description
  # passRecord.date = date

  var recordFileName = os.joinPath(passdbFolderPath, $genOid()) 

  var recordFileStream = streams.newFileStream(recordFileName, system.fmWrite)
  if(nil == recordFileStream):
    var errCode = os.osLastError()
    stderr.writeln("Error: failed to create \"" & recordFileName & "\" file.")
    stderr.writeln(osErrorMsg(errCode))
    return false

  streams.writeln(recordFileStream, "{")
  streams.writeln(recordFileStream, "\t\"title\": \"" & title & "\",")
  streams.writeln(recordFileStream, "\t\"username\": \"" & username & "\",")
  streams.writeln(recordFileStream, "\t\"password\": \"" & password & "\",")
  streams.writeln(recordFileStream, "\t\"email\": \"" & email & "\",")
  streams.writeln(recordFileStream, "\t\"description\": \"" & description & "\",")
  streams.writeln(recordFileStream, "\t\"date\": \"" & date & "\",")
  streams.writeln(recordFileStream, "}")

  streams.close(recordFileStream)

  return true