import os
import strutils
import parseopt2
import times
import globals
import app
import config
import profile
import logininfo
import protection
import autopassword

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

  echo(" --show")
  echo("    shows the specified login information")

  echo(" --add")
  echo("    creates a new login record")

  echo(" --del")
  echo("    delete an existing login record")

  echo(" --update")
  echo("    update an existing login record")

  echo(" --list")
  echo("    lists all existing login record")



## print applicatin version and other related information
proc performOptionVersion() =
  echo("Condooj version : ", globals.APP_VERSION)

## delete an axisting login record
## TODO: test, improve
proc performOptionDel(title: string) = 
  if false == logininfo.delete(app.getPassdbFolderPath(), 
                                app.getRecordsListFilePath(), 
                                title):
    stderr.writeln("Error: failed to delete item '" & title & "'")

## list all record records
## TODO: test, improve
proc performOptionList() = 
  var logininfosList = logininfo.list(app.getRecordsListFilePath())
  if nil == logininfosList:
    stderr.writeln("Error: failed to list items")

  for item in logininfo.list(app.getRecordsListFilePath()):
    echo(item)

## add a new login record
## TODO: test, improve
proc performOptionAdd() = 
  var passphrase: string = nil
  var title: string = nil
  var username: string = nil
  var password: string = nil
  var email: string = "UNDEFINED"
  var description: string = "UNDEFINED"
  var date = times.getDateStr()
  var canUseAutoPassword: bool = false
  var passwordLen: int = 0
  var canUseUpperCase: bool = false
  var canUseLowerCase: bool = false
  var canUseSymbol: bool = false
  var canUseNumber: bool = false

  while true:
    optParser.next()

    if cmdLongOption != optParser.kind:
      break

    case optParser.key:
      of "passphrase":
        passphrase = optParser.val

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

      of "autopassword":
        canUseAutoPassword = true          
        try:
          passwordLen = strutils.parseInt(optParser.val)
        except ValueError:
          stderr.writeln("Error: autopassword lenght value is invalid") 
          return
        except OverflowError:
          stderr.writeln("Error: autopassword lenght is too big") 
          return

      of "useuppercase":
        canUseUpperCase = true

      of "uselowercase":
        canUseLowerCase = true

      of "usesymbol":
        canUseSymbol = true

      of "usenumber":
        canUseNumber = true

      else: 
        stderr.writeln("Error: '" & optParser.key & "' is not a valid option")
        return

  if nil == passphrase:
    stderr.writeln("Error: a passphrase is needed in roder to get access to login records database") 
    return

  if nil == title:
    stderr.writeln("Error: you have to add a title for your password record using 'title'") 
    return

  if nil == username:
    stderr.writeln("Error: you have to add a username for your password record using 'username'") 
    return

  if false == canUseAutoPassword:
    if nil == password:
      stderr.write("Error: you have to add a password for your password record using 'password'") 
      stderr.writeln(" or use 'autopassword' to let the app generate a random password for you") 
      return
    if true == canUseUpperCase:
      stderr.writeln("Error: 'useuppercase' option can only be used if 'autopassword' is defined") 
      return
    if true == canUseLowerCase:
      stderr.writeln("Error: 'uselowercase' option can only be used if 'autopassword' is defined") 
      return
    if true == canUseSymbol:
      stderr.writeln("Error: 'usesymbol' option can only be used if 'autopassword' is defined") 
      return
    if true == canUseNumber:
      stderr.writeln("Error: 'usenumber' option can only be used if 'autopassword' is defined") 
      return

  if true == canUseAutoPassword:
    if nil != password:
      stderr.writeln("Error: you cannot use 'password' and 'autopassword' at the same time") 
      return
    password = autopassword.generate( passwordLen, 
                                      canUseUpperCase,
                                      canUseLowerCase,
                                      canUseSymbol,
                                      canUseNumber)
    if nil == password:
       stderr.writeln("Error: failed to generate a random password") 
       return

  
  var passphraseDigest = protection.createPassphraseDigest(passphrase)

  if false == logininfo.add(  app.getPassdbFolderPath(), 
                              app.getRecordsListFilePath(), 
                              passphraseDigest,
                              title, 
                              username, 
                              password, 
                              email, 
                              description, 
                              date):
    stderr.writeln("Error: failed to add item '" & title & "'")

## update an existing login record
## TODO: test, implement
proc performOptionUpdate() = 
  var passphrase: string = nil
  var title: string = nil
  var newtitle: string = nil
  var username: string = nil
  var password: string = nil
  var email: string = "UNDEFINED"
  var description: string = "UNDEFINED"
  var date = times.getDateStr()
  var canUseAutoPassword: bool = false
  var passwordLen: int = 0
  var canUseUpperCase: bool = false
  var canUseLowerCase: bool = false
  var canUseSymbol: bool = false
  var canUseNumber: bool = false

  while true:
    optParser.next()

    if cmdLongOption != optParser.kind:
      break

    case optParser.key:
      of "passphrase":
        passphrase = optParser.val

      of "title":
        title = optParser.val

      of "newtitle":
        newtitle = optParser.val

      of "username":
        username = optParser.val

      of "password":
        password = optParser.val

      of "email":
        email = optParser.val

      of "description":
        description = optParser.val

      of "autopassword":
        canUseAutoPassword = true          
        try:
          passwordLen = strutils.parseInt(optParser.val)
        except ValueError:
          stderr.writeln("Error: autopassword lenght value is invalid") 
          return
        except OverflowError:
          stderr.writeln("Error: autopassword lenght is too big") 
          return

      of "useuppercase":
        canUseUpperCase = true

      of "uselowercase":
        canUseLowerCase = true

      of "usesymbol":
        canUseSymbol = true

      of "usenumber":
        canUseNumber = true

      else: 
        stderr.writeln("Error: '" & optParser.key & "' is not a valid option")
        return
  
  if nil == passphrase:
    stderr.writeln("Error: a passphrase is needed in roder to get access to login records database") 
    return
  
  if nil == title:
    stderr.writeln("Error: you have to add a title for your password record using '--title'") 
    return

  if false == canUseAutoPassword:
    if nil == password:
      stderr.write("Error: you have to add a password for your password record using 'password'") 
      stderr.writeln(" or use 'autopassword' to let the app generate a random password for you") 
      return
    if true == canUseUpperCase:
      stderr.writeln("Error: 'useuppercase' option can only be used if 'autopassword' is defined") 
      return
    if true == canUseLowerCase:
      stderr.writeln("Error: 'uselowercase' option can only be used if 'autopassword' is defined") 
      return
    if true == canUseSymbol:
      stderr.writeln("Error: 'usesymbol' option can only be used if 'autopassword' is defined") 
      return
    if true == canUseNumber:
      stderr.writeln("Error: 'usenumber' option can only be used if 'autopassword' is defined") 
      return

  if true == canUseAutoPassword:
    if nil != password:
      stderr.writeln("Error: you cannot use 'password' and 'autopassword' at the same time") 
      return
    password = autopassword.generate( passwordLen, 
                                      canUseUpperCase,
                                      canUseLowerCase,
                                      canUseSymbol,
                                      canUseNumber)
    if nil == password:
       stderr.writeln("Error: failed to generate a random password") 
       return

  var passphraseDigest = protection.createPassphraseDigest(passphrase)

  if false == logininfo.update( app.getPassdbFolderPath(), 
                                app.getRecordsListFilePath(), 
                                passphraseDigest,
                                title, 
                                newtitle,
                                username, 
                                password, 
                                email, 
                                description, 
                                date):
    stderr.writeln("Error: failed to update item '" & title & "'")

## shows the login info asked by user
## TODO: test
proc performOptionShow() = 
  var passphrase: string = nil
  var title: string = nil

  while true:
    optParser.next()

    if cmdLongOption != optParser.kind:
      break

    case optParser.key:
      of "passphrase":
        passphrase = optParser.val

      of "title":
        title = optParser.val

      else: 
        stderr.writeln("Error: '" & optParser.key & "' is not a valid option")
        return
  
  if nil == passphrase:
    stderr.writeln("Error: a passphrase is needed in roder to get access to login records database") 
    return
  
  if nil == title:
    stderr.writeln("Error: you have define what loging you want to be shown using '--title' option") 
    return

  var passphraseDigest = protection.createPassphraseDigest(passphrase)

  var loginInfo = logininfo.show( app.getPassdbFolderPath(), 
                                  app.getRecordsListFilePath(), 
                                  passphraseDigest,
                                  title)
  if nil == loginInfo:
    stderr.writeln("Error: failed to show login information for '" & title & "'")
    return

  echo("=======" & loginInfo.title & "=======")
  echo("username: " & loginInfo.username)
  echo("password: " & loginInfo.password)
  echo("email: " & loginInfo.email)
  echo("date: " & loginInfo.date)
  echo("description: " & loginInfo.description)

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

    of "show":
      performOptionShow()

    of "list":
      performOptionList()

    of "del":
      performOptionDel(optParser.val)

    of "add":
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
