package  com.faurecia.westworks.omega.gmLanController{
	

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.net.Socket;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	
	import flash.desktop.NativeApplication;
	
	
	public class OmegaObdSettingsPanel extends MovieClip {
	
		private var OmegaSettingsPanelCookie:SharedObject;
		private var OmegaSettingsPanelCookieId:String;
		
		public var socketConnectBtn:MovieClip;
		public var socketConnectBtnTxt:TextField;
		public var socketServerIpAddrTxt:TextField;
		public var socketServerPortTxt:TextField;
		public var incomingDataTxt:TextField;
		public var buildDateTxt:TextField;
		
		//public var killAppBtn:ButtonBase;
		
		public var targetDriverBtn:ButtonBase;
		public var targetPassengerBtn:ButtonBase;
		public var targetLRearBtn:ButtonBase;
		public var targetRRearBtn:ButtonBase;
		
		public var currentSeatTxt:TextField;
		public var tempInputTxt:TextField;
		
		
		
		private var socketHostIpAddr:String;
		private var socketPort:int;
		private var socketClient:Socket;
		private var connectTimeout:Number;
		
		public var currentMassageIntensity:String = OmegaControlStrings.MASSAGE_INTENSITY_0_OFF;
		public var currentMassageProgram:String = OmegaControlStrings.MASSAGE_TYPE_1;
		
		public var currentHapticIntensity:String = OmegaControlStrings.HAPTIC_INTENSITY_LOW;
		public static const HAPTIC_LEFT:Boolean = true;
		public static const HAPTIC_RIGHT:Boolean = false;
		public var currentHapticSide:Boolean = true;
		
		private var massageTimeout:int;
				
		//modified startup sequence
		private var startUpSeq:Array  = new Array("AT S0", "AT H1", "AT AL", "AT V1", "ST P63", "AT CAF0", "AT R0", "AT SH100", "ST CSWM2", "AT BI", "AT RTR", "ST CSWM3", "ST P61");
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
		//private var startUpSeqTimer:Timer;
		
		
		// wake up set header to 0x100... send me twice! "AT SH 100";
		private var hwWakeUpHeader:String = "AT SH 100";
		private var hwWakeUpString:String = "  " ;
		
		private var wakeUpHeader:String = "63D";
		private var wakeUpString:String = "01 7F 00 00 00 00 00 00";
		
		private var keepAliveHeader:String = "63D";
		private var keepAliveString:String = "00 7F 00 00 00 00 00 00";
		//private var keepAliveTimer:Timer; 
		private var startUpSeqIdx:int;
		
		private var sendQue:Array = new Array();
		private var currentHeader:String = "";
		private var previousHeader:String = "x";
		
		private var sendQueTimer:Timer;
		private var watchdogTimer:int;
		private var watchDogTimerB:Timer;
		private var wifiTimer:int;
		private var wifiKeepAliveString:String = "AT RV";
		private var lastSentData:String = "ati";
		private var checkSocketTimer:Timer;
		private var hidePanelTimer:int;
		public static const  MASSAGE_OFF:String = "massageTimeOut";
		
		
		private var _targetSeatId:String;
		
		public function OmegaObdSettingsPanel() {
			trace("OmegaObdSettingsPanel");
			OmegaSettingsPanelCookieId = getSwfFileName();
			OmegaSettingsPanelCookie = SharedObject.getLocal(OmegaSettingsPanelCookieId + "CommSettings");
			// set vars used for socket connect to shared object (at startup)			
			if (OmegaSettingsPanelCookie.data.networkConnectId != null)
			{
				socketHostIpAddr = OmegaSettingsPanelCookie.data.networkConnectId;
			}
			else
			{
				socketHostIpAddr = "192.168.0.10";
			}
			if (OmegaSettingsPanelCookie.data.socketPortId < 4000)
			{
				socketPort = OmegaSettingsPanelCookie.data.socketPortId;
			}
			else 
			{
				socketPort = 35000;
			}
			
				
			trace(socketHostIpAddr + "   " + socketPort);
			socketServerIpAddrTxt.text = socketHostIpAddr;
			socketServerPortTxt.text = socketPort.toString();
			
			
			socketClient = new Socket();
						
			buildDateTxt.text = "4/4/2016";
			//killAppBtn.addEventListener(MouseEvent.CLICK, killAppEvent);
			
			_targetSeatId = OmegaControlStrings.OMEGA_HEADER_DRIVER;
									
			sendQueTimer = new Timer(80);
			sendQueTimer.addEventListener(TimerEvent.TIMER, updateQueEvent);
			sendQueTimer.start();
			
			//watchdogTimer = setTimeout(sendKeepAliveMessage, 3000);		
			watchDogTimerB = new Timer(3500);
			watchDogTimerB.addEventListener(TimerEvent.TIMER, sendKeepAliveMessage);
			
			init();
			setTimeout(function() { visible = false; }, 1200);
			stage.addEventListener(MouseEvent.CLICK, showHidePanelClick);
		}
		
			private function setTargetSeatIdEvent(e:MouseEvent):void 
		{
			clearTimeout(hidePanelTimer);
			//trace(e.currentTarget.id);
			_targetSeatId = e.currentTarget.id;
			if ((e.currentTarget == targetRRearBtn) &&(tempInputTxt.text != "")){
				
				_targetSeatId = tempInputTxt.text;
			}
			trace("_targetSeatId = " + _targetSeatId);
			hidePanelTimer = setTimeout(hidePanelEvent, 10000);
		}
		
		private function killAppEvent(e:MouseEvent):void 
		{
			NativeApplication.nativeApplication.exit(); 
		}
		
		private function showHidePanelClick(e:MouseEvent):void 
		{
			clearTimeout(hidePanelTimer);
			if ((stage.mouseX > (stage.stageWidth -100)) && (stage.mouseY > (stage.stageHeight - 100))) {
				this.visible = ! this.visible;	
			}
			if (this.visible) {
				hidePanelTimer = setTimeout(hidePanelEvent, 10000);	
			}
		}
		private function hidePanelEvent() {
			this.visible = false;	
		}
		
		private function updateQueEvent(e:TimerEvent):void 
		{			
			if (sendQue.length > 0) {
					sendOutSocketData(sendQue.shift()); 					
			}			
		}
		
		public function sendToQue(message:String):void {
			sendQue.push(message);
			if (sendQue.length > 20) {
					//truncate if needed
			}
		}		
		
		private function sendKeepAliveMessage(e:TimerEvent):void 
		{
			
			sendToQue("AT SH " + "101");
			sendToQue("FE013E0000000000");
			sendToQue("AT SH " + keepAliveHeader);
			sendToQue(keepAliveString);			
		}	
		
		private function sendHvWakeCommand(e:MouseEvent):void 
		{
			//send two hw wake up messages
			sendToQue(hwWakeUpHeader);
			sendToQue(hwWakeUpString);
			sendToQue(hwWakeUpHeader);
			sendToQue(hwWakeUpString);
		}
		
		
		private function sendObdSetUpCommands(e:MouseEvent = null):void 
		{	
			// rewritten
			for (var i:int = 0; i < startUpSeq.length; i++) {
				sendToQue(startUpSeq[i]);
			}
			watchDogTimerB.start();
		}
		public function updateMassageState():void 
		{
			//set/clear timer for 5 minutes
			clearTimeout(massageTimeout);
			massageTimeout = setTimeout(turnOffMassage, 5 * 60 * 1000);
			sendToQue("AT SH " + _targetSeatId);
			
			sendToQue(OmegaControlStrings.MASSAGE_COMMON_MESSAGE + OmegaControlStrings.MASSAGE_INTENSITY_0_OFF + OmegaControlStrings.MASSAGE_TYPE_0);

			sendToQue(OmegaControlStrings.MASSAGE_COMMON_MESSAGE + currentMassageProgram + currentMassageIntensity);
			
			// is this needed for massage???
			//65D02EE29AAAAAAAAAA
			sendToQue("AT SH " +"65D");
			sendToQue("02EE29AAAAAAAAAA");
		}
		
		public function turnOffMassage():void 
		{
			clearTimeout(massageTimeout);
			sendToQue("AT SH " + _targetSeatId);
			sendToQue(OmegaControlStrings.MASSAGE_COMMON_MESSAGE + OmegaControlStrings.MASSAGE_INTENSITY_0_OFF + OmegaControlStrings.MASSAGE_TYPE_0);
			sendToQue(OmegaControlStrings.MASSAGE_STOP_ALL);
			// is this needed for massage???
			//65D02EE29AAAAAAAAAA
			sendToQue("AT SH " +"65D");
			sendToQue("02EE29AAAAAAAAAA");
			
			stage.dispatchEvent(new Event(MASSAGE_OFF));
		}
		
		public function updateHapticState() {			
			sendToQue("AT SH " + _targetSeatId);			
			sendToQue("07 AE 35 03" + ( ((currentHapticSide == HAPTIC_RIGHT) ? currentHapticIntensity : "00") + ((currentHapticSide == HAPTIC_LEFT) ? currentHapticIntensity : "00"))  + "0000");
		}
		
		public function turnOffHaptic() {
			
			sendToQue("AT SH " + _targetSeatId);
			sendToQue(OmegaControlStrings.HAPTIC_OFF);
		//"07 AE 35 03 00 00 00 00";	
		}
		private function init()
		{
			socketClient.addEventListener(Event.CLOSE, socketClientCloseHandler);
			socketClient.addEventListener(Event.CONNECT, socketClientConnectHandler);
			//socketClient.addEventListener(Event., socketClientConnectHandler);
			socketClient.addEventListener(IOErrorEvent.IO_ERROR, socketClientIoErrorHandler);
			socketClient.addEventListener(SecurityErrorEvent.SECURITY_ERROR, socketClientSecurityErrorHandler);
			socketClient.addEventListener(ProgressEvent.SOCKET_DATA, socketClientSocketDataHandler);
			
			socketServerIpAddrTxt.text = socketHostIpAddr;
			socketServerPortTxt.text = String(socketPort);
			socketConnectBtnTxt.text = "connect";
			socketConnectBtnTxt.textColor = 0xcccccc;
			socketConnectBtn.gotoAndStop(1);
			//
			//currentTaskTxt.text = "waiting for connection";			
			//setTimeout(socketClientStartUpSocket, 1500);
			checkSocketTimer = new Timer(2500);
			checkSocketTimer.addEventListener(TimerEvent.TIMER, socketClientStartUpSocketEvent);
			checkSocketTimer.start();
		}
		
		private function socketClientStartUpSocketEvent(e:TimerEvent):void 
		{
			socketHostIpAddr = socketServerIpAddrTxt.text;
			socketPort = int(socketServerPortTxt.text);
			if (!socketClient.connected) {
			try {
				trace("connecting to : " + socketHostIpAddr + ":" + socketPort);
				socketClient.connect(socketHostIpAddr, socketPort);
			}catch (e:Error) {
				socketClient.close();
				watchDogTimerB.stop();
			}
			}		
			//connectTimeout = setTimeout(redoStartup, 3000);
		}
		
		private function socketClientCloseHandler(event:Event):void
		{
			trace("socket closed: ");
			socketConnectBtnTxt.text = "connect";
			socketConnectBtnTxt.textColor = 0xcccccc;
			socketConnectBtn.gotoAndStop(1);
			watchDogTimerB.stop();
			//connectTimeout = setTimeout(redoStartup, 3000);
		}
		
		private function sendOutSocketData(theData:String)
		{
			/*if (theData != wifiKeepAliveString) {
				clearTimeout(watchdogTimer);
				watchdogTimer = setTimeout(sendKeepAliveMessage, 4000);
			}	*/		
			
			if (socketClient.connected)
			{
				socketClient.writeUTFBytes(theData+ "\r");
				socketClient.flush();
				trace("sent: " + theData);
				lastSentData = theData;
			}
			else
			{
				trace("couldn't send:" + theData);
			}
			clearTimeout(wifiTimer);
			wifiTimer = setTimeout(wifiKeepAlive, 4000);
		
		}
		
		private function wifiKeepAlive():void 
		{ 
			
			trace("wifiKeepAlive is disabled");
			//sendToQue(wifiKeepAliveString);
			//sendToQue(lastSentData);
			//sendToQue("AT SH 24D");
			//sendToQue("AT SH 024D");
		}
		
		private function socketClientConnectHandler(event:Event):void
		{
			clearTimeout(connectTimeout);
			socketClient.flush();
			//	
			//serialOutput.text = "connected!";
			socketConnectBtnTxt.text = "connected";
			socketConnectBtnTxt.textColor = 0x009DCB;
			socketConnectBtn.gotoAndStop(2);
			if (socketClient.connected)
			{
				updateSharedObject();
			}
			
			setTimeout(sendObdSetUpCommands, 500);
		}
		
		private function socketClientIoErrorHandler(event:IOErrorEvent):void
		{
			socketConnectBtn.play();
			//serialOutput.text = "problem connecting.. retrying";
			trace("ioErrorHandler: " + event + "  target : " + event.target);
			watchDogTimerB.stop();
		}
		
		private function socketClientSecurityErrorHandler(event:SecurityErrorEvent):void
		{
			trace("securityErrorHandler: " + event);
		}
		
		private function socketClientSocketDataHandler(theEvent:ProgressEvent):void
		{
			try
			{
				var tempSocket:Socket = theEvent.target as Socket;
				//var bytes:ByteArray = new ByteArray();				
				var requestData:String = tempSocket.readUTFBytes(tempSocket.bytesAvailable);
				requestData = requestData.replace(/[\u000d\u000a\u0008\u0020]+/g,"");  //remove spaces for checking
				trace("from OBD-MX: " + requestData);
				//incomingDataTxt.scrollV = incomingDataTxt.maxScrollV;
				incomingDataTxt.text = ("from OBD-MX: " + requestData);
				//incomingDataTxt.scrollV = incomingDataTxt.maxScrollV;
				//var tempAry:Array = requestData.split(",");
				switch (requestData)
				{
					case "ELM327v1.3a": 
						//setUpObdLinkMx();
						break;
				}
				
			}
			catch (error:Error)
			{
				trace(error.message, "Error");
			}
		
		}
		
		
		private function isValidIP(ip:String):Boolean
		{
			ip = ip.replace(/\s/g, ""); //remove spaces for checking
			var pattern:RegExp = /^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/;
			if (pattern.test(ip))
			{
				var octets:Array = ip.split(".");
				if (parseInt(String(octets[0])) == 0)
				{
					return false;
				}
				if (parseInt(String(octets[3])) == 0)
				{
					return false;
				}
				
				for (var i:int = 0; i < octets.length; i++)
				{
					if ((parseInt(String(octets[i])) < 0) || (parseInt(String(octets[i])) > 255) || (parseInt(String(octets[i])) == 7777))
					{
						return false;
					}
				}
				return true;
			}
			return false;
		}
		
		private function isValidPortNumber(portNum:String):Boolean
		{
			portNum = portNum.replace(/\s/g, ""); //remove spaces for checking
			//trace(int(portNum) );
			if ((int(portNum) < 4000) || (int(portNum) > 40000))
			{
				return false;
			}
			return true;
		}
		
		//save updated data to sharedObject
		private function updateSharedObject()
		{
			OmegaSettingsPanelCookie.data.networkConnectId = socketHostIpAddr;
			OmegaSettingsPanelCookie.data.socketPortId = socketPort;
			OmegaSettingsPanelCookie.flush();
		}
		
		public function get targetSeatId():String 
		{
			return _targetSeatId;   
		}
		
		public function set targetSeatId(value:String):void 
		{
			_targetSeatId = value;
		}
		
		private function getSwfFileName():String
		{
			var swfPath:String = this.loaderInfo.url;
			var tempAry:Array = swfPath.split("/");
			swfPath = tempAry[tempAry.length - 1];
			tempAry = swfPath.split(".");
			swfPath = tempAry[0];
			var trimExp:RegExp = /\s/g;
			swfPath = swfPath.replace(trimExp, "");
			return swfPath;
		}
	}
	
}
