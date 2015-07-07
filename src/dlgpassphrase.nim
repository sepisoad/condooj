#todo: cover logging message

import iup
import logging

# const HELP = """
# a passphrase is a sequence of words or other 
# text used to control access to a computer system, 
# program or data. a passphrase is similar to a 
# password in usage, but is generally longer for 
# added security.
# """
const LBL_MSG_1 = "enter your passphrase here:"
const LBL_MSG_2 = "repeat your passphrase here:"
const ERR_TITLE = "error"
const ERR_MSG_1 = "please fill in text boxes"
const ERR_MSG_2 = "the two passphrases are not equal"
const ERR_MSG_3 = "please enter your passphrase"
# const INF_TITLE = "info"
# const INF_MSG1 = "you can go to the next level"
const BTN_SIGNIN_CAP = "sign in"
const BTN_LOGIN_CAP = "log in"

var passPhrase: string = ""

proc onButtonSignin(handle: PIhandle) :cint {.cdecl.} =
  var dialogPassPhrase = getHandle("dialogPassPhrase")
  var textInputBox1 = getHandle("textInputBox1") 
  var textInputBox2 = getHandle("textInputBox2")
  var textInputBox1Value = $(getAttribute(textInputBox1, "VALUE"))
  var textInputBox2Value = $(getAttribute(textInputBox2, "VALUE"))
  
  if  "" == textInputBox1Value or "" == textInputBox2Value:
    message(ERR_TITLE, ERR_MSG_1)
    passPhrase = ""
    return IUP_DEFAULT
  if  textInputBox1Value != textInputBox2Value:
    message(ERR_TITLE, ERR_MSG_2)
    passPhrase = ""
    return IUP_DEFAULT
  else:
    # message(INF_TITLE, INF_MSG1)
    passPhrase = $(textInputBox1Value)
    destroy(dialogPassPhrase)
    return IUP_DEFAULT

proc onButtonLogin(handle: PIhandle) :cint {.cdecl.} =
  var dialogPassPhrase = getHandle("dialogPassPhrase")
  var textInputBox = getHandle("textInputBox") 
  var textInputBoxValue = $(getAttribute(textInputBox, "VALUE"))
  
  if  "" == textInputBoxValue:
    message(ERR_TITLE, ERR_MSG_3)
    passPhrase = ""
    return IUP_DEFAULT
  else:
    #todo: check passphrase against profile to give login access
    # message(INF_TITLE, INF_MSG1)
    passPhrase = $(textInputBoxValue)
    destroy(dialogPassPhrase)
    return IUP_DEFAULT

proc runSigninPassphraseDialog() = 
  var labelMsg1 = label(LBL_MSG_1)
  var labelMsg2 = label(LBL_MSG_2)
  # var labelInfo = label(HELP)
  var textInputBox1 = text("")
  var textInputBox2 = text("")
  var buttonSignin = button(BTN_SIGNIN_CAP, "onButtonSignin")
  var fillArea = fill()

  setAttribute(textInputBox1, "EXPAND", "HORIZONTAL")
  setAttribute(textInputBox1, "APPENDNEWLINE", "YES")
  discard setHandle("textInputBox1", textInputBox1)

  setAttribute(textInputBox2, "EXPAND", "HORIZONTAL")
  setAttribute(textInputBox2, "APPENDNEWLINE", "YES")
  discard setHandle("textInputBox2", textInputBox2)

  discard setCallback(buttonSignin, "ACTION", onButtonSignin)
  discard setHandle("buttonSignin", buttonSignin)  

  var vboxMain = vbox(nil)
  setAttribute(vboxMain, "ALIGNMENT", "ALEFT") 
  setAttribute(vboxMain, "EXPAND", "YES") 
  setAttribute(vboxMain, "EXPANDCHILDREN", "YES") 
  setAttribute(vboxMain, "MARGIN", "5x5")
  setAttribute(vboxMain, "GAP", "5")
  discard insert(vboxMain, nil, buttonSignin)
  discard insert(vboxMain, nil, fillArea)
  # discard insert(vboxMain, nil, labelInfo)
  discard insert(vboxMain, nil, textInputBox2)
  discard insert(vboxMain, nil, labelMsg2)
  discard insert(vboxMain, nil, textInputBox1)
  discard insert(vboxMain, nil, labelMsg1)

  var dialogPassPhrase = dialog(vboxMain)
  setAttribute(dialogPassPhrase, "TITLE", "condooj - sign in")
  setAttribute(dialogPassPhrase, "BORDER", "YES")
  setAttribute(dialogPassPhrase, "RESIZE", "NO")
  discard setHandle("dialogPassPhrase", dialogPassPhrase)

  discard showXY(dialogPassPhrase, IUP_CENTER, IUP_CENTER)
  discard mainLoop()
  destroy(dialogPassPhrase)

proc runLoginPassphraseDialog() = 
  var labelMsg = label(LBL_MSG_1)
  var textInputBox = text("")
  var buttonLogin = button(BTN_LOGIN_CAP, "onButtonLogin")
  var fillArea = fill()

  setAttribute(textInputBox, "EXPAND", "HORIZONTAL")
  setAttribute(textInputBox, "APPENDNEWLINE", "YES")
  setAttribute(textInputBox, "PASSWORD", "YES")
  discard setHandle("textInputBox", textInputBox)

  discard setCallback(buttonLogin, "ACTION", onButtonLogin)
  discard setHandle("buttonLogin", buttonLogin)   

  var vboxMain = vbox(nil)
  setAttribute(vboxMain, "ALIGNMENT", "ALEFT") 
  setAttribute(vboxMain, "EXPAND", "YES") 
  setAttribute(vboxMain, "EXPANDCHILDREN", "YES") 
  setAttribute(vboxMain, "MARGIN", "5x5")
  setAttribute(vboxMain, "GAP", "5")
  discard insert(vboxMain, nil, buttonLogin)
  discard insert(vboxMain, nil, fillArea)
  discard insert(vboxMain, nil, textInputBox)
  discard insert(vboxMain, nil, labelMsg)

  var dialogPassPhrase = dialog(vboxMain)
  setAttribute(dialogPassPhrase, "TITLE", "condooj - login")
  setAttribute(dialogPassPhrase, "BORDER", "YES")
  setAttribute(dialogPassPhrase, "RESIZE", "NO")
  # setAttribute(dialogPassPhrase, "SIZE", "QUARTERxQUARTER")

  discard setHandle("dialogPassPhrase", dialogPassPhrase)
  discard showXY(dialogPassPhrase, IUP_CENTER, IUP_CENTER)
  discard mainLoop()
  destroy(dialogPassPhrase)

proc runPassphraseDialog*(isFirstTime: bool): string = 
  if isFirstTime:
    runSigninPassphraseDialog()
  else:
    runLoginPassphraseDialog()
  return passPhrase