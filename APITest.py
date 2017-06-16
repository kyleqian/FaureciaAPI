from FaureciaConstants import *
from FaureciaAPI import FaureciaAPI

###
# Hacky API tester
###
if __name__ == "__main__":
  f = FaureciaAPI()
  while True:
    command = raw_input()
    if not command: break
    try:
      command = eval(command)
      f.command_raw(command)
    except NameError, e:
      print e
      break
  f.close()
