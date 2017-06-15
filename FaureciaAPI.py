import socket
from time import sleep

def main():
  MBM_CONTROLS_OFF = "06 AE 28 00 00 00 00"
  CUSHION_UP = "06 AE 01 AA A8 A0 00"
  CUSHION_DOWN = "06 AE 01 AA A8 50 00"
  HEADREST_UP = "06 AE 28 0A AA 08 00"
  HEADREST_DOWN = "06 AE 28 0A AA 04 00"
  LUMBAR_UP = "06 AE 01 AA A8 00 80"
  LUMBAR_DOWN = "06 AE 01 AA A8 00 40"
  HEADREST_FORWARD = "06 AE 28 0A AA 02 00"
  HEADREST_REARWARD = "06 AE 28 0A AA 01 00"

  print "Connecting..."
  socketClient = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  socketClient.connect(("192.168.0.10", 35000))
  print "Connected!"

  startUpSeq = ["AT S0", "AT H1", "AT AL", "AT V1", "ST P63", "AT CAF0", "AT R0", "AT SH100", "ST CSWM2", "AT BI", "AT RTR", "ST CSWM3", "ST P61"]
  for s in startUpSeq:
    socketClient.send(s + "\r")
    sleep(0.05)

  socketClient.send("AT SH 25D\r")
  sleep(0.05)
  socketClient.send(HEADREST_FORWARD + "\r")
  sleep(0.5)
  # socketClient.send(MBM_CONTROLS_OFF + "\r")

  print "End"

if __name__ == "__main__":
  main()