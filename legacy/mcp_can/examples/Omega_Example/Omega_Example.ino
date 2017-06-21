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
    omega.Slide (FORWARD);
    omega.Height (UP);
    omega.Recline (FORWARD);
    omega.Angle (INCREASE);
    omega.Lumbar (INCREASE);
    omega.UpperBack (FORWARD);
    omega.Massage (MASSAGE2,3);
    omega.Haptic (R, 3);
    omega.Haptic (L, 0);
  }
  else if (forward == false)
  {
    omega.Slide (REVERSE);
    omega.Height (DOWN);
    omega.Recline (REVERSE);
    omega.Angle (DECREASE);
    omega.Lumbar (DECREASE);
    omega.Massage (MASSAGE3, 3);
    omega.Haptic (L, 3);
    omega.Haptic (R, 0);
  }
  
  if (millis()>Timer2+1000)
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
