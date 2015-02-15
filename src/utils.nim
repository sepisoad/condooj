## this procedure makes a real path string out of its argument
proc constructPath*(paths: varargs[string]): string =
  var result: string = ""

  for path in items(paths):
    result = result & "/"
    result = result & path
  
  return result

  