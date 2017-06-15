package com.faurecia.designWest.omegaSeat
{
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author jimF
	 */
	public class TouchPanelAssemblyForTotalTouch extends MovieClip
	{
		public var hapticIconLeft:MovieClip;
		public var hapticIconLRight:MovieClip;
		public var hapticSelectBtn:TouchArea;
		public var hapticIntensityBtn:TouchArea;
		public var hapticAlertBtn:TouchArea;
		public var hapticLeft:Boolean = true;
		
		public var iconSelect:MovieClip;
		public var iconHapticIntensity:MovieClip;
		public var hapticIntensityDotAssm:MassageIntensityAssm;		
		
		private var massageDeployed:Boolean = true;
		private var seatAdjustDeployed:Boolean = true;
		
		public var patternListAssm:MassageModeAssm;		
		
		public var intensityDotAssm:MovieClip;
		public var iconIntensity:MovieClip;
		public var iconPattern:MovieClip;
		public var iconSeatAdjust:MovieClip;
		
		public var intensityBtn:TouchArea;
		public var patternBtn:TouchArea;
		public var massageBtn:TouchArea;
		//public var seatAdjustBtn:TouchArea;
		
		public var zoneGraphicAssmMode1:SeatZoneAssm;
		public var zoneGraphicAssmMode2:SeatZoneAssm;
		public var zoneGraphicAssmMode3:SeatZoneAssm;
		public var zoneGraphicAssmMode4:SeatZoneAssm;
		
		public var dPadAssmMode1:ButtonLabelFourWayAssm;
		public var dPadAssmMode2:ButtonLabelFourWayAssm;
		public var dPadAssmMode3:ButtonLabelFourWayAssm;
		public var dPadAssmMode4:ButtonLabelFourWayAssm;
		
		public var dPadUpBtnMode1:TouchArea;
		public var dPadOutBtnMode1:TouchArea;
		public var dPadInBtnMode1:TouchArea;
		public var dPadDownBtnMode1:TouchArea;
		
		public var dPadUpBtnMode2:TouchArea;
		public var dPadOutBtnMode2:TouchArea;
		public var dPadInBtnMode2:TouchArea;
		public var dPadDownBtnMode2:TouchArea;
		
		public var dPadUpBtnMode3:TouchArea;
		public var dPadOutBtnMode3:TouchArea;
		public var dPadInBtnMode3:TouchArea;
		public var dPadDownBtnMode3:TouchArea;
		
		public var dPadUpBtnMode4:TouchArea;
		public var dPadOutBtnMode4:TouchArea;
		public var dPadInBtnMode4:TouchArea;
		public var dPadDownBtnMode4:TouchArea;
		
		public var controlMode1Txt:TextField;
		public var controlMode2Txt:TextField;
		public var controlMode3Txt:TextField;
		public var controlMode4Txt:TextField;
		
		private var massageTimer:Timer;
		private var seatAdjustTimer:Timer;
		private var timeOutDelay:Number = 10 * 1000;
		
		//private var _easeOffTime:Number = .25;
		//private var _easeOnTime:Number = .15;
		private var _easeOffTime:Number = .15;
		private var _easeOnTime:Number = .25;
		public var hapticControlsVisible:Boolean = false;
		
		public static const MASSAGE_ON:String = "massageOn";
		public static const MASSAGE_OFF:String = "massageOff";
		public static const HAPTIC_SETTINGS_CHANGED:String = "hapticSettingChanged";
		
		
		public var driverSelTxt:TextField;
		public var passSelTxt:TextField;
		public var driverSelBtn:TouchArea;
		public var passSelBtn:TouchArea;
		
		//private var 
		
		
		public function TouchPanelAssemblyForTotalTouch()
		{
			addEventListener(Event.ADDED_TO_STAGE, initMc);
		}
		
		private function initMc(e:Event):void
		{ 
			removeEventListener(Event.ADDED_TO_STAGE, initMc);
			driverSelTxt.mouseEnabled = false;
			passSelTxt.mouseEnabled = false;
			passSelTxt.textColor = 0x444444;
			//driverSelTxt.text = "howdy";
			driverSelBtn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent){driverSelTxt.textColor = 0xffffff; passSelTxt.textColor = 0x444444; stage.dispatchEvent(new DataEvent("UPDATE_TARGET_SEAT", false, false, "driver")); });
			passSelBtn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent){driverSelTxt.textColor = 0x444444; passSelTxt.textColor = 0xffffff; stage.dispatchEvent(new DataEvent("UPDATE_TARGET_SEAT", false, false, "passenger"));});
		
			
			
			
			intensityBtn.addEventListener(MouseEvent.CLICK, intensityBtnClicked);
			patternBtn.addEventListener(MouseEvent.CLICK, patternBtnClicked);
			
			massageBtn.addEventListener(MouseEvent.CLICK, massageBtnClicked);
			//seatAdjustBtn.addEventListener(MouseEvent.CLICK, seatAdjustBtnClicked);
			
			addEventListener(TouchArea.RESET_TIMER_EVENT, resetTimerEvent);
			
			massageTimer = new Timer(timeOutDelay, 1);
			massageTimer.addEventListener(TimerEvent.TIMER, massageDismissEvent);
			massageDismissEvent();
			
			seatAdjustTimer = new Timer(timeOutDelay, 1);
			seatAdjustTimer.addEventListener(TimerEvent.TIMER, seatAdjustDismissEvent);
			//seatAdjustDismissEvent();
			
			toggleHapticSide();
			hapticSelectBtn.addEventListener(MouseEvent.CLICK, toggleHapticSide);
			hapticIntensityBtn.addEventListener(MouseEvent.CLICK, nextHapticIntensityEvent);
			hapticAlertBtn.addEventListener(MouseEvent.CLICK, toggleHapticStateEvent);
			toggleHapticStateEvent();
			
			setUpTimerEvents();
			
			//updateDPad();
			startUpSettings();
			powerOff();
		}
		
		private function toggleHapticStateEvent(e:MouseEvent = null):void 
		{
			
			hapticIconLeft.visible = hapticIconRight.visible = hapticIntensityBtn.visible = hapticSelectBtn.visible = iconSelect.visible = iconHapticIntensity.visible = hapticIntensityDotAssm.visible = ! hapticIconLeft.visible;
			hapticControlsVisible = hapticIconLeft.visible;
			stage.dispatchEvent(new Event(HAPTIC_SETTINGS_CHANGED));
		}
		
		private function setHapticLevel():void 
		{
			
		}
		
		private function nextHapticIntensityEvent(e:MouseEvent):void 
		{
			hapticIntensityDotAssm.nextIntensity();
		}
		
		private function toggleHapticSide(e:MouseEvent = null):void 
		{
			hapticLeft = !hapticLeft;
			trace("toggleHapticSide");
			//hapticIconLeft.alpha = .2;
			
			if (hapticLeft == true) {//colorMatrixFilter: { colorize: _pressTint, amount:.3 }} );
				TweenMax.to(hapticIconRight, 0, { colorMatrixFilter: { colorize: 0x444444, amount: 0 }} );
				TweenMax.to(hapticIconLeft, 0, { colorMatrixFilter: { colorize: 0x444444, amount: .7 }} );
			}else {
				TweenMax.to(hapticIconRight, 0, { colorMatrixFilter: { colorize: 0x444444, amount: .7 }} );
				TweenMax.to(hapticIconLeft, 0, { colorMatrixFilter: { colorize: 0x444444, amount: 0 }} );
			}
			
			stage.dispatchEvent(new Event(HAPTIC_SETTINGS_CHANGED));
		}
		
		public function massageDismissEvent(e:TimerEvent = null):void
		{
			trace("massageDismissEvent");
			massageTimer.stop();
			patternBtn.visible = patternListAssm.visible = intensityBtn.visible = intensityDotAssm.visible = iconIntensity.visible = iconPattern.visible = false;
		}
			
		
		private function seatAdjustDismissEvent(e:TimerEvent = null):void
		{
			//disable this function for show property
			return;			
			trace("seatAdjustDismissEvent");
		}
		
		private function setUpTimerEvents():void
		{
			intensityBtn.addEventListener(MouseEvent.CLICK, resetMassageTimer);
			patternBtn.addEventListener(MouseEvent.CLICK, resetMassageTimer);
			massageBtn.addEventListener(MouseEvent.CLICK, resetMassageTimer);
		}
		
		private function resetSeatAdjustTimer(e:MouseEvent):void
		{
			//trace("resetSeatAdjustTimer");
			seatAdjustTimer.reset();
			seatAdjustTimer.start();
		}
		
		private function resetMassageTimer(e:MouseEvent):void
		{
			//trace("resetMassageTimer");
			/*massageTimer.reset();
			massageTimer.start();*/
		}
		
		private function powerOn():void
		{
		
		}
		
		private function powerOff():void
		{
		
		}
		
		private function resetTimerEvent(e:Event):void
		{
			switch (e.currentTarget)
			{
				case patternBtn: 
					trace("patternBtn timer reset");
					break;
			}
			trace("reset timer event");
		}
						
		private function massageBtnClicked(e:MouseEvent):void
		{
			if (patternBtn.visible)
			{
				massageDismissEvent();
				stage.dispatchEvent(new Event(MASSAGE_OFF));
				return;
			}
			patternBtn.visible = patternListAssm.visible = intensityBtn.visible = intensityDotAssm.visible = iconIntensity.visible = iconPattern.visible = true;
			//TweenMax.allTo([patternBtn, patternListAssm, intensityBtn, intensityDotAssm, iconIntensity, iconPattern], _easeOnTime, { autoAlpha: 1 } );
			patternListAssm.wakeUp();
			//massageTimer.start();
			stage.dispatchEvent(new Event(MASSAGE_ON));
		
		}
		
		private function patternBtnClicked(e:MouseEvent):void
		{
			patternListAssm.changeMode();
		}
		
		private function intensityBtnClicked(e:MouseEvent):void
		{
			intensityDotAssm.nextIntensity();
		}
		
		private function startUpSettings()
		{
			dPadAssmMode1.dPadMode = ButtonLabelFourWayAssm.TWOWAY_HORZ;
			dPadUpBtnMode1.mouseEnabled = dPadDownBtnMode1.mouseEnabled = false;
			dPadUpBtnMode1.visible = dPadDownBtnMode1.visible = false;
			dPadOutBtnMode1.mouseEnabled = dPadInBtnMode1.mouseEnabled = true;		

			dPadAssmMode2.dPadMode = ButtonLabelFourWayAssm.TWOWAY_HORZ;
			dPadUpBtnMode2.mouseEnabled = dPadDownBtnMode2.mouseEnabled = false;
			dPadUpBtnMode2.visible= dPadDownBtnMode2.visible = false;
			dPadOutBtnMode2.mouseEnabled = dPadInBtnMode2.mouseEnabled = true;
					
			dPadAssmMode3.dPadMode = ButtonLabelFourWayAssm.FOURWAY;
			dPadUpBtnMode3.mouseEnabled = dPadDownBtnMode3.mouseEnabled = true;
			dPadOutBtnMode3.mouseEnabled = dPadInBtnMode3.mouseEnabled = true;

			dPadAssmMode4.dPadMode = ButtonLabelFourWayAssm.FOURWAY;
			dPadUpBtnMode4.mouseEnabled = dPadDownBtnMode4.mouseEnabled = true;
			dPadOutBtnMode4.mouseEnabled = dPadInBtnMode4.mouseEnabled = true;
			
			dPadUpBtnMode1.releasedAlpha = dPadOutBtnMode1.releasedAlpha = dPadInBtnMode1.releasedAlpha = dPadDownBtnMode1.releasedAlpha = 
			dPadUpBtnMode2.releasedAlpha = dPadOutBtnMode2.releasedAlpha = dPadInBtnMode2.releasedAlpha = dPadDownBtnMode2.releasedAlpha = 
			dPadUpBtnMode3.releasedAlpha = dPadOutBtnMode3.releasedAlpha = dPadInBtnMode3.releasedAlpha = dPadDownBtnMode3.releasedAlpha =		
			dPadUpBtnMode4.releasedAlpha = dPadOutBtnMode4.releasedAlpha = dPadInBtnMode4.releasedAlpha = dPadDownBtnMode4.releasedAlpha = .15;		
		}
	}

}