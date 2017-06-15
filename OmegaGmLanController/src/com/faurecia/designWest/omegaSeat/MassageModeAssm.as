package com.faurecia.designWest.omegaSeat
{
	
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.events.DataEvent;
	import flash.events.Event;
	
	public class MassageModeAssm extends MovieClip
	{
		public var shoulder:MovieClip;
		public var lumbar:MovieClip;
		public var stretch:MovieClip;
		public var knead:MovieClip;
		public var roll:MovieClip;
		
		private var currentMode:int = 0;
		
		private var modeAry:Array;
		
		private var offVal:Number = .1;
		
		private var wakeUpTime:Number = .65;
		
		//private var _easeOffTime:Number = .25;
		//private var _easeOnTime:Number = .15;
		private var _easeOffTime:Number = 0;
		private var _easeOnTime:Number = 0;
		
		public static const MASSAGE_MODE_CHANGE:String = "massageModeChange";
		
		public function MassageModeAssm()
		{
			addEventListener(Event.ADDED_TO_STAGE, initMc);
		}
		
		private function initMc(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initMc);
			if (Object(root).offVal) {
				offVal = Object(root).offVal;
			}
			modeAry = [roll, knead, stretch, lumbar, shoulder];
			changeMode();
			
			stage.addEventListener("UPDATE_DIM_VALUE", updateOffValue);
		
		}
		
		private function updateOffValue(e:Event):void 
		{
			trace("updateOffValue");
			if (Object(root).offVal != undefined) {
				offVal = Object(root).offVal;
			}
			trace("updateOffValue   offVal = " + offVal + "   " + Object(root).offVal);
			setModeAlpha(); 
		}
		
		public function changeMode() {
			currentMode = (currentMode + 1) % modeAry.length;
			stage.dispatchEvent(new DataEvent(MASSAGE_MODE_CHANGE, false, false, currentMode.toString()));
			setModeAlpha();	
		}
		
		private function setModeAlpha():void {
			for (var i:int = 0; i < modeAry.length; i++) {
					//modeAry[i].alpha = (currentMode == i)? 1: offVal;
					TweenMax.to(modeAry[i], (currentMode == i)? _easeOnTime: _easeOffTime, { alpha: (currentMode == i)? 1: offVal } );
			}
		}
		
		public function wakeUp():void {
			for (var i:int = 0; i < modeAry.length; i++) {
					//modeAry[i].alpha = (currentMode == i)? 1: offVal;
					TweenMax.fromTo(modeAry[i], _easeOnTime, { alpha: 0 }, { alpha: 1 });
			}
			
			TweenMax.delayedCall(wakeUpTime, setModeAlpha);			
		}
	}

}
