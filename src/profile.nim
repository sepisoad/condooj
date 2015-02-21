import os
import streams
import json
import globals
import dropbox

## create default dropbox user profile
## TODO: test
proc create*(userFilePath: string, user: ref TDropboxUserInfo, canOverwrite: bool): bool =
  if true == existsFile(userFilePath):
    if false == canOverwrite:
      stderr.writeln("Error: a user profile already exists")
      return false

  if "" == dropbox.authenticateUser():
    ##TODO: complete this operation
    stderr.writeln("Error: failed to authenticate dropbox user")
    return false

  var user = dropbox.getUserInfo()
  if nil == user:
    ##TODO: complete this operation
    stderr.writeln("Error: failed to retreive dropbox user info")
    return false

  var userFileStream = streams.newFileStream(userFilePath, system.fmWrite)
  if(nil == userFileStream):
    var errCode = os.osLastError()
    stderr.writeln("Error: failed to create \"" & userFilePath & "\" file.")
    stderr.writeln(osErrorMsg(errCode))
    return false

  streams.writeln(userFileStream, "{")
  streams.writeln(userFileStream, 
                  "\t\"dropbox_user_name\": " & json.escapeJson(user.userName) & ",")
  streams.writeln(userFileStream, 
                  "\t\"dropbox_user_id\": " & json.escapeJson(user.userID) & ",")
  streams.writeln(userFileStream, 
                  "\t\"dropbox_user_display_name\": " & json.escapeJson(user.userDisplayName))
  streams.writeln(userFileStream, "}")

  streams.close(userFileStream)

  return true