import os
import strutils
import parseopt2
import times
import globals
import condooj

## show command line usage
proc cmdLineUsage():void =
  echo("usage: condooj [--option:][value]")
  echo("example:")
  echo("  condooj --version")
  echo("  condooj --autoupdate:true")

## show command line option, help
## TODO: improve
proc printHelp():void =
  echo("Condooj version : 0.0.1")
  echo("Copyright: Sepehr Aryani © 2015")
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

  echo(" --usedropbox:[true/false]")
  echo("    sets dropbox backup flag")

  echo(" --autoupdate:[true/false]")
  echo("    sets the auto update flag")

  echo(" --updateinterval:[0..1000]")
  echo("    sets the update interval value")

  echo("  --createdropboxuser")
  echo("    authenticates user on dropbox and creates a user profile locally")

## print applicatin version and other related information
proc printVersion():void =
  echo("Condooj version : ", globals.APP_VERSION)

## handle creating a new pass record
proc performAddPassRecord(): bool =
  echo("here we create a new password record, please follow...")
  
  stdout.write("enter a title for your password record: ")
  var title = stdin.readline()

  stdout.write("enter the username: ")
  var username = stdin.readline()

  stdout.write("enter the password: ")
  var password = stdin.readline()

  stdout.write("enter the email you used: ")
  var email = stdin.readline()  

  stdout.write("add some descriptions: ")
  var description = stdin.readline()  
          
  var date = times.getDateStr()

  if false == condooj.addPassRecord(title, username, password, email, description, date):
    return false

## list all pass records
proc performListPassRecords(): bool = 
  for item in condooj.listPassRecords():
    echo(item)

## parse the command-line argument
## TODO: test, improve
proc parseAppCmdLineArgs(): bool =
  for kind, key, value in getopt():
    case kind:
      of cmdArgument, cmdEnd, cmdShortOption:
        stderr.writeln("Error: unrecognized option '" & key &"'") 
        cmdLineUsage()
        return false

      of cmdLongOption:
        case key:
          of "version":
            printVersion()

          of "help":
            printHelp()

          of "add":
            if false == performAddPassRecord():
              return false

          of "list":
            if false == performListPassRecords():
              return false
          
          of "usedropbox":
            let tvalue = toUpper(value)
            if "TRUE" == tvalue:
              if false == condooj.setConfigUseDropBox(true):
                return false
            elif "FALSE" == tvalue:
              if false == condooj.setConfigUseDropBox(false):
                return false
            else:
              stderr.writeln("Error: the option '" & key & "' only accept false or true") 

          of "createdropboxuser":
            #TODO: change the function and complete it
            if false == condooj.createDropboxUserProfile(nil, true):
              return false

          of "autoupdate":
            let tvalue = toUpper(value)
            if "TRUE" == tvalue:
              if false == condooj.setConfigAutoUpdate(true):
                return false
            elif "FALSE" == tvalue:
              if false == condooj.setConfigAutoUpdate(false):
                return false
            else:
              stderr.writeln("Error: the option '" & key & "' only accept false or true") 

          of "updateinterval":
            try:
              let tvalue = parseBiggestInt(value)
              if false == condooj.setConfigUpdateInterval(tvalue):
                return false
            except ValueError:
              stderr.writeln("Error: the option '" & key & "' only accept numbers")               
              return false
            
          else: discard # default case behaviour
        return true

## this is where our cli app starts
proc run*(): bool =
  if false == condooj.init():
    return false

  if false == condooj.existsAppFolder():
    if false == condooj.createAppFolder():
      return false
    if false == condooj.createPassdbFolder():
      return false
    if false == condooj.createConfigFile():
      return false

  var configObj = condooj.parseConfigFile()
  if nil == configObj:
    return false

  if false == parseAppCmdLineArgs():
    return false

  return true