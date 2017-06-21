package com.faurecia.designWest.omegaSeat
{
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author jimF
	 */
	public class TouchPanelAssembly extends MovieClip
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
		public var zoneGraphicAssm:SeatZoneAssm;
		public var dPadAssm:ButtonLabelFourWayAssm;
		public var intensityDotAssm:MovieClip;
		public var iconIntensity:MovieClip;
		public var iconPattern:MovieClip;
		public var iconSeatAdjust:MovieClip;
		
		public var intensityBtn:TouchArea;
		public var patternBtn:TouchArea;
		public var massageBtn:TouchArea;
		public var seatAdjustBtn:TouchArea;
		public var dPadUpBtn:TouchArea;
		public var dPadOutBtn:TouchArea;
		public var dPadInBtn:TouchArea;
		public var dPadDownBtn:TouchArea;
		
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
		
		public function TouchPanelAssembly()
		{
			addEventListener(Event.ADDED_TO_STAGE, initMc);
		}
		
		private function initMc(e:Event):void
		{ 
			removeEventListener(Event.ADDED_TO_STAGE, initMc);
			intensityBtn.addEventListener(MouseEvent.CLICK, intensityBtnClicked);
			patternBtn.addEventListener(MouseEvent.CLICK, patternBtnClicked);
			
			massageBtn.addEventListener(MouseEvent.CLICK, massageBtnClicked);
			seatAdjustBtn.addEventListener(MouseEvent.CLICK, seatAdjustBtnClicked);
			
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
			//TweenMax.allTo([patternBtn, patternListAssm, intensityBtn, intensityDotAssm, iconIntensity, iconPattern], _easeOffTime, { autoAlpha: 0 } );
			
		}
			
		
		private function seatAdjustDismissEvent(e:TimerEvent = null):void
		{
			//disable this function for show property
			return;
			
			trace("seatAdjustDismissEvent");
			zoneGraphicAssm.visible = dPadAssm.visible = dPadUpBtn.visible = dPadDownBtn.visible = dPadInBtn.visible = dPadOutBtn.visible = false;
			//TweenMax.allTo([zoneGraphicAssm, dPadAssm, dPadUpBtn, dPadDownBtn, dPadInBtn, dPadOutBtn],  _easeOffTime, { autoAlpha: 0 } );
		}
		
		private function setUpTimerEvents():void
		{
			intensityBtn.addEventListener(MouseEvent.CLICK, resetMassageTimer);
			patternBtn.addEventListener(MouseEvent.CLICK, resetMassageTimer);
			massageBtn.addEventListener(MouseEvent.CLICK, resetMassageTimer);
			
			seatAdjustBtn.addEventListener(MouseEvent.CLICK, resetSeatAdjustTimer);
			dPadUpBtn.addEventListener(MouseEvent.CLICK, resetSeatAdjustTimer);
			dPadDownBtn.addEventListener(MouseEvent.CLICK, resetSeatAdjustTimer);
			dPadInBtn.addEventListener(MouseEvent.CLICK, resetSeatAdjustTimer);
			dPadOutBtn.addEventListener(MouseEvent.CLICK, resetSeatAdjustTimer);
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
		
		private function seatAdjustBtnClicked(e:MouseEvent):void
		{
			//dPadAssm.visible = zoneGraphicAssm.visible = dPadUpBtn.visible = dPadDownBtn.visible = dPadInBtn.visible = dPadOutBtn.visible = ! dPadAssm.visible;
			if (!dPadAssm.visible)
			{
				updateDPad();
				zoneGraphicAssm.modeAllOn();
				dPadAssm.visible = zoneGraphicAssm.visible = true;
				//dPadUpBtn.visible = dPadDownBtn.visible = dPadUpBtn.mouseEnabled;
				//dPadInBtn.visible = dPadOutBtn.visible = dPadInBtn.mouseEnabled;
				setTimeout(function() { zoneGraphicAssm.refreshMode();  updateDPad(zoneGraphicAssm.currentMode);} , 650);
				//TweenMax.allTo([zoneGraphicAssm, dPadAssm, dPadUpBtn, dPadDownBtn, dPadInBtn, dPadOutBtn],  _easeOnTime, { autoAlpha: 1 } );
				return;
			}
			
			zoneGraphicAssm.nextMode();
			updateDPad(zoneGraphicAssm.currentMode);
		}
		
		private function updateDPad(modeId:int = -1):void
		{
			switch (modeId)
			{
				case 0://mode1 
					dPadAssm.dPadMode = ButtonLabelFourWayAssm.TWOWAY_HORZ;
					dPadUpBtn.visible = dPadDownBtn.visible = false;
					dPadUpBtn.mouseEnabled = dPadDownBtn.mouseEnabled = false;
					dPadOutBtn.visible = dPadInBtn.visible = true;
					dPadOutBtn.mouseEnabled = dPadInBtn.mouseEnabled = true;
					break;
				case 1: //mode2
					dPadAssm.dPadMode = ButtonLabelFourWayAssm.TWOWAY_HORZ;
					dPadUpBtn.visible = dPadDownBtn.visible = false;
					dPadUpBtn.mouseEnabled = dPadDownBtn.mouseEnabled = false;
					dPadOutBtn.visible = dPadInBtn.visible = true;
					dPadOutBtn.mouseEnabled = dPadInBtn.mouseEnabled = true;
					break;
				case 2: //mode3
					dPadAssm.dPadMode = ButtonLabelFourWayAssm.FOURWAY;
					dPadUpBtn.visible = dPadDownBtn.visible = true;
					dPadUpBtn.mouseEnabled = dPadDownBtn.mouseEnabled = true;
					dPadOutBtn.visible = dPadInBtn.visible = true;
					dPadOutBtn.mouseEnabled = dPadInBtn.mouseEnabled = true;
					break;
				case 3://mode4 
					dPadAssm.dPadMode = ButtonLabelFourWayAssm.FOURWAY;
					dPadUpBtn.visible = dPadDownBtn.visible = true;
					dPadUpBtn.mouseEnabled = dPadDownBtn.mouseEnabled = true;
					dPadOutBtn.visible = dPadInBtn.visible = true;
					dPadOutBtn.mouseEnabled = dPadInBtn.mouseEnabled = true;
					break;	
				case 4://mode5 
					dPadAssm.dPadMode = ButtonLabelFourWayAssm.FOURWAY;
					dPadUpBtn.visible = dPadDownBtn.visible = true;
					dPadUpBtn.mouseEnabled = dPadDownBtn.mouseEnabled = true;
					dPadOutBtn.visible = dPadInBtn.visible = true;
					dPadOutBtn.mouseEnabled = dPadInBtn.mouseEnabled = true;
					break;	
				case 5://mode6 
					dPadAssm.dPadMode = ButtonLabelFourWayAssm.FOURWAY;
					dPadUpBtn.visible = dPadDownBtn.visible = true;
					dPadUpBtn.mouseEnabled = dPadDownBtn.mouseEnabled = true;
					dPadOutBtn.visible = dPadInBtn.visible = true;
					dPadOutBtn.mouseEnabled = dPadInBtn.mouseEnabled = true;
					break;	
				case 6://mode7 
					dPadAssm.dPadMode = ButtonLabelFourWayAssm.FOURWAY;
					dPadUpBtn.visible = dPadDownBtn.visible = true;
					dPadUpBtn.mouseEnabled = dPadDownBtn.mouseEnabled = true;
					dPadOutBtn.visible = dPadInBtn.visible = true;
					dPadOutBtn.mouseEnabled = dPadInBtn.mouseEnabled = true;
					break;	
				case -1: 
					dPadAssm.dPadMode = ButtonLabelFourWayAssm.FOURWAY;
					dPadUpBtn.visible = dPadDownBtn.visible = true;
					dPadUpBtn.mouseEnabled = dPadDownBtn.mouseEnabled = false;
					dPadOutBtn.visible = dPadInBtn.visible = true;
					dPadOutBtn.mouseEnabled = dPadInBtn.mouseEnabled = false;
					break;
			}
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
			switch (zoneGraphicAssm.currentMode)
			{
				case 0: 
					dPadAssm.dPadMode = ButtonLabelFourWayAssm.TWOWAY_HORZ;
					//dPadUpBtn.visible = dPadDownBtn.visible = false;
					dPadUpBtn.mouseEnabled = dPadDownBtn.mouseEnabled = false;
					//dPadOutBtn.visible = dPadInBtn.visible = true;
					dPadOutBtn.mouseEnabled = dPadInBtn.mouseEnabled = true;
					break;
				case 1: 
					dPadAssm.dPadMode = ButtonLabelFourWayAssm.TWOWAY_HORZ;
					//dPadUpBtn.visible = dPadDownBtn.visible = false;
					dPadUpBtn.mouseEnabled = dPadDownBtn.mouseEnabled = false;
					//dPadOutBtn.visible = dPadInBtn.visible = true;
					dPadOutBtn.mouseEnabled = dPadInBtn.mouseEnabled = true;
					break;
				case 2: 
					dPadAssm.dPadMode = ButtonLabelFourWayAssm.FOURWAY;
					//dPadUpBtn.visible = dPadDownBtn.visible = true;
					dPadUpBtn.mouseEnabled = dPadDownBtn.mouseEnabled = true;
					//dPadOutBtn.visible = dPadInBtn.visible = true;
					dPadOutBtn.mouseEnabled = dPadInBtn.mouseEnabled = true;
					break;
				case 3: 
					dPadAssm.dPadMode = ButtonLabelFourWayAssm.TWOWAY_VERT;
					//dPadUpBtn.visible = dPadDownBtn.visible = true;
					dPadUpBtn.mouseEnabled = dPadDownBtn.mouseEnabled = true;
					//dPadOutBtn.visible = dPadInBtn.visible = false;
					dPadOutBtn.mouseEnabled = dPadInBtn.mouseEnabled = false;
					break;
			}
		}
	}

}