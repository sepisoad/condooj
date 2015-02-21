import os
import json
import oids
import streams
import globals

type TPassRecord* = object
  title*: string
  username*: string
  password*: string
  email*: string
  date*: string
  description*: string

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

## create and add a new pass record
## TODO: test, improve
proc add*(passdbFolderPath: string,
          title: string;
          username: string;
          password: string;
          email: string;
          description: string;
          date: string ): bool =
  var recordFileName = os.joinPath(passdbFolderPath, $genOid()) 

  var recordFileStream = streams.newFileStream(recordFileName, system.fmWrite)
  if(nil == recordFileStream):
    var errCode = os.osLastError()
    stderr.writeln("Error: failed to create \"" & recordFileName & "\" file.")
    stderr.writeln(osErrorMsg(errCode))
    return false

  streams.writeln(recordFileStream, "{")
  streams.writeln(recordFileStream, "\t\"title\": " & json.escapeJson(title) & ",")
  streams.writeln(recordFileStream, "\t\"username\": " & json.escapeJson(username) & ",")
  streams.writeln(recordFileStream, "\t\"password\": " & json.escapeJson(password) & ",")
  streams.writeln(recordFileStream, "\t\"email\": " & json.escapeJson(email) & ",")
  streams.writeln(recordFileStream, "\t\"description\": " & json.escapeJson(description) & ",")
  streams.writeln(recordFileStream, "\t\"date\": " & json.escapeJson(date))
  streams.writeln(recordFileStream, "}")

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