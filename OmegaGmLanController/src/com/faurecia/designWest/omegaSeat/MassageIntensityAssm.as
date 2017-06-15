package com.faurecia.designWest.omegaSeat
{
	
	import flash.display.MovieClip;
	import flash.events.DataEvent;
	import flash.events.Event;
	
	public class MassageIntensityAssm extends MovieClip
	{
		public var dotA:MovieClip;
		public var dotB:MovieClip;
		public var dotC:MovieClip;
		
		private var offVal:Number = .1;
		
		private var currentLevel:int = 0;
		
		public static const MASSAGE_INTESITY_CHANGE:String = "massageIntensityChange";
		public static const HAPTIC_INTESITY_CHANGE:String = "hapticIntensityChange";
		
		public var eventName:String = "massageIntensityChange";
		
		public function MassageIntensityAssm()
		{
			addEventListener(Event.ADDED_TO_STAGE, initMe);
		}
		
		private function initMe(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initMe);
			if (Object(root).offVal != undefined) {
				offVal = Object(root).offVal;
			}
			dotA.alpha = dotB.alpha = dotC.alpha = offVal;
			nextIntensity();
			
			stage.addEventListener("UPDATE_DIM_VALUE", updateOffValue);
		}
		
		private function updateOffValue(e:Event):void 
		{
			//trace("updateOffValue");
			if (Object(root).offVal != undefined) {
				offVal = Object(root).offVal;
			}
			//trace("updateOffValue   offVal = " + offVal + "   " + Object(root).offVal);
			dotA.alpha = (currentLevel < 1) ? offVal : 1;
			dotB.alpha = (currentLevel < 2) ? offVal : 1;
			dotC.alpha = (currentLevel < 3) ? offVal : 1;
			
			
		}
		
		public function nextIntensity():void
		{			
			currentLevel = (currentLevel ) % 3 + 1;
			dotA.alpha = (currentLevel < 1) ? offVal : 1;
			dotB.alpha = (currentLevel < 2) ? offVal : 1;
			dotC.alpha = (currentLevel < 3) ? offVal : 1;
			
			stage.dispatchEvent(new DataEvent(eventName,false,false, currentLevel.toString()));
		
		}
	}

}
