package com.faurecia.westworks.omega.gmLanController 
{
	import com.faurecia.designWest.omegaSeat.MassageIntensityAssm;
	import com.faurecia.designWest.omegaSeat.MassageModeAssm;
	import com.faurecia.designWest.omegaSeat.SeatZoneAssm;
	import com.faurecia.designWest.omegaSeat.SettingsPanelMc;
	import com.faurecia.designWest.omegaSeat.TouchArea;
	import com.faurecia.designWest.omegaSeat.TouchPanelAssembly;
	import flash.display.MovieClip;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author jimF
	 */
	public class OmegaTouchPanelObdController extends MovieClip 
	{
		public var volumeBtn:ButtonBase;
		public var touchPanel:TouchPanelAssembly;
		//public var touchPanelRight:TouchPanelAssembly;
		public var backgroundMc:MovieClip;
		
		public var connectionPanel:OmegaObdSettingsPanel;
		public var controlModeTxt:TextField;
		
		
		public var messagePanelTxt:TextField;
		
		public var offVal:Number = .25;
		
		public var settingsPanel:SettingsPanelMc;
		
		//public var headrestAudioBtn:TouchArea;
		
		//public var audioIconMc:MovieClip;
		
		 
		public var soundTrackA:Sound;
		//public var soundTrackB:Sound;
		private var audioChannel:SoundChannel;
		private var musicPlaying:Boolean = false;
		private var pausePos:int = 0;
		private var playListAry:Array;
		private var playListAryIdx:int;
		private var tempSoundTransform:SoundTransform;
		
		
		public function OmegaTouchPanelObdController() 
		{
			trace("OmegaTouchPanelObdController");
			setUpBtns();
			stage.addEventListener(ButtonAssm.PRESSED, controlPressedEvent);
			stage.addEventListener(ButtonAssm.RELEASED, controlPressedEvent);
			
			stage.addEventListener(SeatZoneAssm.FOUR_WAY_MODE, updateButtonModeEvent);
			stage.addEventListener(MassageModeAssm.MASSAGE_MODE_CHANGE, updateMassageModeEvent);
			
			stage.addEventListener(MassageIntensityAssm.MASSAGE_INTESITY_CHANGE, updateMassageIntensityEvent);
			touchPanel.hapticIntensityDotAssm.eventName = MassageIntensityAssm.HAPTIC_INTESITY_CHANGE;
			stage.addEventListener(MassageIntensityAssm.HAPTIC_INTESITY_CHANGE, updateHapticIntensityEvent);
			
			stage.addEventListener(TouchPanelAssembly.HAPTIC_SETTINGS_CHANGED, updateHapticStateEvent);
			
			stage.addEventListener(TouchPanelAssembly.MASSAGE_OFF, massageOffEvent);
			stage.addEventListener(TouchPanelAssembly.MASSAGE_ON, massageOnEvent);
			stage.addEventListener(OmegaObdSettingsPanel.MASSAGE_OFF, dismissMassageControlsEvent);
			
			//headrestAudioBtn.addEventListener(MouseEvent.CLICK, musicPlayPause);
			//soundTrackA = new SoundTrackA();
			//soundTrackB = new SoundTrackB();
			audioChannel = new SoundChannel();
			//audioChannel = soundTrackA.play(0, 999);
			//audioChannel = soundTrackA.play(0, int.MAX_VALUE);
			setTimeout(updateVolumeLevelEvent,2000);

			
			controlModeTxt.text = "";
			controlModeTxt.visible = false;
			
			volumeBtn.homeX = volumeBtn.x;
			volumeBtn.homeY = volumeBtn.y;
			volumeBtn.addEventListener(MouseEvent.MOUSE_DOWN, volumePressedEvent);
		}
		
		private function volumePressedEvent(e:MouseEvent):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, volumeReleasedEvent);
			volumeBtn.startDrag(false, new Rectangle(volumeBtn.homeX, volumeBtn.homeY, 200, 0));
			volumeBtn.addEventListener(Event.ENTER_FRAME, updateVolumeLevelEvent);
		}
		
		private function updateVolumeLevelEvent(e:Event = null):void 
		{
			tempSoundTransform = new SoundTransform();
			tempSoundTransform.volume = (volumeBtn.x - volumeBtn.homeX) / 200;
			audioChannel.soundTransform = tempSoundTransform; 
			//trace(audioChannel.soundTransform.volume);
		}
		
		private function volumeReleasedEvent(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, volumeReleasedEvent);
			volumeBtn.removeEventListener(Event.ENTER_FRAME, updateVolumeLevelEvent);
			volumeBtn.stopDrag();
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
		
		/*private function nextTrackClick(e:MouseEvent):void 
		{
			nextTrack();
		}
		private function nextTrack() {
			
			pausePos = 0;
			audioChannel.stop();
			playListAryIdx = (playListAryIdx + 1) % playListAry.length;
			audioChannel = playListAry[playListAryIdx].play(pausePos);
			
		}
		
		private function musicPlayPause(e:MouseEvent):void 
		{
			
			trace("musicPlayPause");
			if (musicPlaying == false) {
					audioChannel = playListAry[playListAryIdx].play(pausePos);
					musicPlaying = true;
					audioIconMc.visible = true;
			}else {
				pausePos = audioChannel.position;
				audioChannel.stop();
				audioIconMc.visible = false;
				musicPlaying = false;
			}
			
		}*/
		
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
			/*massageABtn.clickStr = OmegaControlStrings.MASSAGE_TYPE_1
			massageBBtn.clickStr = OmegaControlStrings.MASSAGE_TYPE_2;
			massageCBtn.clickStr = OmegaControlStrings.MASSAGE_TYPE_5;
			massageDBtn.clickStr = OmegaControlStrings.MASSAGE_TYPE_6;
			massageEBtn.clickStr = OmegaControlStrings.MASSAGE_TYPE_7;*/
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
		
		private function updateButtonModeEvent(e:DataEvent):void 
		{
			/* mode1: 'slouch' controls
			 * mode2: back angle
			 * mode3: lumbar
			 * mode4: seat height/ fore aft
			 * 
			 * 
			 * 
			 * 
			 * 
			 * 
			 * 
			 * 
			 * 
			 * 
			 * 
			 * 
			 */
			
			switch (e.data) {
			case "mode1":				
			
				touchPanel.dPadUpBtn.pressStr = OmegaControlStrings.MSM_CONTROLS_OFF;
				touchPanel.dPadUpBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
				
				touchPanel.dPadDownBtn.pressStr = OmegaControlStrings.MSM_CONTROLS_OFF;
				touchPanel.dPadDownBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			
				touchPanel.dPadInBtn.pressStr = OmegaControlStrings.HEADREST_REARWARD
				touchPanel.dPadInBtn.releaseStr = OmegaControlStrings.MBM_CONTROLS_OFF;
			
				touchPanel.dPadOutBtn.pressStr = OmegaControlStrings.HEADREST_FORWARD;
				touchPanel.dPadOutBtn.releaseStr = OmegaControlStrings.MBM_CONTROLS_OFF;
				controlModeTxt.text = "Slouch";
				break;
			case "mode2":				
			
				touchPanel.dPadUpBtn.pressStr = OmegaControlStrings.MSM_CONTROLS_OFF;
				touchPanel.dPadUpBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
				
				touchPanel.dPadDownBtn.pressStr = OmegaControlStrings.MSM_CONTROLS_OFF;
				touchPanel.dPadDownBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			
				touchPanel.dPadInBtn.pressStr = OmegaControlStrings.BACK_REARWARD;
				touchPanel.dPadInBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			
				touchPanel.dPadOutBtn.pressStr = OmegaControlStrings.BACK_FORWARD;
				touchPanel.dPadOutBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
				controlModeTxt.text = "Back Angle";
				break;
			case "mode3":				
			
				touchPanel.dPadUpBtn.pressStr = OmegaControlStrings.LUMBAR_UP;
				touchPanel.dPadUpBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
				
				touchPanel.dPadDownBtn.pressStr = OmegaControlStrings.LUMBAR_DOWN;
				touchPanel.dPadDownBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			
				touchPanel.dPadInBtn.pressStr = OmegaControlStrings.LUMBAR_REARWARD;
				touchPanel.dPadInBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			
				touchPanel.dPadOutBtn.pressStr = OmegaControlStrings.LUMBAR_FORWARD;
				touchPanel.dPadOutBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
				controlModeTxt.text = "Lumbar";
				break;
			case "mode4":				
			
				touchPanel.dPadUpBtn.pressStr = OmegaControlStrings.CUSHION_REAR_UP;
				touchPanel.dPadUpBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
				
				touchPanel.dPadDownBtn.pressStr = OmegaControlStrings.CUSHION_REAR_DOWN;
				touchPanel.dPadDownBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			
				touchPanel.dPadInBtn.pressStr = OmegaControlStrings.SEAT_REARWARD;
				touchPanel.dPadInBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			
				touchPanel.dPadOutBtn.pressStr = OmegaControlStrings.SEAT_FOWARD;
				touchPanel.dPadOutBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
				controlModeTxt.text = "Fore/Aft Up/Down";
				break;
			
			case "mode5":				
			
				touchPanel.dPadUpBtn.pressStr = OmegaControlStrings.CUSHION_FRONT_UP;
				touchPanel.dPadUpBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
				
				touchPanel.dPadDownBtn.pressStr = OmegaControlStrings.CUSHION_FRONT_DOWN;
				touchPanel.dPadDownBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			
				touchPanel.dPadInBtn.pressStr = OmegaControlStrings.THIGH_BOLSTER_REARWARD;
				touchPanel.dPadInBtn.releaseStr = OmegaControlStrings.MBM_CONTROLS_OFF;
			
				touchPanel.dPadOutBtn.pressStr = OmegaControlStrings.THIGH_BOLSTER_FORWARD;
				touchPanel.dPadOutBtn.releaseStr = OmegaControlStrings.MBM_CONTROLS_OFF;
				controlModeTxt.text = "Thigh Bolster";
				break;
			
			
			case "mode6":				
			
				touchPanel.dPadUpBtn.pressStr = OmegaControlStrings.CUSHION_BOLSTER_OUTWARD;
				touchPanel.dPadUpBtn.releaseStr = OmegaControlStrings.MBM_CONTROLS_OFF;
				
				touchPanel.dPadDownBtn.pressStr = OmegaControlStrings.CUSHION_BOLSTER_INWARD
				touchPanel.dPadDownBtn.releaseStr = OmegaControlStrings.MBM_CONTROLS_OFF;
			
				touchPanel.dPadInBtn.pressStr = OmegaControlStrings.BACK_BOLSTER_INWARD;
				touchPanel.dPadInBtn.releaseStr = OmegaControlStrings.MBM_CONTROLS_OFF;
			
				touchPanel.dPadOutBtn.pressStr = OmegaControlStrings.BACK_BOLSTER_OUTWARD
				touchPanel.dPadOutBtn.releaseStr = OmegaControlStrings.MBM_CONTROLS_OFF;
				controlModeTxt.text = "Back Bolster / Cushion Bolster";
				//OmegaControlStrings.
				break;
			
			
			case "mode7":				
			
				touchPanel.dPadUpBtn.pressStr = OmegaControlStrings.HAPTIC_ON;
				touchPanel.dPadUpBtn.releaseStr = OmegaControlStrings.HAPTIC_OFF;
				
				touchPanel.dPadDownBtn.pressStr = OmegaControlStrings.HAPTIC_ON_LOW;
				touchPanel.dPadDownBtn.releaseStr = OmegaControlStrings.HAPTIC_OFF;
			
				touchPanel.dPadInBtn.pressStr = OmegaControlStrings.HAPTIC_ON_RIGHT;
				touchPanel.dPadInBtn.releaseStr = OmegaControlStrings.HAPTIC_OFF;
			
				touchPanel.dPadOutBtn.pressStr = OmegaControlStrings.HAPTIC_ON_LEFT;
				touchPanel.dPadOutBtn.releaseStr = OmegaControlStrings.HAPTIC_OFF;
				controlModeTxt.text = "Haptic";
				break;
			}
		}
		
		private function controlPressedEvent(e:DataEvent):void 
		{
			trace("e.data: " + e.data);
			//connectionPanel.targetSeatId
		
			connectionPanel.sendToQue("AT SH " + connectionPanel.targetSeatId);
			connectionPanel.sendToQue(e.data);
			
		}
		
		private function setUpBtns():void 
		{
			touchPanel.dPadDownBtn.pressStr = OmegaControlStrings.CUSHION_REAR_DOWN;
			touchPanel.dPadDownBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			
			touchPanel.dPadUpBtn.pressStr = OmegaControlStrings.CUSHION_REAR_UP;
			touchPanel.dPadUpBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			
			touchPanel.dPadInBtn.pressStr = OmegaControlStrings.SEAT_REARWARD;
			touchPanel.dPadInBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			
			touchPanel.dPadOutBtn.pressStr = OmegaControlStrings.SEAT_FOWARD;
			touchPanel.dPadOutBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
		}
		
	}

}