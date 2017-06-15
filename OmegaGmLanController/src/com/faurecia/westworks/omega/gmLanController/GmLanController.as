package com.faurecia.westworks.omega.gmLanController
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.utils.Timer;
	
	import com.faurecia.westworks.omega.gmLanController.OmegaControlStrings;
	
	/**
	 * ...
	 * @author jimF
	 */
	
	public class GmLanController extends Sprite
	{
		// AT I  	elm327 version ID string
		//sequence to set up the OBD-MX at startup
		//private var startUpSeq:Array  = new Array("AT Z", "AT S0", "AT H1", "AT AL", "AT V1", "ST P63", "AT CAF0", "AT R0", "AT SH100", "ST CSWM2", "AT BI", "AT RTR", "ST CSWM3", "ST P61", "ST MA");
		private var startUpSeq:Array  = new Array("AT S0", "AT H1", "AT AL", "AT V1", "ST P63", "AT CAF0", "AT R0", "AT SH100", "ST CSWM2", "AT BI", "AT RTR", "ST CSWM3", "ST P61", "ATSH 25D");
		// AT Z  	elm327 reset
		// AT S 0 	print spaces off
		// AT H1 	print headers on
		// AT AL 	allow long messages
		//AT V 1  	use of variable DLC on
		//ST P63 	set protocol to swcan 29 bit, DLC = 8
		//AT CAF 0 	automatic formatting off
		//AT R 0  	responses off
		//AT SH 100	set header to 100
		//ST CSWM 2	??????
		//AT BI		bypass initialization process
		//AT RTR	send RTR message
		//ST CSWM 3 ?????
		//ST P61 	set protocol to swcan 11 bit variable  DLC (omega seat protocol)		
		// ST MA monitor all
		
		
		
		//25D06AE01AAA80004
		//25D06AE01AAA80404
		
		private var currentMotorState:String = "06AE0100000000";
		
		private var powerSeatHeaderDriver:String = "25D";
		private var powerSeatHeaderPassenger:String = "xxx25D";
		
		private var seatForwardDriver:String = "06AE01AAA80800";
		private var seatRearwardDriver:String = "06AE01AAA80400";		
		//
		
		//sent to OBDM-MX to see if we're connected, should return
		private var awakeCheckString:String = "AT I";
		
		// is this correct??
		private var seatAllOffDriver:String = "06AE0100000000";
		
		private var cookie:SharedObject;
		private var _ipAddress:String;
		private var _portNumber:int;
		
		private var sendDataTimer:Timer;
		private var keepAliveTimer:Timer;
		
		private var _obdConnected:Boolean = false;
		
		private var CushionFrontEnable:int = 0x80000000000;
		private var CushionRearEnable:int =  0x20000000000;
		private var SeatForeAftEnable:int =  0x08000000000;
		private var BackForeAftEnable:int =  0x02000000000;
		
		private var LumbarUpDownEnable:int =  0x00800000000;
		private var LumbarForeAftEnable:int = 0x00200000000;
		private var PetalsForeAftEnable:int = 0x00080000000;		
		
		private var CushionFrontUpMove:int =   0x80000800000;
		private var CushionFrontDownMove:int = 0x80000400000;
		private var CushionRearUpMove:int =    0x20000200000;
		private var CushionRearDownMove:int =  0x20000100000;
		
		private var SeatForwardMove:int =      0x08000008000;
		private var SeatRearwardMove:int =     0x08000004000;
		private var BackForwardMove:int =      0x02000002000;
		private var BackRearwardMove:int =     0x02000001000;
		
		private var SeatLumbarUp:int =         0x00800000080;
		private var SeatLumbarDown:int =       0x00800000040;
		private var SeatLumbarForward:int =    0x00200000020;
		private var SeatLumbarRearward:int =   0x00200000010;
		
		private var PetalsForward:int =        0x00000000008;
		private var PetalsRearward:int =       0x00000000004;
		
		
		public function GmLanController()
		{
			trace("GmLanController");
			
			cookie = SharedObject.getLocal("GmLanController");
			
			if (cookie.data.ipAddressCookie == null) {
				_ipAddress = "192.168.0.10";
			}else {
				_ipAddress = cookie.data.ipAddressCookie ;
			}
			if ( cookie.data.portNumberCookie == null) {
				_portNumber = 35000;
			}else {
				 _portNumber = cookie.data.portNumberCookie;
			}			
			sendDataTimer = new Timer(50);
			sendDataTimer.addEventListener(TimerEvent.TIMER, updateSendQueEvent);
			
			trace(OmegaControlStrings.SEAT_FOWARD);
		}
		
		private function updateSendQueEvent(e:TimerEvent):void 
		{
			
		}
		
		private function updateCookie() {
			cookie.data.ipAddressCookie = _ipAddress;
			cookie.data.portNumberCookie = _portNumber;
			cookie.flush();
		}
	
	}

}