package com.faurecia.designWest.commonAssets {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class FaureciaLogoMc extends MovieClip {
		
		
		public function FaureciaLogoMc() {
			addEventListener(Event.ADDED_TO_STAGE, initMc);
		}
		
		private function initMc(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, initMc);
			//alpha = .1;
		}
	}
	
}
