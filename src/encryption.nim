import sha1

proc createPassPhraseDigest*(passPhrase: string): array[0..19, uint8] = 
  var digest: array[0..19, uint8]
  
  sha1.compute

  return temp