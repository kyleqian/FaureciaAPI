package com.faurecia.westworks.omega.gmLanController
{
	import com.faurecia.westworks.omega.gmLanController.ButtonAssm;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.net.Socket;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author jimF
	 */
	public class OmegeFrontSeatTestPanel extends Sprite
	{
		public var connectionPanel:OmegaObdSettingsPanel;
		
		public var seatForwardBtn:ButtonAssm;
		public var seatRearwardBtn:ButtonAssm;
		public var backForwardBtn:ButtonAssm;
		public var backRearwardBtn:ButtonAssm;
		
		public var cushionFrontUpBtn:ButtonAssm;
		public var cushionFrontDownBtn:ButtonAssm;
		public var cushionBackUpBtn:ButtonAssm;
		public var cushionBackDownBtn:ButtonAssm;
		
		public var lumbarUpBtn:ButtonAssm;
		public var lumbarDownBtn:ButtonAssm;
		public var lumbarForwardBtn:ButtonAssm;
		public var lumbarRearwardBtn:ButtonAssm;
		
		public var headrestUpBtn:ButtonAssm;
		public var headrestDownBtn:ButtonAssm;
		public var headrestForwardBtn:ButtonAssm;
		public var headrestRearwardBtn:ButtonAssm;
		public var thighForwardBtn:ButtonAssm;
		public var thighRearwardBtn:ButtonAssm;
		public var cushionBolsterInBtn:ButtonAssm;
		public var cushionBolsterOutBtn:ButtonAssm;
		public var shoulderBolsterInBtn:ButtonAssm;
		public var shoulderBolsterOutBtn:ButtonAssm;
		public var backBolsterInBtn:ButtonAssm;
		public var backBolsterOutBtn:ButtonAssm;
		
		public var massageIntensOffBtn:ButtonAssm;
		public var massageIntens1Btn:ButtonAssm;
		public var massageIntens2Btn:ButtonAssm;
		public var massageIntens3Btn:ButtonAssm;
		
		public var massageABtn:ButtonAssm;
		public var massageBBtn:ButtonAssm;
		public var massageCBtn:ButtonAssm;
		public var massageDBtn:ButtonAssm;
		public var massageEBtn:ButtonAssm;
		public var massageFBtn:ButtonAssm;
		
		public var hapticOnBtn:ButtonAssm;
		
		public var currentMassageModeTxt:TextField;
		public var currentMassageIntensityTxt:TextField;
		public var massageMessageTxt:TextField;				
		
		public function OmegeFrontSeatTestPanel()
		{
			trace("OmegeFrontSeatTestPanel");
			
			setUpCommands();
			stage.addEventListener(ButtonAssm.PRESSED, controlPressedEvent);
			stage.addEventListener(ButtonAssm.RELEASED, controlPressedEvent);
			
			currentMassageModeTxt.text = connectionPanel.currentMassageProgram;
			currentMassageIntensityTxt.text = connectionPanel.currentMassageIntensity;			
		}		
		
		private function controlPressedEvent(e:DataEvent):void 
		{
			trace("e.data: " + e.data);
		
			connectionPanel.sendToQue("AT SH " + OmegaControlStrings.OMEGA_HEADER);
			connectionPanel.sendToQue(e.data);			
		}
		
		private function setUpCommands():void
		{
			seatForwardBtn.pressStr = OmegaControlStrings.SEAT_FOWARD;
			seatForwardBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			
			seatRearwardBtn.pressStr = OmegaControlStrings.SEAT_REARWARD;
			seatRearwardBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			
			backForwardBtn.pressStr = OmegaControlStrings.BACK_FORWARD;
			backForwardBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			
			backRearwardBtn.pressStr = OmegaControlStrings.BACK_REARWARD;
			backRearwardBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
						
			cushionFrontUpBtn.pressStr = OmegaControlStrings.CUSHION_FRONT_UP;
			cushionFrontUpBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			
			cushionFrontDownBtn.pressStr = OmegaControlStrings.CUSHION_FRONT_DOWN;
			cushionFrontDownBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			
			cushionBackUpBtn.pressStr = OmegaControlStrings.CUSHION_REAR_UP;
			cushionBackUpBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			
			cushionBackDownBtn.pressStr = OmegaControlStrings.CUSHION_REAR_DOWN;
			cushionBackDownBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;			
			
			lumbarUpBtn.pressStr = OmegaControlStrings.LUMBAR_UP;
			lumbarUpBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			
			lumbarDownBtn.pressStr = OmegaControlStrings.LUMBAR_DOWN;
			lumbarDownBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			
			lumbarForwardBtn.pressStr = OmegaControlStrings.LUMBAR_FORWARD;
			lumbarForwardBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;
			
			lumbarRearwardBtn.pressStr = OmegaControlStrings.LUMBAR_REARWARD;
			lumbarRearwardBtn.releaseStr = OmegaControlStrings.MSM_CONTROLS_OFF;			
			
			headrestUpBtn.pressStr = OmegaControlStrings.HEADREST_UP;
			headrestUpBtn.releaseStr = OmegaControlStrings.MBM_CONTROLS_OFF;
			
			headrestDownBtn.pressStr = OmegaControlStrings.HEADREST_DOWN;			
			headrestDownBtn.releaseStr = OmegaControlStrings.MBM_CONTROLS_OFF;
			
			headrestForwardBtn.pressStr = OmegaControlStrings.HEADREST_FORWARD;
			headrestForwardBtn.releaseStr = OmegaControlStrings.MBM_CONTROLS_OFF;
			
			headrestRearwardBtn.pressStr = OmegaControlStrings.HEADREST_REARWARD;
			headrestRearwardBtn.releaseStr = OmegaControlStrings.MBM_CONTROLS_OFF;
			
			thighForwardBtn.pressStr = OmegaControlStrings.THIGH_BOLSTER_FORWARD;
			thighForwardBtn.releaseStr = OmegaControlStrings.MBM_CONTROLS_OFF;
			
			thighRearwardBtn.pressStr = OmegaControlStrings.THIGH_BOLSTER_REARWARD;
			thighRearwardBtn.releaseStr = OmegaControlStrings.MBM_CONTROLS_OFF;
			
			cushionBolsterInBtn.pressStr = OmegaControlStrings.CUSHION_BOLSTER_INWARD;
			cushionBolsterInBtn.releaseStr = OmegaControlStrings.MBM_CONTROLS_OFF;
			
			cushionBolsterOutBtn.pressStr = OmegaControlStrings.CUSHION_BOLSTER_OUTWARD;
			cushionBolsterOutBtn.releaseStr = OmegaControlStrings.MBM_CONTROLS_OFF;
			
			shoulderBolsterInBtn.pressStr = OmegaControlStrings.SHOULDER_BOLSTER_FORWARD;
			shoulderBolsterInBtn.releaseStr = OmegaControlStrings.MBM_CONTROLS_OFF;
			
			shoulderBolsterOutBtn.pressStr = OmegaControlStrings.SHOULDER_BOLSTER_REARWARD;
			shoulderBolsterOutBtn.releaseStr = OmegaControlStrings.MBM_CONTROLS_OFF;
			
			backBolsterInBtn.pressStr = OmegaControlStrings.BACK_BOLSTER_INWARD;
			backBolsterInBtn.releaseStr = OmegaControlStrings.MBM_CONTROLS_OFF;
			
			backBolsterOutBtn.pressStr = OmegaControlStrings.BACK_BOLSTER_INWARD;
			backBolsterOutBtn.releaseStr = OmegaControlStrings.MBM_CONTROLS_OFF;
			
			massageIntensOffBtn.clickStr = OmegaControlStrings.MASSAGE_INTENSITY_0_OFF;
			massageIntens1Btn.clickStr = OmegaControlStrings.MASSAGE_INTENSITY_1;
			massageIntens2Btn.clickStr = OmegaControlStrings.MASSAGE_INTENSITY_2;
			massageIntens3Btn.clickStr = OmegaControlStrings.MASSAGE_INTENSITY_3;

			massageIntensOffBtn.addEventListener(MouseEvent.CLICK,turnMassageOffClick);
			massageIntens1Btn.addEventListener(MouseEvent.CLICK, setMassageIntensityClick);
			massageIntens2Btn.addEventListener(MouseEvent.CLICK, setMassageIntensityClick);
			massageIntens3Btn.addEventListener(MouseEvent.CLICK, setMassageIntensityClick);
			
			massageABtn.clickStr = OmegaControlStrings.MASSAGE_TYPE_1
			massageBBtn.clickStr = OmegaControlStrings.MASSAGE_TYPE_2;
			massageCBtn.clickStr = OmegaControlStrings.MASSAGE_TYPE_5;
			massageDBtn.clickStr = OmegaControlStrings.MASSAGE_TYPE_6;
			massageEBtn.clickStr = OmegaControlStrings.MASSAGE_TYPE_7;
			massageFBtn.clickStr = OmegaControlStrings.MASSAGE_TYPE_11;
			
			massageMessageTxt.text = OmegaControlStrings.MASSAGE_TYPE_11;
			//massageGBtn.clickStr = OmegaControlStrings.MASSAGE_TYPE_11;
			
			massageABtn.addEventListener(MouseEvent.CLICK, setMassageTypeClick);
			massageBBtn.addEventListener(MouseEvent.CLICK, setMassageTypeClick);
			massageCBtn.addEventListener(MouseEvent.CLICK, setMassageTypeClick);
			massageDBtn.addEventListener(MouseEvent.CLICK, setMassageTypeClick);
			massageEBtn.addEventListener(MouseEvent.CLICK, setMassageTypeClick);
			massageFBtn.addEventListener(MouseEvent.CLICK, setTextStringTypeClick);
			
			
			//massageGBtn.addEventListener(MouseEvent.CLICK, setMassageTypeClick);			
			
			hapticOnBtn.pressStr = OmegaControlStrings.HAPTIC_ON;
			hapticOnBtn.releaseStr = OmegaControlStrings.HAPTIC_OFF;//"07 AE 35 03 FF FF 00 00 "
		}
		
		
		
		private function turnMassageOffClick(e:MouseEvent):void 
		{
			//connectionPanel.send
			connectionPanel.sendToQue("AT SH " + OmegaControlStrings.OMEGA_HEADER);
			connectionPanel.sendToQue(OmegaControlStrings.MASSAGE_COMMON_MESSAGE + OmegaControlStrings.MASSAGE_INTENSITY_0_OFF + OmegaControlStrings.MASSAGE_TYPE_0);
			connectionPanel.sendToQue(OmegaControlStrings.MASSAGE_STOP_ALL);			
		}
		
		private function setMassageIntensityClick(e:MouseEvent):void 
		{
			trace(e.currentTarget.clickStr); 
			connectionPanel.currentMassageIntensity = e.currentTarget.clickStr;
			currentMassageIntensityTxt.text = connectionPanel.currentMassageIntensity;
			connectionPanel.updateMassageState();
		}
		
		private function setMassageTypeClick(e:MouseEvent):void 
		{
			trace(e.currentTarget.clickStr);
			connectionPanel.currentMassageProgram = e.currentTarget.clickStr;
			currentMassageModeTxt.text = connectionPanel.currentMassageProgram;
			connectionPanel.updateMassageState();
		}
		
		private function setTextStringTypeClick(e:MouseEvent):void 
		{			
			connectionPanel.currentMassageProgram = massageMessageTxt.text;
			currentMassageModeTxt.text = connectionPanel.currentMassageProgram;
			connectionPanel.updateMassageState();
		}	
	}

}