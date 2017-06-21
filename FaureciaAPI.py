import socket
import Queue
import threading
from time import sleep
from FaureciaConstants import *

class FaureciaAPI:
  def __init__(self):
    print "Establishing socket..."
    self.socket_client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    self.socket_client.connect((OBD_IP, OBD_PORT))
    print "Socket client connected!"

    # Thread-safe queue that sends commands on a pre-defined timer
    # This queue takes in batches of commands as tuples;
    # for instance, the startup sequence is enqueued as one long tuple since the codes need to be sent in sequence
    self.command_queue = Queue.Queue()

    # Start queue off with startup sequence
    self.command_queue.put(tuple(STARTUP_SEQUENCE))

    self.running = True
    self.command_thread = threading.Thread(target=self.__send_command)
    self.keep_alive_thread = threading.Thread(target=self.__keep_alive)
    self.command_thread.start()
    self.keep_alive_thread.start()
    # print "Threads started!"

  # Every command shuld be preceded in the tuple with the COMMAND_HEADER
  def command(self):
    pass # Unimplemented

  # Every command should be preceded in the tuple with the COMMAND_HEADER
  # Enqueues a raw command string
  def command_raw(self, command):
    self.command_queue.put((COMMAND_HEADER, command))

  def close(self):
    print "Closing FaureciaAPI..."
    self.running = False
    self.command_queue.put(False) # Triggers the command thread to exit
    self.command_thread.join()
    self.keep_alive_thread.join()
    self.socket_client.close()
    print "Closed FaureciaAPI!"

  ### PRIVATE ###

  # Enqueues KEEPALIVE_SEQUENCE every KEEPALIVE_TIMER seconds
  def __keep_alive(self):
    while True:
      if not self.running: return
      self.command_queue.put(tuple(KEEPALIVE_SEQUENCE))
      sleep(KEEPALIVE_TIMER)

  # Sends the next command every SIGNAL_TIMEOUT seconds
  def __send_command(self):
    while True:
      command_tuple = self.command_queue.get() # Blocks until next available item

      if not isinstance(command_tuple, tuple):
        if self.running:
          raise "Command queue must only contain tuples!!!"
        else:
          print "Closing command thread..."
          return

      # Sends commands in tuple in sequence
      for c in command_tuple:
        self.socket_client.send(c + "\r") # r-escape is needed for every message
        print "Sent command: " + c
        sleep(SIGNAL_TIMEOUT)

# if __name__ == "__main__":
#   main()