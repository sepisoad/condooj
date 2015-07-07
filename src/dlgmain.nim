import iup
import dlgrecord
import application

var dlgResult: bool = true
var lPassPhrase = ""

proc onButtonAdd(handle: PIhandle) :cint {.cdecl.} =
  var listRecords = getHandle("listRecords") 
  var lr = runRecordDialog(nil)
  if nil == lr:
    return IUP_DEFAULT
  var res = dbAdd(lr)
  if not res.isOk:
    message("error", res.msg)  
    return IUP_DEFAULT
  setAttribute(listRecords, "APPENDITEM", lr.title)
  return IUP_DEFAULT

proc onButtonRemove(handle: PIhandle) :cint {.cdecl.} =
  var listRecords = getHandle("listRecords") 
  var btn = button("ooo", "sdfsdf")
  setAttribute(listRecords, "APPENDITEM", btn)
  return IUP_DEFAULT

proc onButtonEdit(handle: PIhandle) :cint {.cdecl.} =
  return IUP_DEFAULT

proc onButtonExport(handle: PIhandle) :cint {.cdecl.} =
  return IUP_DEFAULT

proc onButtonImport(handle: PIhandle) :cint {.cdecl.} =
  return IUP_DEFAULT

proc onButtonSetting(handle: PIhandle) :cint {.cdecl.} =
  return IUP_DEFAULT

proc onButtonAbout(handle: PIhandle) :cint {.cdecl.} =
  return IUP_DEFAULT

proc addLoginRecordsToList(lt: LoginTable): bool = 
  var listRecords = getHandle("listRecords") 
  for record in items(lt):
    setAttribute(listRecords, "APPENDITEM", record.title)
  return true

proc runMainDialog*(passPhrase: string): bool =
  # todo: get rid of global lPassPhrase variable
  lPassPhrase = passPhrase

  var buttonAdd = button("+", "onButtonAdd")
  discard setCallback(buttonAdd, "ACTION", onButtonAdd)
  discard setHandle("buttonAdd", buttonAdd)
  setAttribute(buttonAdd, "SIZE", "20x10")

  var buttonRemove = button("-", "onButtonRemove")
  discard setCallback(buttonRemove, "ACTION", onButtonRemove)
  discard setHandle("buttonRemove", buttonRemove)
  setAttribute(buttonRemove, "SIZE", "20x10")

  var buttonEdit = button("*", "onButtonEdit")
  discard setCallback(buttonEdit, "ACTION", onButtonEdit)
  discard setHandle("buttonEdit", buttonEdit)
  setAttribute(buttonEdit, "SIZE", "20x10")

  var buttonExport = button(">", "onButtonExport")
  discard setCallback(buttonExport, "ACTION", onButtonExport)
  discard setHandle("buttonExport", buttonExport)
  setAttribute(buttonExport, "SIZE", "20x10")

  var buttonImport = button("<", "onButtonImport")
  discard setCallback(buttonImport, "ACTION", onButtonImport)
  discard setHandle("buttonImport", buttonImport)
  setAttribute(buttonImport, "SIZE", "20x10")

  var buttonSetting = button("#", "onButtonSetting")
  discard setCallback(buttonSetting, "ACTION", onButtonSetting)
  discard setHandle("buttonSetting", buttonSetting)
  setAttribute(buttonSetting, "SIZE", "20x10")

  var buttonAbout = button("@", "onButtonAbout")
  discard setCallback(buttonAbout, "ACTION", onButtonAbout)
  discard setHandle("buttonAbout", buttonAbout)
  setAttribute(buttonAbout, "SIZE", "20x10")

  var fillToolbar = fill()

  var hboxToolbar = hbox(nil)
  setAttribute(hboxToolbar, "ALIGNMENT", "ALEFT") 
  setAttribute(hboxToolbar, "EXPAND", "HORIZONTAL") 
  setAttribute(hboxToolbar, "EXPANDCHILDREN", "YES") 
  setAttribute(hboxToolbar, "MARGIN", "5x5")
  setAttribute(hboxToolbar, "GAP", "5")
  discard insert(hboxToolbar, nil, buttonAbout)
  discard insert(hboxToolbar, nil, buttonSetting)
  discard insert(hboxToolbar, nil, fillToolbar)
  discard insert(hboxToolbar, nil, buttonImport)
  discard insert(hboxToolbar, nil, buttonExport)
  discard insert(hboxToolbar, nil, buttonEdit)
  discard insert(hboxToolbar, nil, buttonRemove)
  discard insert(hboxToolbar, nil, buttonAdd)

  var listRecords = list("onListRecords")
  setAttribute(listRecords, "ALIGNMENT", "ALEFT") 
  setAttribute(listRecords, "EXPAND", "VERTICAL") 
  setAttribute(listRecords, "AUTOHIDE", "YES") 
  setAttribute(listRecords, "SHOWIMAGE", "YES") 
  setAttribute(listRecords, "SPACING", "3") 
  # setAttribute(listRecords, "SIZE", "50")  
  setAttribute(listRecords, "VISIBLELINES", "10")  
  discard setHandle("listRecords", listRecords)

  # var matrixRecors = matrix("onMatrixRecords")
  # setAttribute(matrixRecors, "NUMCOL", "3")
  # setAttribute(matrixRecors, "NUMCOL_VISIBLE", "3")
  # setAttribute(matrixRecors, "0:1", "title")
  # setAttribute(matrixRecors, "0:2", "username")
  # setAttribute(matrixRecors, "0:2", "email")

  var fillMain = fill()

  var textQuickSearch = text("onTextQuickSearch")
  setAttribute(textQuickSearch, "ALIGNMENT", "ALEFT") 
  setAttribute(textQuickSearch, "EXPAND", "YES") 
  discard setHandle("textQuickSearch", textQuickSearch)

  var vboxMain = vbox(nil)
  setAttribute(vboxMain, "ALIGNMENT", "ALEFT") 
  setAttribute(vboxMain, "EXPAND", "YES") 
  setAttribute(vboxMain, "EXPANDCHILDREN", "YES") 
  setAttribute(vboxMain, "MARGIN", "5x5")
  setAttribute(vboxMain, "GAP", "5")
  discard insert(vboxMain, nil, textQuickSearch)
  discard insert(vboxMain, nil, fillMain)
  # discard insert(vboxMain, nil, matrixRecors)
  discard insert(vboxMain, nil, listRecords)
  discard insert(vboxMain, nil, hboxToolbar)

  var dialogMain = dialog(vboxMain)
  setAttribute(dialogMain, "TITLE", "condooj")
  setAttribute(dialogMain, "EXPAND", "YES")
  setAttribute(dialogMain, "BORDER", "YES")
  setAttribute(dialogMain, "RESIZE", "NO")
  setAttribute(dialogMain, "SIZE", "QUARTER")
  discard setHandle("dialogMain", dialogMain)

  discard showXY(dialogMain, IUP_CENTER, IUP_CENTER)
  
  #################################
  # loading login records from db #
  #################################
  var db = loadDB()
  if nil != db:
    discard addLoginRecordsToList(db)

  discard mainLoop()
  destroy(dialogMain)
  return dlgResult
