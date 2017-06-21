from FaureciaConstants import *
from FaureciaAPI import FaureciaAPI

###
# Hacky API tester
###

if __name__ == "__main__":
  f = FaureciaAPI()
  while True:
    command = raw_input() # Type in literal names of constants to be eval'd
    if not command: break
    try:
      command = eval(command)
      f.command_raw(command)
    except NameError, e:
      print e
      break
  f.close()
