package com.faurecia.westworks.omega.gmLanController 
{
	import com.faurecia.designWest.omegaSeat.MassageIntensityAssm;
	import com.faurecia.designWest.omegaSeat.MassageModeAssm;
	import com.faurecia.designWest.omegaSeat.SeatZoneAssm;
	import com.faurecia.designWest.omegaSeat.SettingsPanelMc;
	import com.faurecia.designWest.omegaSeat.TouchArea;
	import com.faurecia.designWest.omegaSeat.TouchPanelAssembly;
	import com.faurecia.designWest.omegaSeat.TouchPanelAssemblyForTotalTouch;
	import flash.display.MovieClip;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.text.TextField;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author jimF
	 */
	public class OmegaControllerForTotalTouch extends MovieClip 
	{
		public var touchPanel:TouchPanelAssemblyForTotalTouch;
		//public var connectionPanel:OmegaSeatControlWithArduino;
		public var connectionPanel:OmegaObdSettingsPanel;
		public var controlModeTxt:TextField;		
		
		public var messagePanelTxt:TextField;
		
		public var offVal:Number = .25;		
		
		
		public function OmegaControllerForTotalTouch() 
		{
			trace("OmegaControllerForTotalTouch");
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			
			//setUpBtns();
			setUpButtonModes();
			
			
			stage.addEventListener(ButtonAssm.PRESSED, controlPressedEvent);
			stage.addEventListener(ButtonAssm.RELEASED, controlPressedEvent);
			
			//stage.addEventListener(SeatZoneAssm.FOUR_WAY_MODE, updateButtonModeEvent);
			stage.addEventListener(MassageModeAssm.MASSAGE_MODE_CHANGE, updateMassageModeEvent);
			
			stage.addEventListener(MassageIntensityAssm.MASSAGE_INTESITY_CHANGE, updateMassageIntensityEvent);
			touchPanel.hapticIntensityDotAssm.eventName = MassageIntensityAssm.HAPTIC_INTESITY_CHANGE;
			stage.addEventListener(MassageIntensityAssm.HAPTIC_INTESITY_CHANGE, updateHapticIntensityEvent);
			
			stage.addEventListener(TouchPanelAssembly.HAPTIC_SETTINGS_CHANGED, updateHapticStateEvent);
			
			stage.addEventListener(TouchPanelAssembly.MASSAGE_OFF, massageOffEvent);
			stage.addEventListener(TouchPanelAssembly.MASSAGE_ON, massageOnEvent);
			//stage.addEventListener(OmegaSeatControlWithArduino.MASSAGE_OFF, dismissMassageControlsEvent);
			stage.addEventListener(OmegaObdSettingsPanel.MASSAGE_OFF, dismissMassageControlsEvent);
						
			controlModeTxt.text = "";
			controlModeTxt.visible = false;
		}
		
		private function updateHapticStateEvent(e:Event):void 
		{
			connectionPanel.currentHapticSide = touchPanel.hapticLeft;
			if (touchPanel.hapticControlsVisible) {
				connectionPanel.updateHapticState();
			}else {
				connectionPanel.turnOffHaptic();
			}
			
		}
		
		private function updateHapticIntensityEvent(e:DataEvent):void 
		{
			switch(e.data) {
			case "0":
				connectionPanel.currentHapticIntensity = OmegaControlStrings.HAPTIC_INTENSITY_LOW;
				break;
			
			case "1":
				connectionPanel.currentHapticIntensity = OmegaControlStrings.HAPTIC_INTENSITY_MEDIUM;
				break;
			
			case "2":
				connectionPanel.currentHapticIntensity = OmegaControlStrings.HAPTIC_INTENSITY_HIGH;
				break;		
			}
			
			connectionPanel.updateHapticState();
		}
				
		private function dismissMassageControlsEvent(e:Event):void 
		{
			touchPanel.massageDismissEvent();
		}
		
		private function massageOnEvent(e:Event):void 
		{
			connectionPanel.updateMassageState();
		}
		
		private function massageOffEvent(e:Event):void 
		{
			connectionPanel.turnOffMassage();
		}
		
		private function updateMassageIntensityEvent(e:DataEvent):void 
		{
			switch(e.data) {
			case "0":
				connectionPanel.currentMassageIntensity = OmegaControlStrings.MASSAGE_INTENSITY_1;
				break;
			
			case "1":
				connectionPanel.currentMassageIntensity = OmegaControlStrings.MASSAGE_INTENSITY_2;
				break;
			
			case "2":
				connectionPanel.currentMassageIntensity = OmegaControlStrings.MASSAGE_INTENSITY_3;
				break;		
			}
			
			connectionPanel.updateMassageState();
			
		}
		
		private function updateMassageModeEvent(e:DataEvent):void 
		{
			switch(e.data) {
			case "0":
				connectionPanel.currentMassageProgram = OmegaControlStrings.MASSAGE_TYPE_1;
				break;
			
			case "1":
				connectionPanel.currentMassageProgram = OmegaControlStrings.MASSAGE_TYPE_2;
				break;
			
			case "2":
				connectionPanel.currentMassageProgram = OmegaControlStrings.MASSAGE_TYPE_5;
				break;
			
			case "3":
				connectionPanel.currentMassageProgram = OmegaControlStrings.MASSAGE_TYPE_6;
				break;
			
			case "4":
				connectionPanel.currentMassageProgram = OmegaControlStrings.MASSAGE_TYPE_7;
				break;
			}
			
			connectionPanel.updateMassageState();
		}
		
		private function setUpButtonModes():void 
		{
			touchPanel.dPadUpBtnMode1.pressStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			touchPanel.dPadUpBtnMode1.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
				
			touchPanel.dPadDownBtnMode1.pressStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			touchPanel.dPadDownBtnMode1.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			
			touchPanel.dPadInBtnMode1.pressStr = OmegaControlStrings.HEADREST_REARWARD
			touchPanel.dPadInBtnMode1.releaseStr = OmegaControlStrings.MBM_CONTROLS_OFF;
			
			touchPanel.dPadOutBtnMode1.pressStr = OmegaControlStrings.HEADREST_FORWARD;
			touchPanel.dPadOutBtnMode1.releaseStr = OmegaControlStrings.MBM_CONTROLS_OFF;
			touchPanel.controlMode1Txt.text = "Slouch";
			touchPanel.zoneGraphicAssmMode1.mode1();
			
			
			touchPanel.dPadUpBtnMode2.pressStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			touchPanel.dPadUpBtnMode2.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
				
			touchPanel.dPadDownBtnMode2.pressStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			touchPanel.dPadDownBtnMode2.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			
			touchPanel.dPadInBtnMode2.pressStr = OmegaControlStrings.BACK_REARWARD;
			touchPanel.dPadInBtnMode2.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			
			touchPanel.dPadOutBtnMode2.pressStr = OmegaControlStrings.BACK_FORWARD;
			touchPanel.dPadOutBtnMode2.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			touchPanel.controlMode2Txt.text = "Back Angle";
			touchPanel.zoneGraphicAssmMode2.mode2();
				
			
			touchPanel.dPadUpBtnMode3.pressStr = OmegaControlStrings.LUMBAR_UP;
			touchPanel.dPadUpBtnMode3.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
				
			touchPanel.dPadDownBtnMode3.pressStr = OmegaControlStrings.LUMBAR_DOWN;
			touchPanel.dPadDownBtnMode3.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			
			touchPanel.dPadInBtnMode3.pressStr = OmegaControlStrings.LUMBAR_REARWARD;
			touchPanel.dPadInBtnMode3.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			
			touchPanel.dPadOutBtnMode3.pressStr = OmegaControlStrings.LUMBAR_FORWARD;
			touchPanel.dPadOutBtnMode3.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			touchPanel.controlMode3Txt.text = "Lumbar";
			touchPanel.zoneGraphicAssmMode3.mode3();
				
			
			touchPanel.dPadUpBtnMode4.pressStr = OmegaControlStrings.CUSHION_REAR_UP;
			touchPanel.dPadUpBtnMode4.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			
			touchPanel.dPadDownBtnMode4.pressStr = OmegaControlStrings.CUSHION_REAR_DOWN;
			touchPanel.dPadDownBtnMode4.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			
			touchPanel.dPadInBtnMode4.pressStr = OmegaControlStrings.SEAT_REARWARD;
			touchPanel.dPadInBtnMode4.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			
			touchPanel.dPadOutBtnMode4.pressStr = OmegaControlStrings.SEAT_FOWARD;
			touchPanel.dPadOutBtnMode4.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			touchPanel.controlMode4Txt.text = "Fore/Aft Up/Down";
			touchPanel.zoneGraphicAssmMode4.mode4();
		}
	
		
		private function controlPressedEvent(e:DataEvent):void 
		{
			trace("e.data: " + e.data);
			//connectionPanel.targetSeatId		
			connectionPanel.sendToQue("AT SH " + connectionPanel.targetSeatId);
			connectionPanel.sendToQue(e.data);			
		}		
		
	}

}