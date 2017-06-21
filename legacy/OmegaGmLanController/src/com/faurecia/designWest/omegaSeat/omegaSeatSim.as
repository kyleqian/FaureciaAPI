package com.faurecia.designWest.omegaSeat
{
	import com.faurecia.designWest.commonAssets.FaureciaLogoMc;
	import com.greensock.easing.Quad;
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author jimF
	 */
	public class omegaSeatSim extends MovieClip
	{
		public var logoMc:FaureciaLogoMc;
		public var omegaPanelAssm:MovieClip;
		
		public var offVal:Number = .25;
		
		public function omegaSeatSim()
		{
			super();
			//trace("howdy");
			//testMove();
			
		
		}
		
		private function testMove()
		{
			TweenMax.to(logoMc, Math.random() * 3 + 1.5, {x: Math.random() * 1920, y: Math.random() * 1080, ease: Quad.easeInOut, onComplete: testMove});
		}
	
	}

}