import iup
import dlgrecord
import application

var dlgResult: bool = true
var lPassPhrase = ""

proc onButtonAdd(handle: PIhandle) :cint {.cdecl.} =
  var listRecordsTitle = getHandle("listRecordsTitle") 
  var listRecordsUids = getHandle("listRecordsUids") 
  var lr = runRecordDialog(nil)
  if nil == lr:
    return IUP_DEFAULT
  var res = dbAdd(lr)
  if not res.isOk:
    message("error", res.msg)  
    return IUP_DEFAULT
  setAttribute(listRecordsTitle, "APPENDITEM", lr.title)
  setAttribute(listRecordsUids, "APPENDITEM", lr.uid)
  return IUP_DEFAULT

proc onButtonRemove(handle: PIhandle) :cint {.cdecl.} =
  var listRecordsTitle = getHandle("listRecordsTitle") 
  var listRecordsUids = getHandle("listRecordsUids") 
  var uidItemIndex = $getAttribute(listRecordsUids, "VALUE")
  if "0" != uidItemIndex:
    var uidItemStr = $getAttribute(listRecordsUids, "VALUESTRING")
    var res = dbRemove(uidItemStr)
    if not res.isOk:
      message("error", res.msg)  
    else:
      setAttribute(listRecordsTitle, "REMOVEITEM", uidItemIndex)
      setAttribute(listRecordsUids, "REMOVEITEM", uidItemIndex)
  return IUP_DEFAULT

proc onButtonEdit(handle: PIhandle) :cint {.cdecl.} =
  var listRecordsTitle = getHandle("listRecordsTitle") 
  var listRecordsUids = getHandle("listRecordsUids") 
  var uidItemIndex = $getAttribute(listRecordsUids, "VALUE")
  if "0" != uidItemIndex:
    var uidItemStr = $getAttribute(listRecordsUids, "VALUESTRING")
    var queryFind = dbFindByUid(nil, uidItemStr)
    if queryFind.isOk:
      var lr = runRecordDialog(queryFind.record)
      if nil != lr:
        var queryRemove = dbRemove(uidItemStr)
        if queryRemove.isOk:
          var queryAdd = dbAdd(lr)
          if queryAdd.isOk:
            setAttribute(listRecordsTitle, "REMOVEITEM", uidItemIndex)
            setAttribute(listRecordsUids, "REMOVEITEM", uidItemIndex)
            setAttribute(listRecordsTitle, "APPENDITEM", lr.title)
            setAttribute(listRecordsUids, "APPENDITEM", lr.uid)
  return IUP_DEFAULT

proc onButtonExport(handle: PIhandle) :cint {.cdecl.} =
  return IUP_DEFAULT

proc onButtonImport(handle: PIhandle) :cint {.cdecl.} =
  return IUP_DEFAULT

proc onButtonSetting(handle: PIhandle) :cint {.cdecl.} =
  return IUP_DEFAULT

proc onButtonAbout(handle: PIhandle) :cint {.cdecl.} =
  return IUP_DEFAULT

proc onListRecordsTitle(handle: PIhandle) :cint {.cdecl.} =
  var listRecordsTitle = getHandle("listRecordsTitle") 
  var listRecordsUids = getHandle("listRecordsUids") 
  var titleItemIndex = getAttribute(listRecordsTitle, "VALUE")
  setAttribute(listRecordsUids, "VALUE", titleItemIndex)
  return IUP_DEFAULT

proc onListRecordsUids(handle: PIhandle) :cint {.cdecl.} =
  var listRecordsTitle = getHandle("listRecordsTitle") 
  var listRecordsUids = getHandle("listRecordsUids") 
  var uidItemIndex = getAttribute(listRecordsUids, "VALUE")
  setAttribute(listRecordsTitle, "VALUE", uidItemIndex)
  return IUP_DEFAULT

proc addLoginRecordsToList(lt: LoginTable): bool = 
  var listRecordsTitle = getHandle("listRecordsTitle") 
  var listRecordsUids = getHandle("listRecordsUids") 
  for record in items(lt):
    setAttribute(listRecordsTitle, "APPENDITEM", record.title)
    setAttribute(listRecordsUids, "APPENDITEM", record.uid)
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

  var listRecordsTitle = list("onListRecordsTitle")
  setAttribute(listRecordsTitle, "ALIGNMENT", "ALEFT") 
  setAttribute(listRecordsTitle, "EXPAND", "YES") 
  setAttribute(listRecordsTitle, "AUTOHIDE", "YES") 
  setAttribute(listRecordsTitle, "SHOWIMAGE", "YES") 
  setAttribute(listRecordsTitle, "SPACING", "3") 
  setAttribute(listRecordsTitle, "VISIBLELINES", "10")  
  setAttribute(listRecordsTitle, "SIZE", "NATURALSIZE") 
  discard setHandle("listRecordsTitle", listRecordsTitle)
  discard setCallback(listRecordsTitle, "ACTION", onListRecordsTitle)

  var listRecordsUids = list("onListRecordsUids")
  setAttribute(listRecordsUids, "ALIGNMENT", "ALEFT") 
  setAttribute(listRecordsUids, "EXPAND", "NO") 
  setAttribute(listRecordsUids, "AUTOHIDE", "YES") 
  setAttribute(listRecordsUids, "SHOWIMAGE", "YES") 
  setAttribute(listRecordsUids, "SPACING", "3") 
  setAttribute(listRecordsUids, "VISIBLELINES", "10")  
  setAttribute(listRecordsUids, "SIZE", "0") 
  setAttribute(listRecordsUids, "VISIBLE", "NO") 
  discard setHandle("listRecordsUids", listRecordsUids) 
  discard setCallback(listRecordsUids, "ACTION", onListRecordsUids)

  var hboxListRecords = hbox(nil)
  setAttribute(hboxListRecords, "ALIGNMENT", "ALEFT") 
  setAttribute(hboxListRecords, "EXPAND", "YES") 
  setAttribute(hboxListRecords, "HORIZONTALFREE", "YES") 
  setAttribute(hboxListRecords, "MARGIN", "5x5")
  setAttribute(hboxListRecords, "GAP", "0")
  discard insert(hboxListRecords, nil, listRecordsUids)
  discard insert(hboxListRecords, nil, listRecordsTitle)

  var fillMain = fill()

  var textQuickSearch = text("onTextQuickSearch")
  setAttribute(textQuickSearch, "ALIGNMENT", "ALEFT") 
  setAttribute(textQuickSearch, "EXPAND", "YES") 
  discard setHandle("textQuickSearch", textQuickSearch)

  var vboxMain = vbox(nil)
  setAttribute(vboxMain, "ALIGNMENT", "ALEFT") 
  setAttribute(vboxMain, "EXPAND", "YES") 
  setAttribute(vboxMain, "MARGIN", "5x5")
  setAttribute(vboxMain, "GAP", "5")
  discard insert(vboxMain, nil, textQuickSearch)
  discard insert(vboxMain, nil, fillMain)
  discard insert(vboxMain, nil, hboxListRecords)
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
