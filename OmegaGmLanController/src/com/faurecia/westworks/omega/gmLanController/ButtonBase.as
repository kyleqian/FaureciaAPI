package  com.faurecia.westworks.omega.gmLanController 
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import com.greensock.*;
	import com.greensock.plugins.*;
	TweenPlugin.activate([ColorMatrixFilterPlugin]);
	//TweenPlugin.activate([TintPlugin]);
	
	
	public class ButtonBase extends MovieClip {
		private var _pressTint:int = 0x3333ff;
		private var _id:String = "";
		public var homeX:Number = 0;
		public var homeY:Number = 0;
		
		public function ButtonBase() {
			addEventListener(Event.ADDED_TO_STAGE, startUpEvent);
		}
		
		private function startUpEvent(e:Event):void 
		{
			addEventListener(MouseEvent.MOUSE_DOWN, mousePressedEvent);
			addEventListener(MouseEvent.CLICK, mouseClickEvent);
			this.buttonMode = true;
		}
		
		private function mouseClickEvent(e:MouseEvent):void 
		{
			//Object(root).sendCommand(_id);
		}
		
		private function mousePressedEvent(e:MouseEvent){
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseReleasedEvent);
			TweenMax.to(this, .10, { alpha: .7, colorMatrixFilter: { colorize: _pressTint, amount:.3 }} );
		}
		
		private function  mouseReleasedEvent(e:MouseEvent){
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseReleasedEvent);
			TweenMax.to(this, .35, {alpha: 1,  colorMatrixFilter:{amount:0}});
		}
		
		public function set pressTint(tint:int){
			_pressTint = tint;
		}
		
		public function get id():String 
		{
			return _id;
		}
		
		public function set id(value:String):void 
		{
			_id = value;
		}
	}
	
}
