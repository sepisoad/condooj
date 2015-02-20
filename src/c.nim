{.compile: "c/aes.c".}
{.compile: "c/sha256.c".}
{.compile: "c/protection.c".}

type TDigest = array[0..31, uint8]

proc toString(digest: TDigest): string = 
  result = ""
  for index in 0..31:
    result &= $digest[index]

proc `$` (digest: TDigest): string = 
  result = toString(digest)

proc createPassphraseDigest(passphrase: cstring, digest: var TDigest): cint {.importc: "create_passphrase_digest".}
proc encryptMemory(buffer: cstring, bufferLen: cint, key: TDigest, encryptedBuffer: var cstring, encryptedBufferLen: var cint ): cint {.importc: "encrypt_memory".}
proc decryptMemory(buffer: cstring, bufferLen: cint, key: TDigest, decryptedBuffer: var cstring, decryptedBufferLen: var cint ): cint {.importc: "decrypt_memory".}
proc freeAllocatedBuffer(buffer: cstring): cint {.importc: "free_allocated_mem".} # not sure if we need this one