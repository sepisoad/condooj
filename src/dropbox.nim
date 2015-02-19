type TDropboxUserInfo* = object
  userName*: string
  userID*: string
  userDisplayName*: string

## authenticate dropbox user
## returns a link to the dropbox user authentication page
## TODO: test, implement
proc authenticateUser*(): string =
  return ""

## get dropbox user info
## TODO: test, implement
proc getUserInfo*(): ref TDropboxUserInfo = 
  return nil