###
# API Constants
###

OBD_IP = "192.168.0.10"
OBD_PORT = 35000
SIGNAL_TIMEOUT = 0.05 # There needs to be a delay between messages; the app itself seems to use 50ms
KEEPALIVE_TIMER = 3 # Send keep alive string every 3 seconds

###
# Incomplete list of control strings
# Copied from FaureciaAPI/legacy/OmegaGmLanController/src/com/faurecia/westworks/omega/gmLanController/OmegaControlStrings.as
###

STARTUP_SEQUENCE = ["AT S0", "AT H1", "AT AL", "AT V1", "ST P63", "AT CAF0", "AT R0", "AT SH100", "ST CSWM2", "AT BI", "AT RTR", "ST CSWM3", "ST P61"]
KEEPALIVE_SEQUENCE = ["AT SH 101", "FE013E0000000000", "AT SH 63D", "00 7F 00 00 00 00 00 00"]
COMMAND_HEADER = "AT SH 25D"

MBM_CONTROLS_OFF = "06 AE 28 00 00 00 00"
CUSHION_UP = "06 AE 01 AA A8 A0 00"
CUSHION_DOWN = "06 AE 01 AA A8 50 00"
HEADREST_UP = "06 AE 28 0A AA 08 00"
HEADREST_DOWN = "06 AE 28 0A AA 04 00"
LUMBAR_UP = "06 AE 01 AA A8 00 80"
LUMBAR_DOWN = "06 AE 01 AA A8 00 40"
HEADREST_FORWARD = "06 AE 28 0A AA 02 00"
HEADREST_REARWARD = "06 AE 28 0A AA 01 00"