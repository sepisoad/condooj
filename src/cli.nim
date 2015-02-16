import os
import strutils
import parseopt2
import app
# import sha1


var passPhraseBuffer*: array[0..511, uint8]
var passPhraseDigest*: array[0..19, uint8]

## show command line usage
proc cmdLineUsage():void =
  echo("usage: condooj [--option:][value]")
  echo("example:")
  echo("  condooj --version")
  echo("  condooj --autoupdate:true")

## show command line option, help
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

  echo(" --usedropbox:[true/false]")
  echo("    sets dropbox backup flag")

  echo(" --autoupdate:[true/false]")
  echo("    sets the auto update flag")

  echo(" --updateinterval:[0..1000]")
  echo("    sets the update interval value")

## print applicatin version and other related information
proc printVersion*():void =
  echo("Condooj version : 0.0.1")

## parse the command-line argument
proc parseAppCmdLineArgs*(): bool =
  let options = initOptParser()

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

          of "usedropbox":
            let tvalue = toUpper(value)
            if "TRUE" == tvalue:
              if false == app.setConfigUseDropBox(true):
                return false
            elif "FALSE" == tvalue:
              if false == app.setConfigUseDropBox(false):
                return false
            else:
              stderr.writeln("Error: the option '" & key & "' only accept false or true") 

          of "autoupdate":
            let tvalue = toUpper(value)
            if "TRUE" == tvalue:
              if false == app.setConfigAutoUpdate(true):
                return false
            elif "FALSE" == tvalue:
              if false == app.setConfigAutoUpdate(false):
                return false
            else:
              stderr.writeln("Error: the option '" & key & "' only accept false or true") 

          of "updateinterval":
            try:
              let tvalue = parseBiggestInt(value)
              if false == app.setConfigUpdateInterval(tvalue):
                return false
            except ValueError:
              stderr.writeln("Error: the option '" & key & "' only accept numbers")               
              return false
            
          else: discard # default case behaviour
        return true

## this is where our cli app starts
proc run*(): bool =
  if false == app.existsAppFolder():
    if false == app.createAppFolder():
      return false
    if false == app.createConfigFile():
      return false

  var configObj = app.parseConfigFile()
  if nil == configObj:
    return false

  if false == parseAppCmdLineArgs():
    return false
  
  #if true == configObj.useDropBoxBackup:
    # TODO
    # if the user hase a dropbox account and sets the config to use it as backup storage then the
    # app should first check if the user has 

  return true