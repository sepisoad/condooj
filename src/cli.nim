import os
import strutils
import parseopt2
import times
import globals
import app
import config
import profile
import passrecord
import protection

var passPhrase: TDigest
var optParser: OptParser

## show command line usage
proc printCmdLineUsage() =
  echo("usage: condooj [--option:][value]")
  echo("example:")
  echo("  condooj --version")
  echo("  condooj --autoupdate:true")

## show command line option, help
## TODO: improve
proc performOptionHelp() =
  echo("Condooj version : 0.0.1")
  echo("Copyright: Sepehr Aryani © 2015")
  echo("License: GPLv3")
  echo("Github: https://github.com/sepisoad/condooj")
  echo("Twitter: @sepisoad")
  echo("====================")
  echo("here is the list of available options:")
  
  echo(" --version")
  echo("    shows version number")

  echo(" --help")
  echo("    shows help")

  echo(" --add")
  echo("    creates a new password record")

  echo(" --del")
  echo("    delete an existing password record")

  echo(" --update")
  echo("    update an existing password record")

  echo(" --list")
  echo("    lists all existing password record")



## print applicatin version and other related information
proc performOptionVersion() =
  echo("Condooj version : ", globals.APP_VERSION)

## delete an axisting pass record
## TODO: test, improve
proc performOptionDel(title: string) = 
  if false == passrecord.delete(app.getPassdbFolderPath(), 
                                app.getRecordsListFilePath(), 
                                title):
    stderr.writeln("Error: failed to delete item '" & title & "'")

## list all pass records
## TODO: test, improve
proc performOptionList() = 
  var passRecordsList = passrecord.list(app.getRecordsListFilePath())
  if nil == passRecordsList:
    stderr.writeln("Error: failed to list items")

  for item in passrecord.list(app.getRecordsListFilePath()):
    echo(item)

## add a new passrecord
## TODO: test, improve
proc performOptionAdd() = 
  var title: string = nil
  var username: string = nil
  var password: string = nil
  var email: string = "UNDEFINED"
  var description: string = "UNDEFINED"
  var date = times.getDateStr()

  while true:
    optParser.next()

    if cmdLongOption != optParser.kind:
      # echo(repr(optParser))
      # echo(repr(optParser.kind))
      # echo("DEBUG: Yo")
      break

    case optParser.key:
      of "title":
        title = optParser.val

      of "username":
        username = optParser.val

      of "password":
        password = optParser.val

      of "email":
        email = optParser.val

      of "description":
        description = optParser.val

      else: 
        stderr.writeln("Error: '" & optParser.key & "' is not a valid option")
        return
  
  if nil == title:
    stderr.writeln("Error: you have to add a title for your password record using '--title'") 
    return

  if nil == username:
    stderr.writeln("Error: you have to add a username for your password record using '--username'") 
    return

  if nil == password:
    stderr.writeln("Error: you have to add a password for your password record using '--password'") 
    return

  if false == passrecord.add( app.getPassdbFolderPath(), 
                              app.getRecordsListFilePath(), 
                              title, 
                              username, 
                              password, 
                              email, 
                              description, 
                              date):
    stderr.writeln("Error: failed to add item '" & title & "'")

## update an existing passrecord
## TODO: test, implement
proc performOptionUpdate() = 
  echo("NOT IMPLEMENTED")

## parse the command-line argument
## TODO: test, improve
proc parseAppCmdLineArgs() =
  if 0 == os.commandLineParams().len:
    printCmdLineUsage()
    return

  optParser = initOptParser()
  optParser.next()
    
  if cmdLongOption != optParser.kind:
    return
  
  case optParser.key:
    of "version":
      performOptionVersion()

    of "help":
      performOptionHelp()

    of "list":
      performOptionList()

    of "del":
      performOptionDel(optParser.val)

    of "add":
      # echo(repr(optParser))
      # optParser.next()
      # echo(repr(optParser))
      performOptionAdd()

    of "update":
      performOptionUpdate()

    else: 
      stderr.writeln("Error: '" & optParser.key & "' is not a valid option")

## this is where our cli app starts
proc run*(): bool =
  if false == app.init():
    return false

  if false == app.existsAppFolder():
    if false == app.createAppFolder():
      return false
    if false == app.createPassdbFolder():
      return false
    if false == app.createRecordsListFile():
      return false
    if false == app.createConfigFile():
      return false

  parseAppCmdLineArgs()
  return true
