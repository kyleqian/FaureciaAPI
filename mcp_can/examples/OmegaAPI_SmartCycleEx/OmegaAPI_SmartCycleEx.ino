#include <mcp_can.h>
#include <mcp_can_dfs.h>
#include <SPI.h>

MCP_CAN omega(9, DRIVER);

unsigned long Timer;
unsigned long Timer2;

boolean forward = true;

void setup() {
  while (CAN_OK != omega.begin (CAN_33KBPS))
  {
    delay(100);
  }
  delay(100);
}

void loop() {
  if (forward == true)
  {
    omega.Lumbar(DECREASE);
    omega.UpperBack(FORWARD);
    omega.Angle(UP);
  }
  else if (forward == false)
  {
    omega.Lumbar (INCREASE);
    omega.UpperBack(REVERSE);
    omega.Angle (DOWN);
  }
  
  if (millis()>Timer2+2000)
  {
    omega.Shutoff();
    forward = !forward;
    Timer2 = millis();
  }
  if (millis()>Timer+100)
  {
    omega.Update();
    Timer = millis();
  }
}
