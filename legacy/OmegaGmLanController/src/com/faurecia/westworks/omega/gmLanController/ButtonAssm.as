package com.faurecia.westworks.omega.gmLanController 
 {
	
	import flash.display.MovieClip;
	import flash.events.DataEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	
	public class ButtonAssm extends MovieClip {
		//public var upTxt:TextField;
		//public var downTxt:TextField;
		public var theButton:ButtonBase;
		
		public var pressStr:String = "";
		public var releaseStr:String = "";
		public var clickStr:String = "";
		
		public static const PRESSED:String = "buttonPressed";
		public static const RELEASED:String = "buttonReleased";
		public static const CLICKED:String = "buttonClicked";
		
		
		public function ButtonAssm() {
			theButton.addEventListener(MouseEvent.MOUSE_DOWN, buttonPressedEvent);
			theButton.addEventListener(MouseEvent.CLICK, buttonClickedEvent);
			
		}
		
		private function buttonClickedEvent(e:MouseEvent):void 
		{
			if (clickStr != "") {
				stage.dispatchEvent(new DataEvent(CLICKED, false, false, clickStr));
			}
		}
		
		private function buttonPressedEvent(e:MouseEvent):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, buttonUpEvent);
			//Object(root).sendCommand(downTxt.text+"\r");
			if (pressStr != "") {
				stage.dispatchEvent(new DataEvent(PRESSED, false, false, pressStr));
			}
			
		}
		
		private function buttonUpEvent(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, buttonUpEvent);
			if (releaseStr != "") {
				stage.dispatchEvent(new DataEvent(RELEASED, false, false, releaseStr));
			}
			
		}
	}
	
}
