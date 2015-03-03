{.compile: "c/aes.c".}
{.compile: "c/sha256.c".}
{.compile: "c/utils.c".}

type TDigest* = array[0..31, uint8]

type TProtectedBuffer = object
  buffer*: cstring
  len*: cint

proc c_createPassphraseDigest(passphrase: cstring, 
                              digest: var TDigest): 
  cint {.importc: "create_passphrase_digest".}
proc c_encryptMemory( buffer: cstring, 
                      bufferLen: cint, 
                      key: TDigest, 
                      encryptedBuffer: var cstring, 
                      encryptedBufferLen: var cint ): 
  cint {.importc: "encrypt_memory".}
proc c_decryptMemory( buffer: cstring, 
                      bufferLen: cint, 
                      key: TDigest, 
                      decryptedBuffer: var cstring, 
                      decryptedBufferLen: var cint ): 
  cint {.importc: "decrypt_memory".}

proc c_saveEncryptedMemory( path: cstring,
                            buffer: cstring,
                            bufferLen: cint):
  cint {.importc: "save_encrypted_memory".}

proc c_loadEncryptedFile( path: cstring,
                          key: TDigest,
                          decryptedBuffer: var cstring,
                          decryptedBufferLen: var cint):
  cint {.importc: "load_encrypted_file".}

proc c_freeAllocatedBuffer(buffer: cstring): 
  cint {.importc: "free_allocated_mem".} # not sure if we need this one

## convert TDigest to string
proc toString*(digest: TDigest): string = 
  result = ""
  for index in 0..31:
    result &= $digest[index]

## convert TDigest to string
proc `$`*(digest: TDigest): string = 
  result = toString(digest)

## produce digest out of passphrase
proc createPassphraseDigest*(passphrase: cstring): TDigest = 
  discard c_createPassphraseDigest(passphrase, result)

## generate protected buffer object out of raw string
proc createProtectedBuffer*(buffer: cstring, len: cint): ref TProtectedBuffer = 
  new(result)
  result.buffer = buffer
  result.len = len

## encrypt buffer
proc encryptBuffer*(buffer: cstring, key: TDigest): ref TProtectedBuffer = 
  var bufferLen = cast[cint](buffer.len)

  new(result)
  result.buffer = nil
  result.len = 0
    
  if 0 == c_encryptMemory(buffer, bufferLen, key, result.buffer, result.len):
    echo("Error: encryptBuffer-1")
    return nil
  if 0 == result.len:
    echo("Error: encryptBuffer-1")
    return nil

## decrypt buffer
proc decryptBuffer*(protectedBuffer: ref TProtectedBuffer, key: TDigest): string = 
  var decBuffer: cstring = nil
  var decBufferLen: cint = 0

  if 0 == c_decryptMemory(protectedBuffer.buffer, protectedBuffer.len, key, decBuffer, decBufferLen):
    echo("Error: decryptBuffer-1")
    return nil
  if 0 == decBufferLen:
    echo("Error: decryptBuffer-2")
    return nil

  result = $decBuffer
  discard c_freeAllocatedBuffer(decBuffer)

## save encrypted buffer to file
proc saveEncryptedBuffer*(path: cstring, protectedBuffer: ref TProtectedBuffer): bool =
  if 0 == c_saveEncryptedMemory(path, protectedBuffer.buffer, protectedBuffer.len):
    echo("Error: failed to save encrypted buffer")
    return false

  return true

## loads an encrypted buffer and returns the decrypted value  
proc decryptFile*( path: cstring,
                  key: TDigest): string = 
  var decBuffer: cstring = nil
  var decBufferLen: cint = 0

  if 0 == c_loadEncryptedFile(path, key, decBuffer, decBufferLen):
    echo("Error: failed to load encrypted file");
    return nil

  result = $decBuffer
  discard c_freeAllocatedBuffer(decBuffer)

when isMainModule:
  var buffer = """{ "title": "github3", "username": "sepisoad", "password": "1234", "email": "UNDEFINED", "description": "UNDEFINED", "date": "2015-03-01", }"""
  var key = createPassphraseDigest("hello")
  var encBuffer = encryptBuffer(buffer, key)

  if false == saveEncryptedBuffer("DB", encBuffer):
    echo ("OH SHIT")

  var decBuffer = decryptFile("DB", key)
  if nil == decBuffer:
    echo ("OH FUCK")

  echo(decBuffer)
