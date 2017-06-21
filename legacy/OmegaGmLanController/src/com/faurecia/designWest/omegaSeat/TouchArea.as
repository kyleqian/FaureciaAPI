package com.faurecia.designWest.omegaSeat 
{
	import flash.display.MovieClip;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	
	/**
	 * ...
	 * @author jimF
	 */
	public class TouchArea extends MovieClip 
	{
		public static const RESET_TIMER_EVENT = "resetTimerEvent";
		
		private var _pressedAlpha:Number = .6;
		private var _releasedAlpha:Number = 0;
		
		public static const TOGGLE_TOUCH_AREAS:String = "toggleTouchAreas";
		
		public var pressStr:String = "";
		public var releaseStr:String = "";
		public var clickStr:String = "";
		
		public static const PRESSED:String = "buttonPressed";
		public static const RELEASED:String = "buttonReleased";
		public static const CLICKED:String = "buttonClicked";
		
		
		
		public function TouchArea() 
		{
			addEventListener(Event.ADDED_TO_STAGE, initMc);			
		}
		
		private function initMc(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, initMc);
			addEventListener(MouseEvent.MOUSE_DOWN, targetPressedEvent);
			addEventListener(MouseEvent.CLICK, buttonClickedEvent);
			//addEventListener(MouseEvent.CLICK, timeoutResetClick);
			stage.addEventListener(TOGGLE_TOUCH_AREAS , toggleTouchAreaEvents);
			buttonMode = true;
			alpha = _releasedAlpha;
		}
		
		private function buttonClickedEvent(e:MouseEvent):void 
		{
			if (clickStr != "") {
				stage.dispatchEvent(new DataEvent(CLICKED, false, false, clickStr));
			}
		}
		
		private function toggleTouchAreaEvents(e:Event):void 
		{
			//trace("toggleTouchAreaEvents");		
			if (_releasedAlpha == 0) {
				_pressedAlpha = .6;
				_releasedAlpha = .4;				
				
			}else {
				_pressedAlpha = 0;
				_releasedAlpha = 0;				
			}
			
			alpha = _releasedAlpha;
		}
		
		private function timeoutResetClick(e:MouseEvent):void 
		{
			Object(this).parent.dispatchEvent(new Event(RESET_TIMER_EVENT));
		}
		
		private function targetPressedEvent(e:MouseEvent):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, targetReleasedEvent);
			alpha = _pressedAlpha;
			if (pressStr != "") {
				stage.dispatchEvent(new DataEvent(PRESSED, false, false, pressStr));
			}
		}
		
		private function targetReleasedEvent(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, targetReleasedEvent);
			alpha = _releasedAlpha;
			if (releaseStr != "") {
				stage.dispatchEvent(new DataEvent(RELEASED, false, false, releaseStr));
			}
		}
		
		public function get releasedAlpha():Number 
		{
			return _releasedAlpha;
		}
		
		public function set releasedAlpha(value:Number):void 
		{
			_releasedAlpha = value;
			alpha = _releasedAlpha;
		}
		
		public function get pressedAlpha():Number 
		{
			return _pressedAlpha;
		}
		
		public function set pressedAlpha(value:Number):void 
		{
			_pressedAlpha = value;
			
		}
		
	}

}