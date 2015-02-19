type TOAuth1Token* = object
  token*: string
  secret*: string

## oauth1 request token
## TODO: test, implement
proc requestToken(): ref TOAuth1Token
  return nil

## oauth1 authorize
## TODO: test, implement
proc authorize(): bool
  return false

## oauth1 access token
## TODO: test, implement
proc accessToken(): bool
  return false