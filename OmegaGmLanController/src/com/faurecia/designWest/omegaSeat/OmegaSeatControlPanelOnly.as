package com.faurecia.designWest.omegaSeat
{
	
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	import flash.text.TextField;
	
	public class OmegaSeatControlPanelOnly extends MovieClip
	{
		
		public var omegaPanelAssm:OmegaTouchPanelAssm;
		public var logoMc:MovieClip;
		
		
		public var messagePanelTxt:TextField;
		
		public var offVal:Number = .25;
		
		public var settingsPanel:SettingsPanelMc;
		
		public function OmegaSeatControlPanelOnly()
		{
			messagePanelTxt.text = "";
			//stage.addEventListener(MouseEvent.CLICK, mouseClickedEvent);
			
			omegaPanelAssm.touchPanelLeft.dPadUpBtn.addEventListener(MouseEvent.MOUSE_DOWN, function()
			{
				messagePanelTxt.text = "Left Up Pressed";
			});
			omegaPanelAssm.touchPanelLeft.dPadUpBtn.addEventListener(MouseEvent.MOUSE_UP, function()
			{
				messagePanelTxt.text = "";
			});
			
			omegaPanelAssm.touchPanelLeft.dPadDownBtn.addEventListener(MouseEvent.MOUSE_DOWN, function()
			{
				messagePanelTxt.text = "Left Down Pressed";
			});
			omegaPanelAssm.touchPanelLeft.dPadDownBtn.addEventListener(MouseEvent.MOUSE_UP, function()
			{
				messagePanelTxt.text = "";
			});
			
			omegaPanelAssm.touchPanelLeft.dPadInBtn.addEventListener(MouseEvent.MOUSE_DOWN, function()
			{
				messagePanelTxt.text = "Left Aft Pressed";
			});
			omegaPanelAssm.touchPanelLeft.dPadInBtn.addEventListener(MouseEvent.MOUSE_UP, function()
			{
				messagePanelTxt.text = "";
			});
			
			omegaPanelAssm.touchPanelLeft.dPadOutBtn.addEventListener(MouseEvent.MOUSE_DOWN, function()
			{
				messagePanelTxt.text = "Left Fore Pressed";
			});
			omegaPanelAssm.touchPanelLeft.dPadOutBtn.addEventListener(MouseEvent.MOUSE_UP, function()
			{
				messagePanelTxt.text = "";
			});
			
			omegaPanelAssm.touchPanelRight.dPadUpBtn.addEventListener(MouseEvent.MOUSE_DOWN, function()
			{
				messagePanelTxt.text = "Right Up Pressed";
			});
			omegaPanelAssm.touchPanelRight.dPadUpBtn.addEventListener(MouseEvent.MOUSE_UP, function()
			{
				messagePanelTxt.text = "";
			});
			
			omegaPanelAssm.touchPanelRight.dPadDownBtn.addEventListener(MouseEvent.MOUSE_DOWN, function()
			{
				messagePanelTxt.text = "Right Down Pressed";
			});
			omegaPanelAssm.touchPanelRight.dPadDownBtn.addEventListener(MouseEvent.MOUSE_UP, function()
			{
				messagePanelTxt.text = "";
			});
			
			omegaPanelAssm.touchPanelRight.dPadInBtn.addEventListener(MouseEvent.MOUSE_DOWN, function()
			{
				messagePanelTxt.text = "Right Aft Pressed";
			});
			omegaPanelAssm.touchPanelRight.dPadInBtn.addEventListener(MouseEvent.MOUSE_UP, function()
			{
				messagePanelTxt.text = "";
			});
			
			omegaPanelAssm.touchPanelRight.dPadOutBtn.addEventListener(MouseEvent.MOUSE_DOWN, function()
			{
				messagePanelTxt.text = "Right Fore Pressed";
			});
			omegaPanelAssm.touchPanelRight.dPadOutBtn.addEventListener(MouseEvent.MOUSE_UP, function()
			{
				messagePanelTxt.text = "";
			});
			
			//var screenDpi:int = Capabilities.screenDPI;
			//trace(screenDpi + " dpi");
			//if (screenDpi > 200) {
			//scale touchscreen to hit target size
			//omegaPanelAssm.scaleX = omegaPanelAssm.scaleY =  (7.245 * screenDpi)/741.25;
			//}
			
			settingsPanel.visible = false;
			settingsPanel.homeX = settingsPanel.x;
			settingsPanel.x = settingsPanel.homeX + settingsPanel.width;
			
			logoMc.addEventListener(MouseEvent.CLICK, deployDismissSettingsPanel);
			settingsPanel.listDimOnOffMc.addEventListener(MouseEvent.CLICK, toggleDimmedItems);
			settingsPanel.listDimOnOffMc.buttonMode = true;
			
			settingsPanel.toggleTouchPointsMc.addEventListener(MouseEvent.CLICK, toggleTouchTargetDisplay);
		
		}
		
		private function toggleTouchTargetDisplay(e:MouseEvent):void 
		{
			stage.dispatchEvent(new Event(TouchArea.TOGGLE_TOUCH_AREAS));			
		}
		
		private function toggleDimmedItems(e:MouseEvent):void
		{
			if (offVal == 0) {
				offVal = .25;
			}else {
				offVal = 0;
			}
			//trace("UPDATE_DIM_VALUE   offVal : " + offVal);
			stage.dispatchEvent( new Event("UPDATE_DIM_VALUE"));
		
		}
		
		private function deployDismissSettingsPanel(e:MouseEvent):void
		{
			TweenMax.to(settingsPanel, .35, {autoAlpha: (settingsPanel.x == settingsPanel.homeX) ? 0 : 1, x: (settingsPanel.x == settingsPanel.homeX) ? (settingsPanel.homeX + settingsPanel.width) : settingsPanel.homeX});
		}
		
		private function mouseClickedEvent(e:MouseEvent):void
		{
			
			if ((stage.mouseX < 100) && (stage.mouseY < 100))
			{
				//trace("clicked");
				stage.dispatchEvent(new Event(TouchArea.TOGGLE_TOUCH_AREAS));
			}
		}
	}

}
