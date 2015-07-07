import iup
import strutils
import genpassword

type 
  RandomPasswordInfo = ref object
    hasUppercase*: bool
    hasLowercase*: bool
    hasNumbers*: bool
    hasSymbols*: bool
    length*: string

var dlgGenPasswordResult: string  = ""

proc onDlgClose(handle: PIhandle) :cint {.cdecl.} =
  dlgGenPasswordResult = ""
  exitLoop()
  return IUP_DEFAULT

proc onButtonCancel(handle: PIhandle) :cint {.cdecl.} =
  dlgGenPasswordResult = ""
  exitLoop()
  return IUP_DEFAULT

proc onButtonAccept(handle: PIhandle) :cint {.cdecl.} =
  var textPassword = getHandle("textPassword")
  dlgGenPasswordResult = $getAttribute(textPassword, "VALUE")
  exitLoop()
  return IUP_DEFAULT    

proc collectDataFromDialog(): RandomPasswordInfo = 
  var toggleUppercase = getHandle("toggleUppercase") 
  var toggleLowercase = getHandle("toggleLowercase")
  var toggleNumbers = getHandle("toggleNumbers")
  var toggleSymbols = getHandle("toggleSymbols")
  var textPasswordLen = getHandle("textPasswordLen")

  var uppercase = ("ON" == $getAttribute(toggleUppercase, "VALUE"))
  var lowercase = ("ON" == $getAttribute(toggleLowercase, "VALUE"))
  var numbers = ("ON" == $getAttribute(toggleNumbers, "VALUE"))
  var symbols = ("ON" == $getAttribute(toggleSymbols, "VALUE"))
  var length = $getAttribute(textPasswordLen, "VALUE")

  new(result)
  result.hasUppercase = uppercase
  result.hasLowercase = lowercase
  result.hasNumbers = numbers
  result.hasSymbols = symbols
  result.length = length

proc areFieldsCorrectlyFilled(rpi: RandomPasswordInfo): tuple[isOk: bool, msg: string] =
  var num: int = 0
  try:
    num = parseInt(rpi.length)
  except OverflowError:
    result.isOk = false
    result.msg = "the length field contains invalid value"
  except ValueError:
    result.isOk = false
    result.msg = "the length field contains invalid value"
  if num <= 5:
    result.isOk = false
    result.msg = "password length must be bigger than 5"
  elif num > MAX_PASSWORD_LEN:
    result.isOk = false
    result.msg = "password length must not be bigger than " & $MAX_PASSWORD_LEN
  else:
    result.isOk = true
    result.msg = "ok"

proc onButtonGenPassword(handle: PIhandle): cint {.cdecl.} = 
  var rpi = collectDataFromDialog()
  var res = areFieldsCorrectlyFilled(rpi)
  if not res.isOk:
    message("error", res.msg)
    return IUP_DEFAULT

  dlgGenPasswordResult = generate(parseInt(rpi.length),
                                  rpi.hasUppercase,
                                  rpi.hasLowercase,
                                  rpi.hasSymbols,
                                  rpi.hasNumbers)
  # echo(dlgGenPasswordResult)
  if nil != dlgGenPasswordResult or "" != dlgGenPasswordResult:
    var textPassword = getHandle("textPassword")
    setAttribute(textPassword, "VALUE", dlgGenPasswordResult)
  return IUP_DEFAULT

proc runGenPasswordDialog*(): string = 
  #############################
  # password part             #
  #############################
  var textPassword = text("")
  var buttonGenPassword = button("gen password", "onButtonGenPassword")
  var hboxPassword = hbox(nil)
  discard setHandle("textPassword", textPassword)
  discard setCallback(buttonGenPassword, "ACTION", onButtonGenPassword)
  setAttribute(textPassword, "EXPAND", "YES")
  discard insert(hboxPassword, nil, buttonGenPassword)
  discard insert(hboxPassword, nil,  textPassword)
  setAttribute(hboxPassword, "ALIGNMENT", "ACENTER") 
  setAttribute(hboxPassword, "EXPAND", "HORIZONTAL") 
  #############################
  # uppercase part            #
  #############################
  var toggleUppercase = toggle("uppercase", "onToggleUppercase")
  discard setHandle("toggleUppercase", toggleUppercase)
  setAttribute(toggleUppercase, "ALIGNMENT", "ACENTER") 
  setAttribute(toggleUppercase, "EXPAND", "HORIZONTAL") 
  #############################
  # lowercase part            #
  #############################
  var toggleLowercase = toggle("lowercase", "onToggleLowercase")
  discard setHandle("toggleLowercase", toggleLowercase)
  setAttribute(toggleLowercase, "ALIGNMENT", "ACENTER") 
  setAttribute(toggleLowercase, "EXPAND", "HORIZONTAL") 
  #############################
  # number part               #
  #############################
  var toggleNumbers = toggle("numbers", "onToggleNumbers")
  discard setHandle("toggleNumbers", toggleNumbers)
  setAttribute(toggleNumbers, "ALIGNMENT", "ACENTER") 
  setAttribute(toggleNumbers, "EXPAND", "HORIZONTAL") 
  #############################
  # symbols part              #
  #############################
  var toggleSymbols = toggle("symbols", "onToggleSymbols")
  discard setHandle("toggleSymbols", toggleSymbols)
  setAttribute(toggleSymbols, "ALIGNMENT", "ACENTER") 
  setAttribute(toggleSymbols, "EXPAND", "HORIZONTAL") 
  #############################
  # toggles area              #
  #############################
  var vboxToggles = vbox(nil)
  setAttribute(vboxToggles, "ALIGNMENT", "ACENTER") 
  setAttribute(vboxToggles, "EXPAND", "HORIZONTAL") 
  setAttribute(vboxToggles, "EXPANDCHILDREN", "YES") 
  setAttribute(vboxToggles, "MARGIN", "5x5")
  discard insert(vboxToggles, nil, toggleSymbols)
  discard insert(vboxToggles, nil, toggleNumbers)
  discard insert(vboxToggles, nil, toggleLowercase)
  discard insert(vboxToggles, nil, toggleUppercase)
  #############################
  # password len part         #
  #############################
  var textPasswordLen = text("")
  var labelPasswordLen = label("password len")
  var hboxPasswordLen = hbox(nil)
  discard setHandle("textPasswordLen", textPasswordLen)
  setAttribute(textPasswordLen, "VALUE", "16")
  discard insert(hboxPasswordLen, nil, labelPasswordLen)
  discard insert(hboxPasswordLen, nil,  textPasswordLen) 
  setAttribute(hboxPasswordLen, "ALIGNMENT", "ALEFT") 
  ##############################
  # buttons area               #
  ##############################
  var buttonCancel = button("cancel", "onButtonCancel")
  discard setCallback(buttonCancel, "ACTION", onButtonCancel)
  discard setHandle("buttonCancel", buttonCancel)
  setAttribute(buttonCancel, "SIZE", "50x10")
  var buttonAccept = button("accept", "onButtonAccept")
  discard setCallback(buttonAccept, "ACTION", onButtonAccept)
  discard setHandle("buttonAccept", buttonAccept)
  setAttribute(buttonAccept, "SIZE", "50x10")
  var fillButtonArea = fill()
  var hboxButtonArea = hbox(nil)
  setAttribute(hboxButtonArea, "ALIGNMENT", "ACENTER") 
  setAttribute(hboxButtonArea, "EXPAND", "HORIZONTAL") 
  setAttribute(hboxButtonArea, "EXPANDCHILDREN", "YES") 
  discard insert(hboxButtonArea, nil, buttonAccept)
  discard insert(hboxButtonArea, nil, fillButtonArea)
  discard insert(hboxButtonArea, nil, buttonCancel)
  ##############################
  # main area                  #
  ##############################
  var fillMain = fill()
  var vboxMain = vbox(nil)
  setAttribute(vboxMain, "ALIGNMENT", "ALEFT") 
  setAttribute(vboxMain, "EXPAND", "YES") 
  setAttribute(vboxMain, "MARGIN", "5x5")
  setAttribute(vboxMain, "GAP", "5")
  discard insert(vboxMain, nil, hboxButtonArea)
  discard insert(vboxMain, nil, fillMain)
  discard insert(vboxMain, nil, hboxPasswordLen)
  discard insert(vboxMain, nil, vboxToggles)
  discard insert(vboxMain, nil, hboxPassword)
  ##############################
  # gen password dialog        #
  ##############################
  var dialogGenPassword = dialog(vboxMain)
  setAttribute(dialogGenPassword, "TITLE", "generate password")
  setAttribute(dialogGenPassword, "EXPAND", "YES")
  setAttribute(dialogGenPassword, "BORDER", "YES")
  setAttribute(dialogGenPassword, "RESIZE", "NO")
  # setAttribute(dialogGenPassword, "SIZE", "QUARTERxQUARTER")
  setAttribute(dialogGenPassword, "SIZE", "300x150")
  setCallback(dialogGenPassword, "CLOSE_CB", onDlgClose)
  discard setHandle("dialogGenPassword", dialogGenPassword)
  discard showXY(dialogGenPassword, IUP_CENTER, IUP_CENTER)
  
  discard mainLoop()
  #todo: maybe i need to call destroy
  destroy(dialogGenPassword)
  # echo(dlgGenPasswordResult)
  return dlgGenPasswordResult