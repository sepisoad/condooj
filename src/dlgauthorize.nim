import os
import iup
import httpclient
import strutils
import browsers
import logging
import application

const APP_KEY = "hkcnl3viglfuf5k"
const APP_SEC = "q7mkice2q1t22xz"
const HELP_MSG = """
condooj uses dropbox as an online backup storage so that in cases when
you mess up with your credentials condooj will be able to restore everything.
but first you need to have a dropbox account, if you don't just go create one,
it's free. then you have to authorize condooj to access your dropbox account.
don't worry, condooj just has access to its own folder on your dropbox storage.
you also don't have to type in your username and password here, instead by 
clicking on 'getCode' button you will be directed to dropbox authotization page,
after authorizing condooj, dropbox will throw you a long string, condooj
relies on this string to handle its online backup routines. copy the text and 
paste it in the textbox above and click on 'accept' button. this is a one-time
process, next time you will not see this window!
"""

var dlgResult: bool = true
var lPassPhrase = ""

proc getAuthorizationCode() = 
  var apiAuthorizeUrl = format("https://www.dropbox.com/1/oauth2/authorize?response_type=code&client_id=$1&", APP_KEY)
  openDefaultBrowser(apiAuthorizeUrl)

proc authorizeApp(authorizationCode: string): bool = 
  var apiTokenUrl = format("https://api.dropbox.com/1/oauth2/token?code=$1&grant_type=authorization_code&client_id=$2&client_secret=$3", authorizationCode, APP_KEY, APP_SEC)
  var response = request(apiTokenUrl, httpPost)
  if "200 OK" != response.status:
    error("failed to authorize the app")
    message("error", "failed to authorize the app")
    return false

  var profile = newProfile(lPassPhrase, authorizationCode, response.body)
  if not createProfile(profile):
    return false
  return true

proc onButtonGetCode(handle: PIhandle) :cint {.cdecl.} =
  getAuthorizationCode()
  return IUP_DEFAULT

proc onButtonAccept(handle: PIhandle) :cint {.cdecl.} =
  var dialogAuthorization = getHandle("dialogAuthorization")
  var textInputBox = getHandle("textInputBox") 
  var authorizationCode = getAttribute(textInputBox, "VALUE")
  if not authorizeApp($authorizationCode):
    dlgResult = false
  else:
    dlgResult = true
    destroy(dialogAuthorization)
    return IUP_DEFAULT

proc runAuthorizationDialog*(passPhrase: string): bool = 
  # todo: get rid of global lPassPhrase variable
  lPassPhrase = passPhrase

  var buttonGetCode = button("authenticate", "onButtonGetCode")
  discard setCallback(buttonGetCode, "ACTION", onButtonGetCode)
  discard setHandle("buttonGetCode", buttonGetCode)

  var buttonAccept = button("accept", "onButtonAccept")
  discard setCallback(buttonAccept, "ACTION", onButtonAccept)
  discard setHandle("buttonAccept", buttonAccept)

  var textInputBox = text("") 
  setAttribute(textInputBox, "APPENDNEWLINE", "YES")
  setAttribute(textInputBox, "AUTOHIDE", "YES")
  discard setHandle("textInputBox", textInputBox)

  var labelInfo = label(HELP_MSG)
  discard setHandle("labelInfo", labelInfo)
 
  var vboxMainView = vbox(nil)
  setAttribute(vboxMainView, "ALIGNMENT", "ACENTER") 
  setAttribute(vboxMainView, "EXPAND", "YES") 
  setAttribute(vboxMainView, "EXPANDCHILDREN", "YES") 
  setAttribute(vboxMainView, "MARGIN", "5x5")
  setAttribute(vboxMainView, "GAP", "5")
  discard insert(vboxMainView, nil, buttonAccept)
  discard insert(vboxMainView, nil, labelInfo)
  discard insert(vboxMainView, nil, textInputBox)
  discard insert(vboxMainView, nil, buttonGetCode)
  
 
  var dialogAuthorization = dialog(vboxMainView)
  setAttribute(dialogAuthorization, "TITLE", "condooj")
  setAttribute(dialogAuthorization, "EXPAND", "YES")
  setAttribute(dialogAuthorization, "BORDER", "YES")
  setAttribute(dialogAuthorization, "RESIZE", "NO")
  discard setHandle("dialogAuthorization", dialogAuthorization)
 
  discard showXY(dialogAuthorization, IUP_CENTER, IUP_CENTER)
  discard mainLoop()

  destroy(dialogAuthorization)
  return dlgResult

