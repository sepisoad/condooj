let MAX_PASSWORD_LEN = 128

proc generate*( len: int, 
                allowAlphabetUpperCase: bool,
                allowAlphabetLowerCase: bool,
                allowNumbers: bool,
                allowSymbols: bool): string =
  return ""