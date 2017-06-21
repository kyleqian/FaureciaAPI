//jimf
//add Tristans Omega Can stuff
#include <mcp_can.h>
#include <mcp_can_dfs.h>
#include <SPI.h> 

//#include <OmegaSeatBtCommands.h>
#include <SoftwareSerial.h>

SoftwareSerial btSerial(8, 7); // RX, TX

const int linRx = 5;
const int linTx = 6;
//const int ledPin = 13;
const int chipSelect = 4; // HIGH enables MCP2003 chip select. can it be tied high?
int countDelay = 0;
int countLoops = 0;
//
const int fanOffMin = 10;//
const int ventMaxSpeed = 238;// the Omega vent doesn't seem to like higher values
//
const int interFrameDelay = 10;//delay between frames
//
//array slots for control values
//
const int ventDriverSlot = 2;
const int ventPassSlot = 3;
//
const int heatCushionDriverSlot = 2;
const int heatBackDriverSlot = 3;
const int heatCushionPassSlot = 4;
const int heatBackPassSlot = 5;
//
const int ventLeftRearSlot = 2;
const int ventRightRearSlot = 3; 
//
const int heatCushionLeftRearSlot = 2;
const int heatBackLeftRearSlot = 3;
const int heatCushionRightRearSlot = 4;
const int heatBackRightRearSlot = 5;

//
// vent frame info
const int frameIdVent = 0x11;// 11//0x11;
byte fanSpeedDriver = 0;
byte fanSpeedPassenger = 0;
const int frameLengthVent = 5;
byte frameVentFront[] = {frameLengthVent, frameIdVent, fanSpeedDriver, fanSpeedPassenger, 0x00};
//
// rear vent frame rear info
const int frameIdVentRear = 0x99;//id = 19
byte fanSpeedDriverRear = 0;
byte fanSpeedPassengerRear = 0;
byte frameVentRear[] = {frameLengthVent, frameIdVentRear, fanSpeedDriverRear, fanSpeedPassengerRear, 0x00};
//
//heat frame info
const int frameIdHeat = 0x50; // 10;//0x50
const int frameLengthHeat = 6;
int cushionHeatDriver = 0;
int backHeatDriver = 0;
int cushionHeatPassenger = 0;
int backHeatPassenger = 0;
byte frameHeatFront[] = {frameLengthHeat, frameIdHeat, 0x00, 0x00, 0x00, 0x00};

//heat frame rear info
const int frameIdHeatRear = 0xD8;//18
int cushionHeatLeftRear = 0;
int backHeatLeftRear = 0;
int cushionHeatRightRear = 0;
int backHeatRightRear = 0;
byte frameHeatRear[] = {frameLengthHeat, frameIdHeatRear, 0x00, 0x00, 0x00, 0x00};

//response frame info
const int frameIdResponse = 0x92; // 12//0x92;
byte frameResponseFront[] = {frameIdResponse};

//target baud rate
const int linBaudRate = 10417;
//delay per bit in microseconds this should be an interrupt
//const int bitDelay = 96;
const int bitDelay = 90;
// 13 bits 'low' and one bit 'high'
const int breakDelay = 13;
//bluetooth/serial info
String inputString = "";         // a string to hold incoming data
//boolean stringComplete = false;  // whether the string is complete

// the cs pin of the version after v1.1 is default to D9
// v0.9b and v1.0 is default D10
const int SPI_CS_PIN = 9;
int delayCount = 0;
unsigned long lanSleepCount = 0;
bool lanSleeping = false;

//const int shoulderForwardPin = 4;
//const int shoulderRearwardPin = 3;
//keep the GM-LAN 'alive' all the time (issues?)
unsigned char keepAliveGmLan[8] = {0xFE, 0x01, 0x3E, 0x00, 0x00, 0x00, 0x00, 0x00};
const int keepAliveGmLanId = 0x101;
//system power mode extended
//0x10242040  0x02

/*const String motorAry[] = {
 DRIVER_SEAT_FORE_AFT,
 DRIVER_SEAT_RECLINE,
 DRIVER_CUSHION_FRONT,
 DRIVER_SEAT_UP_DOWN,
 DRIVER_SEAT_UPPER_SHOULDER
}*/

//MCP_CAN CAN(SPI_CS_PIN);
MCP_CAN OMEGA(SPI_CS_PIN);                                    // Set CS pin

void setup()
{
  Serial.begin(57600);
  //SERIAL_DEBUG_SETUP(57600);
  //pinMode(shoulderForwardPin, INPUT_PULLUP);
  //pinMode(shoulderRearwardPin, INPUT_PULLUP);
  //
  pinMode(chipSelect, OUTPUT);
  digitalWrite(chipSelect, LOW);//keep low until everything is set up
  pinMode(linTx, OUTPUT);
  digitalWrite(linTx, HIGH);
  pinMode(linRx, INPUT_PULLUP);
  

  btSerial.begin(57600);
  btSerial.println("Omega seat control connected");
  //
  //while (CAN_OK != CAN.begin(CAN_33KBPS))  
  while (CAN_OK != OMEGA.begin(CAN_33KBPS))  // GM-LAN baudrate = 33k
  {
    delay(100);
    Serial.println("CAN BUS Shield init fail");
    //DEBUG(" Init CAN BUS Shield again");    
  }
  Serial.println("CAN BUS Shield init ok!");
  //send wake up I don't think this needed
  //unsigned char empty[] = {0x00};
  //CAN.sendMsgBuf(0x100, 0, 0, empty);
  delay(1000);
  digitalWrite(chipSelect, HIGH);//enable LIN chip
}
//25D
//0x06 0xAE 0x01 0xAA 0xA8 0x80 0x00
//unsigned char seatMessage[8] = {0, 1, 2, 3, 4, 5, 6, 7};
//unsigned char seatMessage[8] = {0x06, 0xAE, 0x01, 0xAA, 0xA8, 0x80, 0x00, 0x00};

void loop()
{
  sendKeepAliveMessage();
  //check for bluetooth data
  serialEvent();
  updateThermalLin();
  delay(100);
  countDelay ++;
  if(countDelay>100){
    if(btSerial.isListening()){
      btSerial.print("seat connected - ");
      btSerial.println(countLoops);
    }    
    countDelay = 0;
    countLoops ++;
  }                    
}
//
void sendKeepAliveMessage(){
  OMEGA.KeepAlive();
}
void updateThermalLin() {
  writeToLinBus(frameHeatFront);
  delay(interFrameDelay);
  writeToLinBus(frameVentFront);
  delay(interFrameDelay);
  writeToLinBus(frameVentRear);
  delay(interFrameDelay);
}

void writeToLinBus(byte messageAry[]) {
  //set break line low
  byte count = messageAry[0];
  digitalWrite(linTx, LOW);
  delayMicroseconds(bitDelay * 13);
  //break line high for delay++
  digitalWrite(linTx, HIGH);
  delayMicroseconds(bitDelay * 3);
  //
  //0x55  sync char
  writeLinChar(0x55);
  for (int i = 1; i < count; i++) {
    writeLinChar(messageAry[i]);
  }
  writeLinChar(generateCheckSum(messageAry));
  digitalWrite(linTx, HIGH);
}
//
void writeLinChar(byte theByte) {
  writeSync();
  for (int i = 0; i < 8 ; i++) {
    digitalWrite(linTx, ((theByte >> i) & 1) > 0);
    delayMicroseconds(bitDelay);
  }
}
//
byte generateCheckSum(byte messageAry[]) {
  byte count = messageAry[0];
  int checkSum = 0x00;
  for (int i = 1; i < (count) ; i++) {
    checkSum = checkSum + messageAry[i];
    checkSum = (checkSum > 0xFF) ? (checkSum - 0xFF) : checkSum;
  }
  checkSum = checkSum ^ 0xFF;
  return checkSum;
}
//
void writeSync() {
  digitalWrite(linTx, HIGH);
  delayMicroseconds(bitDelay);
  digitalWrite(linTx, LOW);
  delayMicroseconds(bitDelay);
}
//
void serialEvent() {
  String inString;
  int loc;
  char hexVal[2];
  //bool commandReceived = false;
  int tempInt;
  //
  //changed use Tristans' function calls
  while (btSerial.available()>0) {
    //commandReceived = true;
    char inChar = btSerial.read();
    if(inChar == '\n'){     
      loc = inString.indexOf(',');
      if (loc != -1) { 
        //fore aft driver
        if(inString.charAt(loc-1) == 'A'){
          OMEGA.Slide(inString.charAt(loc+1)); 
          OMEGA.UpdateGeneral(0x25D); 
          //btSerial.println("fore aft driver "); 
          break; }
        //height driver
        if(inString.charAt(loc-1) == 'B'){
          OMEGA.Height(inString.charAt(loc+1)); 
          OMEGA.UpdateGeneral(0x25D); 
          //btSerial.println("height driver");
          break; }
        //recline driver
        if(inString.charAt(loc-1) == 'C'){
          OMEGA.Recline(inString.charAt(loc+1)); 
          OMEGA.UpdateGeneral(0x25D); 
          //btSerial.println("recline driver");
          break; }
        //angle driver
        if(inString.charAt(loc-1) == 'D'){
          OMEGA.CushionFrontAngle(inString.charAt(loc+1)); 
          OMEGA.UpdateGeneral(0x25D); 
          //btSerial.println("angle driver");
          break; }
        //lumbar driver
        if(inString.charAt(loc-1) == 'E'){
          OMEGA.Lumbar(inString.charAt(loc+1));  
          OMEGA.UpdateBolster(0x25D); 
          //btSerial.println("lumbar driver");
          break; }
        //upper back driver
        if(inString.charAt(loc-1) == 'F'){
          OMEGA.UpperBackAngle(inString.charAt(loc+1)); 
          OMEGA.UpdateBolster(0x25D); 
          //btSerial.println("upper back driver");
          break; }
        
         //Massage driver
        if(inString.charAt(loc-1) == 'G'){
          OMEGA.Massage(inString.charAt(loc+1),inString.charAt(loc+2)); 
          OMEGA.UpdateMassage(0x25D); 
          //btSerial.println("Massage driver");
          break; }
        //Haptic driver disable for now
        //if(inString.charAt(loc-1) == 'H'){OMEGA.Haptic(inString.charAt(loc+1),inString.charAt(loc+2)); OMEGA.UpdateHaptic(0x25D); btSerial.println("Haptic driver");};
        //cushion length adj
        if(inString.charAt(loc-1) == 'H'){
          OMEGA.CushionLengthAdjust(inString.charAt(loc+1)); 
          OMEGA.UpdateBolster(0x25D); 
          //btSerial.println("cushion length adj");
          break; }
        /*
         * 
         */
         //fore aft passenger
        if(inString.charAt(loc-1) == 'I'){
          OMEGA.Slide(inString.charAt(loc+1)); 
          OMEGA.UpdateGeneral(0x25E); 
          //btSerial.println("fore aft passenger");
          break; }
        //height passenger
        if(inString.charAt(loc-1) == 'J'){
          OMEGA.Height(inString.charAt(loc+1)); 
          OMEGA.UpdateGeneral(0x25E); 
          //btSerial.println("height passenger");
          break; }

        //recline passenger
        if(inString.charAt(loc-1) == 'K'){
          OMEGA.Recline(inString.charAt(loc+1)); 
          OMEGA.UpdateGeneral(0x25E); 
          //btSerial.println("recline passenger");
          break; }
        //angle passenger
        if(inString.charAt(loc-1) == 'L'){
          OMEGA.CushionFrontAngle(inString.charAt(loc+1)); 
          OMEGA.UpdateGeneral(0x25E);  
          //btSerial.println("angle passenger");
          break; }
        //lumbar passenger
        if(inString.charAt(loc-1) == 'M'){
          OMEGA.Lumbar(inString.charAt(loc+1)); 
          OMEGA.UpdateBolster(0x25E); 
          //btSerial.println("lumbar passenger");
          break; }
        //upper back passenger
        if(inString.charAt(loc-1) == 'N'){
          OMEGA.UpperBackAngle(inString.charAt(loc+1)); 
          OMEGA.UpdateBolster(0x25E); 
          //btSerial.println("upper back passenger");
          break; }
        
         //Massage passenger
        if(inString.charAt(loc-1) == 'O'){
          OMEGA.Massage(inString.charAt(loc+1),
          inString.charAt(loc+2)); 
          OMEGA.UpdateMassage(0x25E);  
          //btSerial.println("Massage passenger");
          break; }
        //Haptic passenger
        //if(inString.charAt(loc-1) == 'P'){OMEGA.Haptic(inString.charAt(loc+1),inString.charAt(loc+2)); OMEGA.UpdateHaptic(0x25E); btSerial.println("Haptic passenger");};
        //cushion length adj
        if(inString.charAt(loc-1) == 'P'){
          OMEGA.CushionLengthAdjust(inString.charAt(loc+1)); 
          OMEGA.UpdateBolster(0x25E); 
          //btSerial.println("cushion length adj");
          break; }
        
        /*
        *
        * 
        */

        //vent driver
        if(inString.charAt(loc-1) == 'a'){
          hexVal[0] = inString.charAt(loc+1);
          hexVal[1] = inString.charAt(loc+2);
          tempInt = strtol(hexVal, NULL, 16);
          tempInt = constrain(tempInt,0,ventMaxSpeed);
          frameVentFront[ventDriverSlot] = tempInt;
          //btSerial.println("vent driver");
          break; }
        //heat cushion driver 
        if(inString.charAt(loc-1) == 'b'){
          hexVal[0] = inString.charAt(loc+1);
          hexVal[1] = inString.charAt(loc+2);
          //constrain(inData,0,ventMaxSpeed);
          tempInt = strtol(hexVal, NULL, 16);
          tempInt = constrain(tempInt,0,255);
          frameHeatFront[heatCushionDriverSlot] = tempInt;
          //btSerial.println("heat cushion driver ");
          break; }
          //heat back driver 
        if(inString.charAt(loc-1) == 'c'){
          hexVal[0] = inString.charAt(loc+1);
          hexVal[1] = inString.charAt(loc+2);
          tempInt = strtol(hexVal, NULL, 16);
          tempInt = constrain(tempInt,0,255);
          frameHeatFront[heatBackDriverSlot] = tempInt;
          //btSerial.println("heat back driver");
          break; }

          //vent passenger
        if(inString.charAt(loc-1) == 'd'){
          hexVal[0] = inString.charAt(loc+1);
          hexVal[1] = inString.charAt(loc+2);
          tempInt = strtol(hexVal, NULL, 16);
          tempInt = constrain(tempInt,0,ventMaxSpeed);
          frameVentFront[ventPassSlot] = tempInt;
          //btSerial.println("vent passenger");
          break; }
        //heat cushion passenger 
        if(inString.charAt(loc-1) == 'e'){
          hexVal[0] = inString.charAt(loc+1);
          hexVal[1] = inString.charAt(loc+2);
          tempInt = strtol(hexVal, NULL, 16);
          tempInt = constrain(tempInt,0,255);
          frameHeatFront[heatCushionPassSlot] = tempInt;
          //btSerial.println("heat cushion passenger");
          break; }
          //heat back passenger
        if(inString.charAt(loc-1) == 'f'){
          hexVal[0] = inString.charAt(loc+1);
          hexVal[1] = inString.charAt(loc+2);
          tempInt = strtol(hexVal, NULL, 16);
          tempInt = constrain(tempInt,0,255);
          frameHeatFront[heatBackPassSlot] = tempInt;
          //btSerial.println("heat back passenger");
          break; }


          // hw wakeup
          if(inString.charAt(loc-1) == 'Z'){
          OMEGA.hvWakeUp();
          btSerial.println("hv wakeup");
          break; 
          }            
      }
       btSerial.println(inString);
      //reset inString
      inString = "";
    }else{ 
      //continue collecting chars     
       inString += inChar; 
    } 
  }
  //if(commandReceived){
   //btSerial.println("command received");
  // stringComplete = true;
   //}     
}

