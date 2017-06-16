import socket
import Queue
import threading
from time import sleep
from FaureciaConstants import *

class FaureciaAPI:
  def __init__(self):
    print "Establishing socket..."
    self.socket_client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    self.socket_client.connect((ODB_IP, ODB_PORT))
    print "Socket client connected!"

    self.command_queue = Queue.Queue() # Thread-safe queue
    self.command_queue.put(tuple(STARTUP_SEQUENCE)) # Start queue off with startup sequence

    self.running = True
    self.command_thread = threading.Thread(target=self.__send_command)
    self.keep_alive_thread = threading.Thread(target=self.__keep_alive)
    self.command_thread.start()
    self.keep_alive_thread.start()
    print "Threads started!"

  def command(self):
    pass

  def command_raw(self, command):
    self.command_queue.put((COMMAND_HEADER, command))

  def close(self):
    print "Closing FaureciaAPI..."
    self.running = False
    self.command_queue.put(False)
    self.command_thread.join()
    self.keep_alive_thread.join()
    self.socket_client.close()
    print "Closed FaureciaAPI!"

  ### PRIVATE ###

  def __keep_alive(self):
    while True:
      if not self.running: return
      self.command_queue.put(tuple(KEEPALIVE_SEQUENCE))
      sleep(KEEPALIVE_TIMER)

  def __send_command(self):
    while True:
      command_tuple = self.command_queue.get() # Blocks until next available item

      if not isinstance(command_tuple, tuple):
        if self.running:
          raise "Command queue must only contain tuples!!!"
        else:
          print "Closing command thread..."
          return

      for c in command_tuple:
        self.socket_client.send(c + "\r")
        print "Sent command: " + c
        sleep(SIGNAL_TIMEOUT)

# if __name__ == "__main__":
#   main()