import os
import json
import oids
import streams
import globals
import protection

type TPassRecord* = object
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
    stderr.writeln("Error: Exception.")
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

## parse pass record file
## TODO: test, improve 
proc parse*(path: string): ref TPassRecord =
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
    return nil

  result.title = jsonObj["title"].str
  result.username = jsonObj["username"].str
  result.password = jsonObj["password"].str
  result.email = jsonObj["email"].str
  result.description = jsonObj["description"].str
  result.date = jsonObj["date"].str

  #jsonObj.close()

## create and add a new pass record
## TODO: test, improve
proc add*(passdbFolderPath: string,
          recordsListFilePath: string,
          title: string;
          username: string;
          password: string;
          email: string;
          description: string;
          date: string ): bool =
  var recordFileName = $genOid() 
  var fullRecordFileName = os.joinPath(passdbFolderPath, recordFileName) 

  if false == addEntryToRecordList(recordsListFilePath, recordFileName, title):
    return false

  var recordFileStream = streams.newFileStream(fullRecordFileName, system.fmWrite)
  if(nil == recordFileStream):
    var errCode = os.osLastError()
    stderr.writeln("Error: failed to create \"" & fullRecordFileName & "\" file.")
    stderr.writeln(osErrorMsg(errCode))
    return false

  var rawJsonData: string = ""
  rawJsonData &= "{\n"
  rawJsonData &= "\t\"title\": " & json.escapeJson(title) & ",\n"
  rawJsonData &= "\t\"username\": " & json.escapeJson(username) & ",\n"
  rawJsonData &= "\t\"password\": " & json.escapeJson(password) & ",\n"
  rawJsonData &= "\t\"email\": " & json.escapeJson(email) & ",\n"
  rawJsonData &= "\t\"description\": " & json.escapeJson(description) & ",\n"
  rawJsonData &= "\t\"date\": " & json.escapeJson(date) & ",\n"
  rawJsonData &= "}"

  #TODO: to the encryption here before saving the raw jason data into file

  streams.writeln(recordFileStream, rawJsonData)
  streams.close(recordFileStream)

  return true

## get a list of all pass records
## TODO: test, improve
proc list*(passdbFolderPath: string): seq[string] = 
  result = @[]
  
  for kind, path in walkDir(passdbFolderPath):
    case kind 
      of pcFile: 
        var record = parse(path)
        if nil == record:
          return nil
        result.add(record.title)
      else: discard