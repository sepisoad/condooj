import os
import strutils
import logging
import json
import times #todo: enhance inclusion

type 
  AppInitResult* = enum
    airSuccessful = 0,
    airNoProfile,
    airFailed

  DatabaseCMD* = enum
    DBCMD_ADD = 0,
    DBCMD_DELETE,
    DBCMD_EDIT

  Profile* = ref object
    passPhrase: string # pass phrase
    code: string
    token: string
    typ: string
    uid: string

  LoginRecord* = ref object
    title*: string
    username*: string
    password*: string
    email*: string
    date*: string
    description*: string
    tags*: seq[string]

  LoginTable* = seq[LoginRecord]
    # records*: seq[LoginRecord]

const APP_FOLDER_NAME = ".condooj"
const PROFILE_NAME = "condooj.profile"
const CONFIG_NAME = "condooj.config"
const LOGFILE_NAME = "condooj.log"
const DBFILE_NAME = "condooj.db"
const PROFILE_OPT_PASSPHRASE = "pass_phrase"
const PROFILE_OPT_CODE = "auth_code"
const PROFILE_OPT_TOKEN = "access_token"
const PROFILE_OPT_TYPE = "token_type"
const PROFILE_OPT_UID = "app_uid"
const RECORD_OPT_TITLE = "title"
const RECORD_OPT_USERNAME = "username"
const RECORD_OPT_PASSWORD = "password"
const RECORD_OPT_EMAIL = "email"
const RECORD_OPT_DATE = "date"
const RECORD_OPT_DESCRIPTION = "description"
const RECORD_OPT_TAGS = "tags"

var fileLogger: RollingFileLogger = nil
var consoleLogger: ConsoleLogger  = nil

proc newProfile*(): Profile = 
  new(result)
  result.passPhrase = ""
  result.code = ""
  result.token = ""
  result.typ = ""
  result.uid = ""

proc newProfile*( passPhrase: string, 
                  code: string, 
                  token: string, 
                  typ: string, 
                  uid: string): Profile = 
  new(result)
  result.passPhrase = passPhrase
  result.code = code
  result.token = token
  result.typ = typ
  result.uid = uid

proc newProfile*(passPhrase: string, code: string, response: string): Profile =
  new(result)
  var responseTags = parseJson(response)
  result.passPhrase = passPhrase
  result.code = code
  result.token = replace($responseTags["access_token"], "\"", "")
  result.typ = replace($responseTags["token_type"], "\"", "")
  result.uid = replace($responseTags["uid"], "\"", "")

proc toJson*(profile: Profile): JsonNode = 
  result = newJObject()
  var jStrPassPhrase = newJString(replace(profile.passPhrase, "\"", ""))
  var jStrCode = newJString(replace(profile.code, "\"", ""))
  var jStrToken = newJString(replace(profile.token, "\"", ""))
  var jStrType = newJString(replace(profile.typ, "\"", ""))
  var jStrUid = newJString(replace(profile.uid, "\"", ""))
  result.add(PROFILE_OPT_PASSPHRASE, jStrPassPhrase)
  result.add(PROFILE_OPT_CODE, jStrCode)
  result.add(PROFILE_OPT_TOKEN, jStrToken)
  result.add(PROFILE_OPT_TYPE, jStrType)
  result.add(PROFILE_OPT_UID, jStrUid)
  debug($result)

proc toProfile*(profile: string): Profile = 
  var json: JsonNode

  try:
    json = parseJson(profile)
    var passPhrase = json[PROFILE_OPT_PASSPHRASE].str
    var code = json[PROFILE_OPT_CODE].str
    var token = json[PROFILE_OPT_TOKEN].str
    var typ = json[PROFILE_OPT_TYPE].str
    var uid = json[PROFILE_OPT_UID].str
    result = newProfile(passPhrase, code, token, typ, uid)
  except ValueError:
    debug(profile)
    fatal("failed to parse profile", getCurrentExceptionMsg())
    return nil
  except JsonParsingError:
    debug(profile)
    fatal("failed to parse profile", getCurrentExceptionMsg())
    return nil


proc newLoginRecord*( title: string, 
                      username: string, 
                      password: string, 
                      email: string, 
                      date: string = "",
                      description: string,
                      tags: seq[string]): LoginRecord =
  new(result)
  result.title = title
  result.username = username
  result.password = password
  result.email = email
  if "" == date:
    result.date = getDateStr()
  else: 
    result.date = date
  result.description = description
  result.tags = tags

proc toJson*(rec: LoginRecord): JsonNode = 
  result = newJObject()
  var jStrTitle = newJString(rec.title)
  var jStrUsername = newJString(rec.username)
  var jStrPassword = newJString(rec.password)
  var jStrEmail = newJString(rec.email)
  var jStrDescription = newJString(rec.description)
  var jStrDate = newJString(rec.date)
  var jStrArrTags = newJArray()
  for item in rec.tags:
    jStrArrTags.add(newJString(item))
  result.add(RECORD_OPT_TITLE, jStrTitle)
  result.add(RECORD_OPT_USERNAME, jStrUsername)
  result.add(RECORD_OPT_PASSWORD, jStrPassword)
  result.add(RECORD_OPT_EMAIL, jStrEmail)
  result.add(RECORD_OPT_DATE, jStrDate)
  result.add(RECORD_OPT_DESCRIPTION, jStrDescription)
  result.add(RECORD_OPT_TAGS, jStrArrTags)
  debug($result)

proc toLoginRecord*(record: string): LoginRecord = 
  debug("toLoginRecord() called")
  try:
    var json = parseJson(record)
    if nil == json or "" == $json:
      return nil
    var title = json[RECORD_OPT_TITLE].str
    var username = json[RECORD_OPT_USERNAME].str
    var password = json[RECORD_OPT_PASSWORD].str
    var email = json[RECORD_OPT_EMAIL].str
    var date = json[RECORD_OPT_DATE].str
    var description = json[RECORD_OPT_DESCRIPTION].str
    var tags: seq[string] = @[]
    for tag in items(json[RECORD_OPT_TAGS].elems):
      tags.add(tag.str)
    result = newLoginRecord(title, 
                            username, 
                            password, 
                            email, 
                            date, 
                            description,
                            tags)
  except Exception:
    fatal("failed to parse login record")
    return nil
  except FieldError:
    fatal("failed to parse login record")
    return nil
  except ValueError:
    fatal("failed to parse login record")
    return nil
  except JsonParsingError:
    fatal("failed to parse login record")
    return nil

proc newLoginTable*(): LoginTable =
  result = @[]

proc remove*(lt: var LoginTable, lr: LoginRecord): bool =
  var index: int = 0
  result = false
  for item in items(lt):
    index += 1
    if item.title == lr.title:
      if item.username == lr.username:
        result = true
        break
  if result:
    lt.delete(index)

proc update*( table: LoginTable, 
              title: string,
              newRec: LoginRecord): bool =
  var index: int = 0
  result = false
  for item in items(table):
    index += 1
    if item.title == title:
      item.title = newRec.title
      item.username = newRec.username
      item.password = newRec.password
      item.email = newRec.email
      item.date = newRec.date
      item.description = newRec.description
      item.tags = newRec.tags

      result = true
      break

proc getAppFolderPath(): string =
  return joinPath(getHomeDir(), APP_FOLDER_NAME)

proc getProfilePath(): string = 
  return joinPath(getAppFolderPath(), PROFILE_NAME)

proc getConfigPath(): string = 
  return joinPath(getAppFolderPath(), CONFIG_NAME)  

proc getLogfilePath(): string = 
  return joinPath(getAppFolderPath(), LOGFILE_NAME)

proc getDbfilePath(): string = 
  return joinPath(getAppFolderPath(), DBFILE_NAME)  

#todo: 
proc getDefaultConfig(): string = 
  return "FUCK..."

#todo:
#some comments
proc isProfileValid*(): bool = 
  return true

proc appFolderExists(): bool =
  if not dirExists(getAppFolderPath()):
    return false
  return true

proc profileExists(): bool = 
  if not fileExists(getProfilePath()):
    return false
  return true

proc configExists(): bool = 
  if not fileExists(getConfigPath()):
    return false
  return true

# proc logfileExists(): bool = 
#   if not fileExists(getLogfilePath()):
#     return false
#   return true

proc dbfileExists(): bool = 
  if not fileExists(getDbfilePath()):
    return false
  return true

proc createAppFolder(): bool = 
  debug("createAppFolder() called")
  if appFolderExists():
    info("app folder already exists")
    return true
  try:
    createDir(getAppFolderPath())
  except OSError:
    debug(getAppFolderPath())
    fatal("failed to create app folder, an os error happened: ", getCurrentExceptionMsg())
    return false
  return true

proc createLogfile(): bool = 
  debug("createLogfile() called")
  if not appFolderExists():
    error("failed to create logfile, there is no app folder")
    return false
  try:
    if fileExists(getLogfilePath()):
      fileLogger = newRollingFileLogger(filename = getLogfilePath(),
        mode = fmAppend,
        levelThreshold = lvlAll,
        fmtStr = verboseFmtStr,
        maxLines = 2048.int)
    else:
      fileLogger = newRollingFileLogger(getLogfilePath(),
        mode = fmReadWrite ,
        levelThreshold = lvlAll,
        fmtStr = verboseFmtStr,
        maxLines = 2048.int)
  except Exception:
    fatal("failed to create logfile, an exeption happened: ", getCurrentExceptionMsg())
    return false
  except IOError:
    fatal("failed to create logfile, an io error happened: ", getCurrentExceptionMsg())
    return false
  except OverflowError:
    fatal("failed to create logfile, an overflow error happened: ", getCurrentExceptionMsg())
    return false
  addHandler(fileLogger)
  return true

proc createConfig(): bool = 
  debug("createConfig() called")
  if not appFolderExists():
    error("failed to create config, there is no app folder")
    return false
  var configFile: File 
  if not configFile.open(getConfigPath(), fmWrite):
    debug(getConfigPath())
    error("failed to create config, cannot open file to write")
  defer: configFile.close()
  configFile.write(getDefaultConfig())
  return true

proc createProfile*(profile: Profile): bool =
  debug("createProfile() called")
  if not appFolderExists():
    error("failed to create profile, there is no app folder")
    return false
  var profileFile: File 
  if not profileFile.open(getProfilePath(), fmWrite):
    debug(getProfilePath())
    error("failed to create profile, cannot open file to write")
  defer: profileFile.close()
  var jsonProfile = profile.toJson()
  profileFile.write(jsonProfile.pretty())
  return true

proc createDB*(): bool = 
  debug("createDB() called")
  if not appFolderExists():
    error("failed to create database file, there is no app folder")
    return false
  var dbFile: File
  if not dbFile.open(getDbfilePath(), fmWrite):
    debug(getDbfilePath())
    error("failed to create database file, cannot open file to write")
    return false
  defer: dbFile.close()
  dbFile.write("[]")
  return true

proc loadDB*(): LoginTable = 
  debug("loadDB() called")
  if not dbfileExists():
    error("failed to load database, the database file does not exist")
    return nil
  var dbFile: File
  if not dbFile.open(getDbfilePath(), fmRead):
    debug(getDbfilePath())
    error("failed to load database file, cannot open file to read")
    return nil
  defer: dbFile.close()

  var dbContent = dbFile.readAll()
  try:
    var jsonObjTable = parseJson(dbContent)
    result = newLoginTable()
    for jsonObjRecord in items(jsonObjTable):
      var record = toLoginRecord($jsonObjRecord)
      if nil != record:
        result.add(record)

  except FieldError:
    debug(getDbfilePath())
    fatal("failed to parse database content[FieldError]: ", getCurrentExceptionMsg())
    return nil
  except IOError:
    debug(getDbfilePath())
    fatal("failed to parse database content[IOError]: ", getCurrentExceptionMsg())
    return nil
  except ValueError:
    debug(getDbfilePath())
    fatal("failed to parse database content[ValueError]: ", getCurrentExceptionMsg())
    return nil
  except JsonParsingError:
    debug(getDbfilePath())
    fatal("failed to parse database content[JsonParsingError]: ", getCurrentExceptionMsg())
    return nil

proc updateDB*(lt: LoginTable): bool = 
  debug("updateDB() called")
  if not dbfileExists():
    error("failed to load database, the database file does not exist")
    return false
  var dbFile: File
  if not dbFile.open(getDbfilePath(), fmWrite):
    debug(getDbfilePath())
    error("failed to load database file, cannot open file to read")
    return false
  defer: dbFile.close()

  try:
    var tableNode = newJArray()
    for record in items(lt):
      var recordNode = toJson(record)
      tableNode.add(recordNode)
    dbFile.write($tableNode)
  except FieldError:
    debug(getDbfilePath())
    fatal("failed to parse database content[FieldError]: ", getCurrentExceptionMsg())
    return false
  except IOError:
    debug(getDbfilePath())
    fatal("failed to parse database content[IOError]: ", getCurrentExceptionMsg())
    return false
  except ValueError:
    debug(getDbfilePath())
    fatal("failed to parse database content[ValueError]: ", getCurrentExceptionMsg())
    return false
  except JsonParsingError:
    debug(getDbfilePath())
    fatal("failed to parse database content[JsonParsingError]: ", getCurrentExceptionMsg())
    return false
  return true

proc recordExists(lt: LoginTable, lr: LoginRecord): bool = 
  for record in items(lt):
    if lr.title == record.title:
      if lr.username == record.username:
        return true
  return false

proc dbAdd*(lr: var LoginRecord): tuple[isOk: bool, msg: string] = 
  debug("dbAdd() called")
  var lt = loadDB()
  if nil == lt:
    result.isOk = false
    result.msg = "failed to load data base"
    return
  if recordExists(lt, lr):
    result.isOk = false
    result.msg = "this login information already exists"
    return
  lt.add(lr)
  if not updateDB(lt):
    result.isOk = false
    result.msg = "failed to add login record to  data base"
    return
  result.isOk = true
  result.msg = "ok"

proc dbRemove*(lr: var LoginRecord): tuple[isOk: bool, msg: string] = 
  debug("dbRemove() called")
  var lt = loadDB()
  if nil == lt:
    result.isOk = false
    result.msg = "failed to load data base"
    return
  if not recordExists(lt, lr):
    result.isOk = false
    result.msg = "cannot locate login information in data base"
    return
  discard lt.remove(lr)
  if not updateDB(lt):
    result.isOk = false
    result.msg = "failed to remove login record from data base"
    return
  result.isOk = true
  result.msg = "ok"

proc isDateStringCorrect*(dstr: string): bool = 
  try:
    discard parse(dstr, "YYYY-MM-DD")
  except ValueError:
    return false
  except OverflowError:
    return false
  except RangeError:
    return false
  return true

proc initApp*(): AppInitResult = 
  consoleLogger = newConsoleLogger(levelThreshold = lvlAll)
  addHandler(consoleLogger)

  debug("initApp() called")
  if not appFolderExists():
    if not createAppFolder():
      return airFailed
  if not createLogfile():
    return airFailed  
  if not configExists():
    if not createConfig():
      return airFailed
  if not profileExists():
    return airNoProfile
  if not dbfileExists():
    if not createDB():
      return airFailed