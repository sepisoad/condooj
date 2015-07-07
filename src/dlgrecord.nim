import iup
import times
import application
import dlggenpassword

var dlgRecordResult: LoginRecord = nil

proc collectDataFromDialog(): LoginRecord = 
  var textTitle = getHandle("textTitle") 
  var textUsername = getHandle("textUsername")
  var textPasswordX = getHandle("textPasswordX")
  var textEmail = getHandle("textEmail")
  var textDate = getHandle("textDate")
  var textDescription = getHandle("textDescription")
  var title = $getAttribute(textTitle, "VALUE")
  var username = $getAttribute(textUsername, "VALUE")  
  var password = $getAttribute(textPasswordX, "VALUE")
  var email = $getAttribute(textEmail, "VALUE")
  var date = $getAttribute(textDate, "VALUE")
  var description = $getAttribute(textDescription, "VALUE")
  result = newLoginRecord(title, 
                          username,
                          password,
                          email,
                          date,
                          description,
                          @[])

proc areFieldsCorrectlyFilled(lr: LoginRecord): tuple[isOk: bool, msg: string] =
  if "" == lr.title:
    result.isOk = false
    result.msg = "please fill in the title field"
    return
  if "" == lr.username:
    result.isOk = false
    result.msg = "please fill in the username field"
    return
  if "" == lr.password:
    result.isOk = false
    result.msg = "please fill in the password field"
    return
  if "" == lr.email:
    result.isOk = false
    result.msg = "please fill in the email field"
    return
  if "" == lr.date:
    result.isOk = false
    result.msg = "please fill in the title field"
    return
  if not isDateStringCorrect(lr.date):
    result.isOk = false
    result.msg = "the date string is not valid, please follow `YYYY-MM-DD` formating"
    return
  if "" == lr.description:
    result.isOk = false
    result.msg = "please fill in the description field"
    return
  result.isOk = true
  result.msg = "ok"

proc onDlgClose(handle: PIhandle) :cint {.cdecl.} =
  exitLoop()
  return IUP_DEFAULT

proc onButtonCancel(handle: PIhandle) :cint {.cdecl.} =
  var dialogRecord = getHandle("dialogRecord")
  destroy(dialogRecord)
  dlgRecordResult = nil
  exitLoop()
  return IUP_DEFAULT

proc onButtonAccept(handle: PIhandle) :cint {.cdecl.} =
  var lr = collectDataFromDialog()
  var res = areFieldsCorrectlyFilled(lr)
  if not res.isOk:
    message("error", res.msg)
    return IUP_DEFAULT
  else:
    dlgRecordResult = lr
    var dialogRecord = getHandle("dialogRecord")
    destroy(dialogRecord)
    exitLoop()
    return IUP_DEFAULT

proc onButtonGenPassword(handle: PIhandle): cint {.cdecl.} = 
  var textPasswordX = getHandle("textPasswordX")
  var randomPassword = runGenPasswordDialog()
  setAttribute(textPasswordX, "VALUE", randomPassword)
  return IUP_DEFAULT

proc onButtonGetToday(handle: PIhandle): cint {.cdecl.} = 
  var textDate = getHandle("textDate")
  setAttribute(textDate, "VALUE", getDateStr())

proc runRecordDialog*(lr: LoginRecord): LoginRecord =
  #############################
  # title part                #
  #############################
  var labelTitle = label("title:")
  var textTitle = text("")
  var hboxTitle = hbox(nil)
  discard setHandle("textTitle", textTitle)
  setAttribute(labelTitle, "SIZE", "45x10")
  setAttribute(textTitle, "EXPAND", "YES")
  if nil != lr:
    setAttribute(textTitle, "VALUE", lr.title)
  discard insert(hboxTitle, nil,  textTitle)
  discard insert(hboxTitle, nil, labelTitle)
  setAttribute(hboxTitle, "ALIGNMENT", "ACENTER") 
  setAttribute(hboxTitle, "EXPAND", "HORIZONTAL") 
  #############################
  # username part             #
  #############################
  var labelUsername = label("username:")
  var textUsername = text("")
  var hboxUsername = hbox(nil)
  discard setHandle("textUsername", textUsername)
  setAttribute(labelUsername, "SIZE", "45x10")
  setAttribute(textUsername, "EXPAND", "YES")
  if nil != lr:
    setAttribute(textUsername, "VALUE", lr.username)
  discard insert(hboxUsername, nil,  textUsername)
  discard insert(hboxUsername, nil, labelUsername)
  setAttribute(hboxUsername, "ALIGNMENT", "ACENTER") 
  setAttribute(hboxUsername, "EXPAND", "HORIZONTAL") 
  #############################
  # password part             #
  #############################
  var labelPassword = label("password:")
  var textPasswordX = text("")
  var buttonGenPassword = button("gen password", "onButtonGenPassword")
  var hboxPassword = hbox(nil)
  discard setHandle("textPasswordX", textPasswordX)
  discard setCallback(buttonGenPassword, "ACTION", onButtonGenPassword)
  setAttribute(labelPassword, "SIZE", "45x10")
  setAttribute(textPasswordX, "EXPAND", "YES")
  # setAttribute(textPasswordX, "PASSWORD", "YES")
  if nil != lr:
    setAttribute(textPasswordX, "VALUE", lr.password)
  discard insert(hboxPassword, nil, buttonGenPassword)
  discard insert(hboxPassword, nil, textPasswordX)
  discard insert(hboxPassword, nil, labelPassword)
  setAttribute(hboxPassword, "ALIGNMENT", "ACENTER") 
  setAttribute(hboxPassword, "EXPAND", "HORIZONTAL") 
  #############################
  # email part                #
  #############################
  var labelEmail = label("email:")
  var textEmail = text("")
  var hboxEmail = hbox(nil)
  discard setHandle("textEmail", textEmail)
  setAttribute(labelEmail, "SIZE", "45x10")
  setAttribute(textEmail, "EXPAND", "YES")
  if nil != lr:
    setAttribute(textEmail, "VALUE", lr.email)
  discard insert(hboxEmail, nil,  textEmail)
  discard insert(hboxEmail, nil, labelEmail)
  setAttribute(hboxEmail, "ALIGNMENT", "ACENTER") 
  setAttribute(hboxEmail, "EXPAND", "HORIZONTAL") 
  #############################
  # date part                 #
  #############################
  var labelDate = label("date:")
  var textDate = text("")
  var buttonGetToday = button("today", "onButtonGetToday")
  var hboxDate = hbox(nil)
  discard setHandle("textDate", textDate)
  discard setCallback(buttonGetToday, "ACTION", onButtonGetToday)
  setAttribute(labelDate, "SIZE", "45x10")
  setAttribute(textDate, "EXPAND", "YES")
  if nil != lr:
    setAttribute(textDate, "VALUE", lr.date)
  setAttribute(textDate, "VALUE", getDateStr())
  discard insert(hboxDate, nil,  buttonGetToday)
  discard insert(hboxDate, nil,  textDate)
  discard insert(hboxDate, nil, labelDate)
  setAttribute(hboxDate, "ALIGNMENT", "ACENTER") 
  setAttribute(hboxDate, "EXPAND", "HORIZONTAL") 
  #############################
  # description part          #
  #############################
  var labelDescription = label("description:")
  var textDescription = text("")
  var hboxDescription = hbox(nil)
  discard setHandle("textDescription", textDescription)
  setAttribute(labelDescription, "SIZE", "45x10")
  setAttribute(textDescription, "MULTILINE", "YES")
  setAttribute(textDescription, "VISIBLELINES", "5")
  setAttribute(textDescription, "EXPAND", "YES")
  if nil != lr:
    setAttribute(textDescription, "VALUE", lr.description)
  discard insert(hboxDescription, nil,  textDescription)
  discard insert(hboxDescription, nil, labelDescription)
  setAttribute(hboxDescription, "ALIGNMENT", "ACENTER") 
  setAttribute(hboxDescription, "EXPAND", "HORIZONTAL") 
  ##############################
  # accept/cancel buttons area #
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
  discard insert(vboxMain, nil, hboxDescription)
  discard insert(vboxMain, nil, hboxDate)
  discard insert(vboxMain, nil, hboxEmail)
  discard insert(vboxMain, nil, hboxPassword)
  discard insert(vboxMain, nil, hboxUsername)
  discard insert(vboxMain, nil, hboxTitle)
  ##############################
  # record dialog              #
  ##############################
  var dialogRecord = dialog(vboxMain)
  setAttribute(dialogRecord, "TITLE", "condooj")
  setAttribute(dialogRecord, "EXPAND", "YES")
  setAttribute(dialogRecord, "BORDER", "YES")
  setAttribute(dialogRecord, "RESIZE", "NO")
  # setAttribute(dialogRecord, "SIZE", "QUARTERxQUARTER")
  setAttribute(dialogRecord, "SIZE", "300x200")
  setCallback(dialogRecord, "CLOSE_CB", onDlgClose)
  discard setHandle("dialogRecord", dialogRecord)
  discard showXY(dialogRecord, IUP_CENTER, IUP_CENTER)

  discard mainLoop()
  destroy(dialogRecord)
  return dlgRecordResult