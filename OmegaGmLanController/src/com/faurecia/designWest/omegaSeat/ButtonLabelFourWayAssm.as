package com.faurecia.designWest.omegaSeat {
	
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class ButtonLabelFourWayAssm extends MovieClip {
		public var dPadVertA:MovieClip;
		public var dPadVertB:MovieClip;
		public var dPadHorzA:MovieClip;
		public var dPadHorzB:MovieClip;
		
		public static const FOURWAY:int = 0;
		public static const TWOWAY_VERT:int = 1;
		public static const TWOWAY_HORZ:int = 2;
		public static const ALL_ON:int = -1;
		
		private var _dPadMode:int = 0;
		
		private var _easeOffTime:Number = 0;
		private var _easeOnTime:Number = 0;
		
		
		public function ButtonLabelFourWayAssm() {
			addEventListener(Event.ADDED_TO_STAGE, initMc);
		}
		
		private function initMc(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, initMc);			
			
			//dPadMode = TWOWAY_VERT;
		}
		
		public function get dPadMode():int 
		{
			return _dPadMode;
		}
		
		public function set dPadMode(value:int):void 
		{
			_dPadMode = value;
			
			//dPadVertA.alpha = dPadVertB.alpha = ((_dPadMode == 0) || (_dPadMode == 1)) ? 1 : 0;
			var offOrOn:Boolean = ((_dPadMode == 0) || (_dPadMode == 1));
			TweenMax.allTo([dPadVertA, dPadVertB], offOrOn ?  _easeOnTime : _easeOffTime, { alpha : offOrOn ? 1:0 } );
			
			//dPadHorzA.alpha = dPadHorzB.alpha = ((_dPadMode == 0) || (_dPadMode == 2)) ? 1 : 0;
			offOrOn = ((_dPadMode == 0) || (_dPadMode == 2));
			TweenMax.allTo([dPadHorzA, dPadHorzB], offOrOn ?  _easeOnTime : _easeOffTime, { alpha : offOrOn ? 1:0 } );
			
		}
	}
	
}
