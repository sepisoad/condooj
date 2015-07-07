import iup
import logging
import application
import dlgpassphrase
import dlgauthorize
import dlgmain

proc firstTimeRunFlow(): bool =
  debug("firstTimeRunFlow() called")
  var passPhrase = runPassphraseDialog(isFirstTime = true)
  if "" == passPhrase:
    return false
  var dlgResult = runAuthorizationDialog(passPhrase)
  if false == dlgResult:
    return false
  dlgResult = runMainDialog(passPhrase)
  if false == dlgResult:
    return false
  return true

proc normalRunFlow(): bool =
  debug("normalRunFlow() called")
  var passPhrase = runPassphraseDialog(isFirstTime = false)
  if "" == passPhrase:
    return false
  var dlgResult = runMainDialog(passPhrase)
  if false == dlgResult:
    return false
  return true

proc main() = 
  discard iup.open(nil, nil)
  defer: iup.close()

  case initApp()
  of airFailed:
    info("app is shutting down due to an error")
    return 
  of airNoProfile:
    if not firstTimeRunFlow():
      return
  of airSuccessful:
    if not normalRunFlow():
      return

main()