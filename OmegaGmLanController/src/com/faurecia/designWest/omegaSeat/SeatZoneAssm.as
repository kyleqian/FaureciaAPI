package com.faurecia.designWest.omegaSeat {
	
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.events.DataEvent;
	import flash.events.Event;
	
	
	public class SeatZoneAssm extends MovieClip {
		public var lowerZone:MovieClip;
		public var midZone:MovieClip;
		public var upperZone:MovieClip;
		
		private var _offVal:Number = .1;
		
		private var _currentMode:int = 0;
		//private var _totalModes:int = 4;
		
		private var modeAry:Array;
		
		private var _easeOffTime:Number = .25;
		private var _easeOnTime:Number = .15;
		
		//private var _easeOffTime:Number = 0;
		//private var _easeOnTime:Number = 0;
		
		public static const MODE_CHANGED:String = "modeChanged";
		public static const FOUR_WAY_MODE:String = "fourWayMode";
		
		public function SeatZoneAssm() {
			addEventListener(Event.ADDED_TO_STAGE, initMc);
		}
		
		private function initMc(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, initMc);	
			//modeAry = [mode1, mode2, mode3, mode4, mode5, mode6, mode7];
			modeAry = [mode1, mode2, mode3, mode4, mode5];
			if (Object(root).offVal) {
				_offVal = Object(root).offVal;
			}
			_currentMode = modeAry.length - 1;
			nextMode();
		}
		
		public function mode1():void {
			//upperZone.alpha = 1;
			//midZone.alpha = _offVal;
			//lowerZone.alpha = _offVal;
			
			TweenMax.to(upperZone, _easeOnTime, { alpha: 1 } );
			TweenMax.to(midZone, _easeOffTime, { alpha: _offVal } );
			TweenMax.to(lowerZone, _easeOffTime, { alpha: _offVal } );
			
			stage.dispatchEvent(new DataEvent(FOUR_WAY_MODE, false, false, "mode1"));
		}
		
		
		public function mode2():void {
			//upperZone.alpha = 1;
			//midZone.alpha = 1;
			//lowerZone.alpha = _offVal;
			
			TweenMax.to(upperZone, _easeOnTime, { alpha: 1 } );
			TweenMax.to(midZone,  _easeOnTime, { alpha: 1 } );
			TweenMax.to(lowerZone, _easeOffTime, { alpha: _offVal } );
			stage.dispatchEvent(new DataEvent(FOUR_WAY_MODE, false, false, "mode2"));
		}
		
		
		public function mode3():void {
			//upperZone.alpha = _offVal;
			//midZone.alpha = 1;
			//lowerZone.alpha = _offVal;
			
			TweenMax.to(upperZone,  _easeOffTime, { alpha: _offVal } );
			TweenMax.to(midZone,  _easeOnTime, { alpha: 1 } );
			TweenMax.to(lowerZone, _easeOffTime, { alpha: _offVal } );
			stage.dispatchEvent(new DataEvent(FOUR_WAY_MODE, false, false, "mode3"));
		}
		
		
		public function mode4():void {
			//upperZone.alpha = _offVal;
			//midZone.alpha = _offVal;
			//lowerZone.alpha = 1;
			
			TweenMax.to(upperZone,  _easeOffTime, { alpha: 1 } );
			TweenMax.to(midZone,  _easeOffTime, { alpha: 1 } );
			TweenMax.to(lowerZone,   _easeOnTime, { alpha: 1 } );
			stage.dispatchEvent(new DataEvent(FOUR_WAY_MODE, false, false, "mode4"));
			
		}
		
		public function mode5():void {
			//upperZone.alpha = _offVal;
			//midZone.alpha = _offVal;
			//lowerZone.alpha = 1;
			
			TweenMax.to(upperZone,  _easeOffTime, { alpha: _offVal } );
			TweenMax.to(midZone,  _easeOffTime, { alpha: _offVal } );
			TweenMax.to(lowerZone,   _easeOnTime, { alpha: 1 } );
			stage.dispatchEvent(new DataEvent(FOUR_WAY_MODE, false, false, "mode5"));
			
		}
		
		public function mode6():void {
			//upperZone.alpha = _offVal;
			//midZone.alpha = _offVal;
			//lowerZone.alpha = 1;
			
			TweenMax.to(upperZone,  _easeOffTime, { alpha: 1 } );
			TweenMax.to(midZone,  _easeOffTime, { alpha: 1 } );
			TweenMax.to(lowerZone,   _easeOnTime, { alpha: 1 } );
			stage.dispatchEvent(new DataEvent(FOUR_WAY_MODE, false, false, "mode6"));
			
		}
		
		public function mode7():void {
			//upperZone.alpha = _offVal;
			//midZone.alpha = _offVal;
			//lowerZone.alpha = 1;
			
			TweenMax.to(upperZone,  _easeOffTime, { alpha: 1 } );
			TweenMax.to(midZone,  _easeOffTime, { alpha: 1 } );
			TweenMax.to(lowerZone,   _easeOnTime, { alpha: 1 } );
			stage.dispatchEvent(new DataEvent(FOUR_WAY_MODE, false, false, "mode7"));
			
		}
		
		public function modeAllOn():void {
			//upperZone.alpha = _offVal;
			//midZone.alpha = _offVal;
			//lowerZone.alpha = 1;
			
			TweenMax.to(upperZone,  _easeOffTime, { alpha: 1 } );
			TweenMax.to(midZone,  _easeOffTime, { alpha: 1 } );
			TweenMax.to(lowerZone,   _easeOnTime, { alpha: 1 } );
			
			stage.dispatchEvent(new DataEvent(FOUR_WAY_MODE, false, false, "modeAllOn"));
			
		}
		public function refreshMode():void {
			modeAry[_currentMode]();
		}
		
		public function nextMode():void {
			_currentMode = (_currentMode + 1) % modeAry.length;
			modeAry[_currentMode]();
			
			//dispatchEvent(new Event(MODE_CHANGED));			
		}
		
		public function get currentMode():int 
		{
			return _currentMode;
		}
		
	}
	
}
