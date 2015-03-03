import os
import json
import oids
import streams
import globals
import protection

type Tlogininfo* = object
  title*: string
  username*: string
  password*: string
  email*: string
  date*: string
  description*: string

## create pass record list file
## TODO: test, improve 
proc createRecordList*(recordsListFilePath: string): bool =
  var jsonData: string = ""
  jsonData &= "{\n"
  jsonData &= "}"

  var recordListFileStream = streams.newFileStream(recordsListFilePath, system.fmWrite)
  if(nil == recordListFileStream):
    var errCode = os.osLastError()
    stderr.writeln("Error: failed to create \"" & recordsListFilePath & "\" file.")
    stderr.writeln(osErrorMsg(errCode))
    return false

  streams.writeln(recordListFileStream, jsonData)
  streams.close(recordListFileStream)

  return true

## read logininfo file data into a Tlogininfo structure
## TODO: test, improve 
proc getlogininfoFromFile(logininfoFileNamePath: string, key: TDigest): ref Tlogininfo =
  var loginFile: File
  if false == system.open(loginFile, logininfoFileNamePath, fmRead):
    var errCode = os.osLastError()
    stderr.writeln("Error: failed to open \"" & logininfoFileNamePath & "\" file.")
    stderr.writeln(osErrorMsg(errCode))
    return nil

  var fileInfo: FileInfo
  try:
    fileInfo = os.getFileInfo(loginFile)
  except OSError:
    stderr.writeln(getCurrentExceptionMsg())
    system.close(loginFile)
    return nil

  var recordListFileStream = streams.newFileStream(loginFile)
  if(nil == recordListFileStream):
    var errCode = os.osLastError()
    stderr.writeln("Error: failed to read \"" & logininfoFileNamePath & "\" file.")
    stderr.writeln(osErrorMsg(errCode))
    return nil

  var decryptedBuffer = protection.decryptFile(logininfoFileNamePath, key)
  if nil == decryptedBuffer:
    var errCode = os.osLastError()
    stderr.writeln("Error: failed to decrypt information stored in \"" & logininfoFileNamePath & "\" file.")
    stderr.writeln(osErrorMsg(errCode))
    return nil

  var jsonNode: JsonNode = nil
  try:
    jsonNode = parseJson(decryptedBuffer)
  except Exception:
    stderr.writeln("Error: the login file is broken.")
    stderr.writeln(getCurrentExceptionMsg())
    return nil

  new(result)
  try:
    result.title = jsonNode["title"].str
    result.username = jsonNode["username"].str
    result.password = jsonNode["password"].str
    result.email = jsonNode["email"].str
    result.description = jsonNode["description"].str
    result.date = jsonNode["date"].str
  except Exception:
    stderr.writeln("Error: the file \"" & logininfoFileNamePath & "\" is broken.")
    return nil

## add a new entry to record list file
## TODO: test, improve 
proc addEntryToRecordList(listFilePath: string, entryFileName: string, entryTitle: string): bool =
  var jsonData: string = ""
  var jsonParser: JsonParser
  var jsonNode: JsonNode = nil

  try:
    jsonNode = parseFile(listFilePath)
  except Exception:
    stderr.writeln("Error: failed to read \"" & listFilePath & "\" file.")
    stderr.writeln(getCurrentExceptionMsg())
    return false
  

  if true == jsonNode.hasKey(json.escapeJson(entryTitle)):
    stderr.writeln("Error: the entry '" & entryTitle & "' already exists.")
    return false    

  jsonNode.add(entryTitle, newJString(entryFileName))

  var recordListFileStream = streams.newFileStream(listFilePath, system.fmWrite)
  if(nil == recordListFileStream):
    var errCode = os.osLastError()
    stderr.writeln("Error: failed to create \"" & listFilePath & "\" file.")
    stderr.writeln(osErrorMsg(errCode))
    return false
  
  recordListFileStream.write($jsonNode)
  recordListFileStream.close()

  return true

## delete entry from list file
## TODO: test, improve 
proc deleteEntryFromRecordList(listFilePath: string, entryTitle: string): bool =
  var jsonData: string = ""
  var jsonParser: JsonParser
  var jsonNode: JsonNode = nil

  try:
    jsonNode = parseFile(listFilePath)
  except Exception:
    stderr.writeln("Error: failed to read \"" & listFilePath & "\" file.")
    stderr.writeln(getCurrentExceptionMsg())
    return false
  

  if true == jsonNode.hasKey(json.escapeJson(entryTitle)):
    stderr.writeln("Error: the entry '" & entryTitle & "' already exists.")
    return false    

  jsonNode.delete(entryTitle)

  var recordListFileStream = streams.newFileStream(listFilePath, system.fmWrite)
  if(nil == recordListFileStream):
    var errCode = os.osLastError()
    stderr.writeln("Error: failed to create \"" & listFilePath & "\" file.")
    stderr.writeln(osErrorMsg(errCode))
    return false
  
  recordListFileStream.write($jsonNode)
  recordListFileStream.close()

  return true

## get list of entries from list file
## TODO: test, improve 
proc getEntryFilesList(listFilePath: string): seq[string] =
  var jsonData: string = ""
  var jsonParser: JsonParser
  var jsonNode: JsonNode = nil

  try:
    jsonNode = parseFile(listFilePath)
  except Exception:
    stderr.writeln("Error: failed to read \"" & listFilePath & "\" file.")
    stderr.writeln(getCurrentExceptionMsg())
    return nil
  
  result = @[]
  for key, value in pairs(jsonNode):
    result.add(key)
  

## finds the corresponding file name of a title
## TODO: test, improve
proc convertTitleToFile(listFilePath: string, title: string): string =
  var jsonData: string = ""
  var jsonParser: JsonParser
  var jsonNode: JsonNode = nil

  try:
    jsonNode = parseFile(listFilePath)
  except Exception:
    stderr.writeln("Error: failed to read \"" & listFilePath & "\" file.")
    stderr.writeln(getCurrentExceptionMsg())
    return nil

  for key, value in pairs(jsonNode):
    if title == key:
      return value.str

  return nil


## parse pass record file
## TODO: test, improve 
proc parse*(path: string): ref Tlogininfo =
  new(result)

  # TODO: add a nice error msg
  if false == os.existsFile(path):
    return nil

  # TODO: handle exception more carefully
  var jsonObj: JsonNode
  try:
    jsonObj = json.parseFile(path)
  except Exception, IOError, ValueError, JsonParsingError:
    stderr.writeln("Error: failed to read \"" & path & "\" file.")
    stderr.writeln(getCurrentExceptionMsg())
    return nil

  result.title = jsonObj["title"].str
  result.username = jsonObj["username"].str
  result.password = jsonObj["password"].str
  result.email = jsonObj["email"].str
  result.description = jsonObj["description"].str
  result.date = jsonObj["date"].str

## create and add a new pass record
## TODO: test, improve
proc add*(passdbFolderPath: string,
          recordsListFilePath: string,
          digest: TDigest,
          title: string,
          username: string,
          password: string,
          email: string,
          description: string,
          date: string ): bool =
  var recordFileName = $genOid() 
  var fullRecordFileName = os.joinPath(passdbFolderPath, recordFileName) 

  if false == addEntryToRecordList(recordsListFilePath, recordFileName, title):
    return false

  # var recordFileStream = streams.newFileStream(fullRecordFileName, system.fmWrite)
  # if(nil == recordFileStream):
  #   var errCode = os.osLastError()
  #   stderr.writeln("Error: failed to create \"" & fullRecordFileName & "\" file.")
  #   stderr.writeln(osErrorMsg(errCode))
  #   return false

  var rawJsonData: string = ""
  rawJsonData &= "{\n"
  rawJsonData &= "\t\"title\": " & json.escapeJson(title) & ",\n"
  rawJsonData &= "\t\"username\": " & json.escapeJson(username) & ",\n"
  rawJsonData &= "\t\"password\": " & json.escapeJson(password) & ",\n"
  rawJsonData &= "\t\"email\": " & json.escapeJson(email) & ",\n"
  rawJsonData &= "\t\"description\": " & json.escapeJson(description) & ",\n"
  rawJsonData &= "\t\"date\": " & json.escapeJson(date) & "\n"
  rawJsonData &= "}"

  var encryptedJasonBuffer = protection.encryptBuffer(rawJsonData, digest)
  if false == protection.saveEncryptedBuffer( fullRecordFileName, 
                                              encryptedJasonBuffer):
    var errCode = os.osLastError()
    stderr.writeln("Error: failed to save data into \"" & fullRecordFileName & "\" file.")
    stderr.writeln(osErrorMsg(errCode))
    return false

  # streams.writeln(recordFileStream, encryptedJasonBuffer.buffer)
  # streams.close(recordFileStream)

  return true

## delete an existing pass record
## TODO: test, improve
proc delete*( passdbFolderPath: string,
              recordsListFilePath: string,
              title: string): bool =
  var logininfoFileName = convertTitleToFile(recordsListFilePath, title)
  if nil == logininfoFileName:
    stderr.writeln("Error: failed to delete \"" & title & "\" item.")
    return false

  if false == deleteEntryFromRecordList(recordsListFilePath, title):
    return false

  var logininfoFilePath = os.joinPath(passdbFolderPath, logininfoFileName)
  try:
    os.removeFile(logininfoFilePath)
  except OSError:
    stderr.writeln("Error: failed to delete \"" & logininfoFilePath & "\" file.")
    stderr.writeln(getCurrentExceptionMsg())
    return false

  return true

## update an existing pass record
## TODO: test, improve
proc update*( passdbFolderPath: string,
              recordsListFilePath: string,
              digest: TDigest,
              title: string,
              newtitle: string,
              username: string,
              password: string,
              email: string,
              description: string,
              date: string): bool =
  var logininfoFileName = convertTitleToFile(recordsListFilePath, title)
  if nil == logininfoFileName:
    return false

  var logininfoFileNamePath = os.joinPath(passdbFolderPath, logininfoFileName)

  var logininfo = getlogininfoFromFile(logininfoFileNamePath, digest)
  if nil == logininfo:
    return false

  if false == delete( passdbFolderPath,
                      recordsListFilePath, 
                      title):
    return false

  if nil != newtitle:
    logininfo.title = newtitle

  if nil != username:
    logininfo.username = username

  if nil != logininfo:
    logininfo.password = password

  if nil != email:
    logininfo.email = email

  if nil != description:
    logininfo.description = description

  if false == add(passdbFolderPath,
                  recordsListFilePath,
                  digest,
                  logininfo.title,
                  logininfo.username,
                  logininfo.password,
                  logininfo.email,
                  logininfo.description,
                  date):
    return false

  return true

## show the login information
## TODO: test, improve
proc show*( passdbFolderPath: string,
            recordsListFilePath: string,
            digest: TDigest,
            title: string): ref Tlogininfo =
  result = nil
  var logininfoFileName = convertTitleToFile(recordsListFilePath, title)
  if nil == logininfoFileName:
    return nil

  var logininfoFileNamePath = os.joinPath(passdbFolderPath, logininfoFileName)

  result = getlogininfoFromFile(logininfoFileNamePath, digest)
  if nil == result:
    return nil

## get a list of all pass records
## TODO: test, improve
proc list*(recordsListFilePath: string): seq[string] = 
  getEntryFilesList(recordsListFilePath)