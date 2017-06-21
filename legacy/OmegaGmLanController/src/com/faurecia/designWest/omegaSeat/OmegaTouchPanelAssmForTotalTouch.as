package com.faurecia.designWest.omegaSeat {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class OmegaTouchPanelAssmForTotalTouch extends MovieClip {
		//public var touchPanelLeft:TouchPanelAssemblyForTotalTouch;
		//public var touchPanelRight:TouchPanelAssembly;
		//public var backgroundMc:MovieClip;
		
		public function OmegaTouchPanelAssmForTotalTouch() {
			addEventListener(Event.ADDED_TO_STAGE, initMc);
		}
		
		private function initMc(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, initMc);
			//backgroundMc.addEventListener(MouseEvent.CLICK, timeOutResetClick, true);
		}
		
		private function timeOutResetClick(e:MouseEvent):void 
		{
			trace("timeOutResetClick");
		}
	}
	
}
